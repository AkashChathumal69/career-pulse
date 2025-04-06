import 'package:career_pulse/pages/home.dart';
import 'package:career_pulse/service/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? user = FirebaseAuth.instance.currentUser;

  final AuthService _authService = AuthService();

  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;

      _authService.loginWithGmail(context);
    });

    try {
      if (user != null) {
        // Navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboad()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Career Pulse', style: TextStyle(color: Colors.black)),
        // ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //logo
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),

                    //Logo
                    Image.asset('assets/logo.png', height: 120, width: 120),
                    SizedBox(height: 20),

                    // Topic
                    Text(
                      'Login Here',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Email Fields
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                        ),
                        labelText: 'Email',
                      ),
                    ),
                    SizedBox(height: 20),

                    //Password Fields
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                        ),
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(height: 10),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot your password?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 3, 64, 170),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            3,
                            64,
                            170,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Log In",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // create new account
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 3, 64, 170),
                        fontSize: 16,
                      ),
                    ),

                    //or log with
                    SizedBox(height: 35),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey[400], thickness: 1),
                        ),

                        Text("or log in with"),
                        Expanded(
                          child: Divider(color: Colors.grey[400], thickness: 1),
                        ),
                      ],
                    ),

                    //google button
                    SizedBox(height: 35),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center the row content
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _handleGoogleSignIn,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/google.png', height: 30),
                                  SizedBox(width: 10),
                                  Text(
                                    "Google",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10),

                        // apple buttons
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/apple.png', height: 30),
                                  SizedBox(width: 10),
                                  Text(
                                    "Apple",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
