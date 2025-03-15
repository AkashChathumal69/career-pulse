import 'package:career_pulse/main.dart';
import 'package:career_pulse/pages/home.dart';
import 'package:career_pulse/pages/login.dart';
import 'package:career_pulse/service/auth/auth_gate.dart';
import 'package:career_pulse/service/firestore/handle_user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserDataHandler _userDataHandler = UserDataHandler(); // Fixed typo
  // Fixed typo

  Future<void> loginWithGmail(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return; // User canceled sign-in
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        await _userDataHandler.handleUserData(user); // Fixed typo

        // Navigate to Dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()), // Fixed typo
          (route) => false, // Remove all previous routes
        );
      }
    } catch (e) {
      print("Error during Google Sign-In: ${e.toString()}");
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    await _googleSignIn.signOut();

    // Redirect to Login Page after signing out
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false, // Remove all previous routes
    );
  }
}
