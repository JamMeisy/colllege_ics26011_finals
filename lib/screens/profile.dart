import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thomasian_post/widgets/drawer.dart';
import 'package:thomasian_post/screens/events/my_events.dart';
import 'package:thomasian_post/screens/auth/login.dart';
import 'package:thomasian_post/screens/events/discover_events.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<User?> _userFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userFuture = _reloadUser();
  }

  Future<User?> _reloadUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await user.reload();
        user = _auth.currentUser;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to reload user data: ${e.toString()}')),
        );
      }
    }
    return user;
  }

  String _extractUsername(String email) {
    return email.split('@').first;
  }

  Future<void> _handleSignOut() async {
    setState(() => _isLoading = true);
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ViewEventList()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign out: ${e.toString()}'),
          duration: const Duration(seconds: 1),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF1A1A1A), // accentBlack
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Center(
          child: FutureBuilder<User?>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _userFuture = _reloadUser();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('User not signed in'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC000), // darkYellow
                      ),
                    ),
                  ],
                );
              } else {
                User user = snapshot.data!;
                String username = _extractUsername(user.email!);
                return RefreshIndicator(
                  onRefresh: () => _reloadUser(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  const Color(0xFFFFF8DC), // lightYellow
                              child: user.photoURL != null
                                  ? ClipOval(
                                      child: Image.network(
                                        user.photoURL!,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.person,
                                          size: 60,
                                          color: const Color(
                                              0xFFFFD700), // primaryYellow
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 60,
                                      color: const Color(
                                          0xFFFFD700), // primaryYellow
                                    ),
                            ),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  const Color(0xFFFFD700), // primaryYellow
                              child: IconButton(
                                icon: const Icon(Icons.edit, size: 16),
                                color: Colors.white,
                                onPressed: () {
                                  // TODO: Implement profile picture update
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Profile picture update coming soon!')),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A), // accentBlack
                          ),
                        ),
                        Text(
                          user.email ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1A1A1A), // accentBlack
                          ),
                        ),
                        const SizedBox(height: 32),
                        _ProfileButton(
                          icon: Icons.calendar_today,
                          label: 'My Bookings',
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyEventsPage()),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _ProfileButton(
                          icon: Icons.settings,
                          label: 'Settings',
                          onPressed: () {
                            // TODO: Implement settings page
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Settings page coming soon!')),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _ProfileButton(
                          icon: Icons.help_outline,
                          label: 'Help & Support',
                          onPressed: () {
                            // TODO: Implement help page
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Help page coming soon!')),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton.icon(
                                icon: const Icon(Icons.logout),
                                label: const Text('Sign Out'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFFDC143C), // rejectedColor
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(200, 45),
                                ),
                                onPressed: _handleSignOut,
                              ),
                        const SizedBox(height: 16),
                        TextButton.icon(
                          icon: const Icon(
                            Icons.home,
                            color: Color(0xFFFFD700), // primaryYellow
                          ),
                          label: const Text(
                            'Go to Home',
                            style: TextStyle(
                                color: Color(0xFF1A1A1A)), // accentBlack
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewEventList()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ProfileButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: Icon(icon, color: const Color(0xFFFFD700)), // primaryYellow
        label: Text(
          label,
          style: const TextStyle(color: Color(0xFF1A1A1A)), // accentBlack
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          backgroundColor: const Color(0xFFFFF8DC), // lightYellow
          alignment: Alignment.centerLeft,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
