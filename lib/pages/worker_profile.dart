import 'package:career_pulse/pages/Reusable%20Widgets/blue_container.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';


class WorkerProfile extends StatefulWidget {
  const WorkerProfile({super.key});

  @override
  State<WorkerProfile> createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
  final double profileIcon = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: profileIcon,
                    width: profileIcon,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(profileIcon / 2),
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                  ),
                ),

                Text("John Doe", style: TextStyle(fontSize: 25)),

                SizedBox(height: 20),

                BlueContainer(title: "Mobile Number", delayMilliseconds: 200),
                SizedBox(height: 10),

                BlueContainer(title: "City", delayMilliseconds: 400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
