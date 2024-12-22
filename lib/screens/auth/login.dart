import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thomasian_post/screens/events/create_event.dart';
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
        return; // Check if the widget is still mounted
      }

      setState(() {
        _loading = true; // Set loading state for email/password sign-in
      });

      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
        // Check if username or password is empty
        _showSnackBar('Username and password are required');
        return;
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null && _isMounted) {
        // User signed in successfully
        _showSnackBar('Signed in as ${user.email}');

        // Navigate to BookingPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateEvent(),
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
      print('Email/Password Sign-In Error: $error');
      _showSnackBar('Error during sign-in');
    } finally {
      if (_isMounted) {
        setState(() {
          _loading = false; // Reset loading state for email/password sign-in
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      drawer: MyDrawer(),
      body: DoubleBackToCloseApp(
        child: Center(
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
                      color: Colors.deepPurple),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      hintText: 'username',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    hintText: 'password',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                      ),
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          )),
                      child: Text(
                        "Register Now",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _signInWithEmailAndPassword,
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.deepPurple),
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
                                "Sign in",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ),
        snackBar: SnackBar(
          content: Text('Tap back again to leave'),
        ),
      ),
    );
  }
}