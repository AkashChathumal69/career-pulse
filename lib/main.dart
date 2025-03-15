import 'package:career_pulse/firebase_options.dart';
import 'package:career_pulse/pages/home.dart';
import 'package:career_pulse/pages/profile.dart';
import 'package:career_pulse/pages/signup.dart';
import 'package:career_pulse/pages/login.dart';
import 'package:career_pulse/service/auth/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(debugShowCheckedModeBanner: false, home: MainScreen());

  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex), // Call _getPage method
      bottomNavigationBar: GNav(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          if (index == 1 && FirebaseAuth.instance.currentUser == null) {
            // If user selects Profile but is not logged in, redirect to login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ), // Navigate to main screen
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        haptic: true,
        tabs: [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.search, text: 'Search'),
          GButton(icon: Icons.person, text: 'Profile'),
        ],
      ),
    );
  }

  Widget _getPage(int index) {
    return [
      Dashboad(),
      ProfilePage(),
      // Replace with actual Search Page
    ][index];
  }
}
