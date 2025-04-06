import 'package:career_pulse/model/user_model.dart';
import 'package:career_pulse/service/auth/auth_gate.dart';
import 'package:career_pulse/service/firestore/handle_user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserDataHandler _userDataHandler = UserDataHandler();
  User? user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  final List<String> _occupations = [
    'Student',
    'Engineer',
    'Doctor',
    'Teacher',
    'Designer',
    'Other',
  ];
  String? _name;
  String? _email;
  String? _phone;
  String? _address;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _userDataHandler.getUserData(user).then((userData) {
      if (userData != null) {
        setState(() {
          _name = userData['name'];
          _email = userData['email'];
          _phone = userData['phone'];
          _address = userData['address'];
          _photoUrl = userData['photoUrl'];
        });
      }
    });
  }

  // Future<void> _fetchUserData() async {

  //   if (user != null) {
  //     // Assuming you have a method to fetch user data from Firestore or another source
  //     // For example:
  //     // DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  //     // setState(() {
  //     //   _firstName = userData['firstName'];
  //     //   _lastName = userData['lastName'];
  //     //   _about = userData['about'];
  //     //   _phoneNumber = userData['phoneNumber'];
  //     //   _selectedOccupation = userData['occupation'];
  //     // });

  //     // For demonstration, we'll use dummy data
  //     setState(() {
  //       _firstName = user.displayName;
  //       _lastName = 'Doe';
  //       _about = 'About John Doe';
  //       _phoneNumber = '1234567890';
  //       _selectedOccupation = 'Engineer';
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with Welcome message and avatar
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue, width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi! ${_name ?? ''}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const Text(
                                  'WELCOME',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: NetworkImage(
                                  _photoUrl ??
                                      'https://via.placeholder.com/150', // Placeholder image
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Form fields
                    TextFormField(
                      initialValue: _name,
                      decoration: InputDecoration(
                        labelText: 'First name',
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      initialValue: _name,
                      decoration: InputDecoration(
                        labelText: 'Last name',
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _name = value;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      initialValue: _address,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'About',
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _address = value;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Dropdown for occupation
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Occupation',
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      value: _occupations.first,
                      items:
                          _occupations.map((String occupation) {
                            return DropdownMenuItem<String>(
                              value: occupation,
                              child: Text(occupation),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _address = newValue;
                        });
                      },
                      icon: const Icon(Icons.arrow_drop_down),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      initialValue: _phone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        filled: true,
                        fillColor: Colors.blue.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _phone = value;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Save button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Save profile information
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated successfully!'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'SAVE PROFILE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
