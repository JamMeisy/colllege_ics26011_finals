import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thomasian_post/screens/events/my_events.dart';
import 'package:thomasian_post/widgets/drawer.dart';
import 'package:thomasian_post/screens/auth/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscurePassword = true;
  bool _loading = false;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      if (!_isMounted) {
        return;
      }

      setState(() {
        _loading = true;
      });

      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
        _showSnackBar('Username and password are required');
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null && _isMounted) {
        _showSnackBar('Signed in as ${user.email}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyEventsPage(),
          ),
        );
      } else {
        _showSnackBar('Sign-in failed');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSnackBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showSnackBar('Wrong password provided for that user.');
      } else {
        _showSnackBar('Error during sign-in: ${e.message}');
      }
    } catch (error) {
      _showSnackBar('Error during sign-in');
    } finally {
      if (_isMounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Color(0xFFFFD700))),
        backgroundColor: Colors.black,
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Log in",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  color: Color(0xFFFFD700),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'Username',
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  fillColor: Color(0xFFFFF8DC),
                  filled: true,
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'Password',
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  fillColor: Color(0xFFFFF8DC),
                  filled: true,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                obscureText: _obscurePassword,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    ),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFFB900),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _signInWithEmailAndPassword,
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFFFC000)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: _loading
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                          : Text(
                        "Log in",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
