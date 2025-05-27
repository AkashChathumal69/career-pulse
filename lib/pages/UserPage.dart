import 'package:career_pulse/service/auth/auth_gate.dart';
import 'package:career_pulse/service/firestore/handle_user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UserPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final UserDataHandler _userDataHandler = UserDataHandler();

  String _name = '';
  String _photoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    if (user == null) return;
    final userData = await _userDataHandler.getUserData(user);
    if (userData != null) {
      setState(() {
        _name = userData.name;
        _photoUrl =
            userData.photoUrl.isNotEmpty
                ? userData.photoUrl
                : 'https://via.placeholder.com/150';
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => AuthGuard(child: Container())),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top curved container with profile info
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue.shade800, Colors.blue.shade500],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'My Profile',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 56,
                          backgroundImage: NetworkImage(_photoUrl),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        _name.isNotEmpty ? _name : 'Loading...',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Menu Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),

                      _buildMenuCard(
                        icon: Icons.person,
                        title: 'Update Profile',
                        subtitle: 'Change your personal information',
                        onTap: () {
                          Navigator.pushNamed(context, '/update-profile');
                        },
                      ),

                      _buildMenuCard(
                        icon: Icons.work_outline,
                        title: 'My Gigs',
                        subtitle: 'Manage your gigs and projects',
                        onTap: () {
                          Navigator.pushNamed(context, '/my-gigs');
                        },
                      ),

                      _buildMenuCard(
                        icon: Icons.history,
                        title: 'Activity History',
                        subtitle: 'View your recent activities',
                        onTap: () {},
                      ),

                      _buildMenuCard(
                        icon: Icons.logout,
                        title: 'Logout',
                        subtitle: 'Sign out from your account',
                        color: Colors.red.shade100,
                        iconColor: Colors.red,
                        textColor: Colors.red.shade800,
                        onTap: _logout,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? color,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: color ?? Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          leading: CircleAvatar(
            backgroundColor: (iconColor ?? Colors.blue).withOpacity(0.2),
            child: Icon(icon, color: iconColor ?? Colors.blue),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color:
                  textColor != null
                      ? textColor.withOpacity(0.7)
                      : Colors.black54,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: textColor ?? Colors.black45,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
