
import 'package:career_pulse/pages/home.dart';
import 'package:career_pulse/pages/login.dart';

import 'package:career_pulse/service/firestore/handle_user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserDataHanndeler _userDataHanndeler = UserDataHanndeler();


  Future<void> loginWithGmail(BuildContext context) async {


    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _userDataHanndeler.handleUserData(user);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboad()),
          (route) => false, // Remove all previous routes
        );

      } else {}
    } catch (e) {
      print(e.toString());
      return null;
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
