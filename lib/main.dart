import 'package:career_pulse/firebase_options.dart';
import 'package:career_pulse/pages/category.dart';
import 'package:career_pulse/pages/gig_create.dart';
import 'package:career_pulse/pages/home.dart';
import 'package:career_pulse/pages/profile.dart';
import 'package:career_pulse/pages/signup.dart';
import 'package:career_pulse/pages/login.dart';
import 'package:career_pulse/pages/worker_profile.dart';
import 'package:career_pulse/service/auth/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,


      home: CategoryPage(),

      // theme: ThemeData(fontFamily: 'Poppins'),

      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: ProfilePage(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );
  static const List<Widget> _widgetOptions = <Widget>[
    Text("Home", style: optionStyle),
    Text("Categories", style: optionStyle),
    Text("Search", style: optionStyle),
    Text("Profile", style: optionStyle),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Pulse'),
        actions: [
          if (FirebaseAuth.instance.currentUser != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
        ],
      ),
      body: _getPage(_selectedIndex), // Call _getPage method
      bottomNavigationBar: Container(
        color: Color.fromARGB(
          255,
          0,
          35,
          114,
        ), /////////////////////////////////////////////
        child: Padding(
          padding: const EdgeInsets.all(8.0),

          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1)),
              ],
            ),
            height: 50,
            child: GNav(
              rippleColor: Colors.grey[300] ?? Colors.grey,
              hoverColor: Colors.grey[100] ?? Colors.grey,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 30,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              tabActiveBorder: Border.all(color: Colors.white),
              color: Colors.grey,

              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                if (index == 1 && FirebaseAuth.instance.currentUser == null) {
                  // If user selects Profile but is not logged in, redirect to login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
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
                GButton(icon: Icons.category, text: 'Categories'),
                GButton(icon: Icons.message, text: 'Chats'),
                GButton(icon: Icons.person, text: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    return [
      HomePage(),
      SignPage(),
      ProfilePage(),
      // Replace with actual Search Page
    ][index];
  }
}
