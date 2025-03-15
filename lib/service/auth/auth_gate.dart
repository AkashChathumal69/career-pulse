import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:career_pulse/pages/login.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      // Redirect to Login if not authenticated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return child; // Show the actual page if authenticated
  }
}
