import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class GigCreate extends StatefulWidget {
  const GigCreate({super.key});

  @override
  State<GigCreate> createState() => _GigCreateState();
}

class _GigCreateState extends State<GigCreate> {
  File? _image;
  final picker = ImagePicker();
  //final bool _isUploading = false;
  //String? _downloadUrl;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 218, 215, 215),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: const Color.fromARGB(255, 8, 82, 139),
                            ),
                          ),
                        ),
                        SizedBox(width: 50),
                        Text(
                          "GIG CREATE",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),

                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueAccent,
                          width: 2,
                        ),
                      ),
                      labelText: "Job Title",
                      hintText: 'I do electric works',
                    ),
                  ),

                  SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items:
                        [
                              "Electrician",
                              "Plumber",
                              "Carpenter",
                              "Labour",
                              "Mechanic",
                              "Welder",
                              "Painter",
                              "Mason",
                            ]
                            .map(
                              (String category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {},
                    hint: Text("Electrician"),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      hintText: "Area",
                    ),
                  ),
                  SizedBox(height: 10),
                  // Image Upload Box
                  GestureDetector(
                    //onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child:
                          _image != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(_image!, fit: BoxFit.cover),
                              )
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "Upload gig image",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    "Upload jpg or png file. Max size 2MB",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      hintText: "Keywords",
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
}
