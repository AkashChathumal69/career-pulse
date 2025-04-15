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
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;

  final UserDataHandler _userDataHandler = UserDataHandler();
  final _formKey = GlobalKey<FormState>();

  final List<String> _occupations = [
    'Student',
    'Engineer',
    'Doctor',
    'Teacher',
    'Designer',
    'Other',
  ];

  User? user = FirebaseAuth.instance.currentUser;

  String? _photoUrl;
  String? _selectedOccupation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _locationController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user == null) return;

    final userData = await _userDataHandler.getUserData(user);
    if (userData != null) {
      setState(() {
        _nameController.text = userData.name;
        _emailController.text = userData.email;
        _phoneController.text = userData.phone;
        _addressController.text = userData.address;
        _photoUrl = userData.photoUrl;
        _selectedOccupation = userData.occupation ?? _occupations.first;
        _locationController.text = userData.location;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (user == null) return;

    final updatedUser = UserData(
      uid: user!.uid,
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      photoUrl: _photoUrl ?? '',
      occupation: _selectedOccupation ?? _occupations.first,
      location: _locationController.text,
    );

    await _userDataHandler.updateUserData(user!, updatedUser.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi! ${_nameController.text}',
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
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          _photoUrl ?? 'https://via.placeholder.com/150',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Full Name'),
                  ),
                  const SizedBox(height: 16),

                  // Address
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: _inputDecoration('Address / About'),
                  ),
                  const SizedBox(height: 16),

                  // Phone
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration('Phone Number'),
                  ),
                  const SizedBox(height: 16),

                  // Location
                  TextFormField(
                    controller: _locationController,
                    decoration: _inputDecoration('Location'),
                  ),
                  const SizedBox(height: 16),

                  // Occupation Dropdown
                  DropdownButtonFormField<String>(
                    value:
                        _occupations.contains(_selectedOccupation)
                            ? _selectedOccupation
                            : null,
                    items:
                        _occupations
                            .map(
                              (occupation) => DropdownMenuItem(
                                value: occupation,
                                child: Text(occupation),
                              ),
                            )
                            .toList(),
                    decoration: _inputDecoration('Occupation'),
                    onChanged: (value) {
                      setState(() {
                        _selectedOccupation = value;
                      });
                    },
                  ),

                  const SizedBox(height: 32),

                  // Save button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveProfile();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.blue.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
