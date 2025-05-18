import 'dart:io';

import 'package:career_pulse/model/gig_model.dart';
import 'package:career_pulse/service/firestore/gig_firestore.dart';
import 'package:career_pulse/service/supabase/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class GigCreate extends StatefulWidget {
  const GigCreate({super.key});

  @override
  State<GigCreate> createState() => _GigCreateState();
}

class _GigCreateState extends State<GigCreate> {
  File? _image;
  final picker = ImagePicker();

  final bool _isUploading = false;
  String? _uploadedImageUrl;
  List<String> _keywords = [];
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedCategory;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        _uploadedImageUrl = null;
      });
    }
  }

  Future<void> _submitGig() async {
    if (_jobTitleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    if (_image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please upload an image')));
      return;
    }

    //upload Gig image to Supabase Storage

    Storage storage = Storage();

    _uploadedImageUrl = await storage.upload_image(_image!, "gig");

    //Create Gigmodel object

    final gigModel = GigModel(
      gig_title: _jobTitleController.text,
      occupation: _selectedCategory!,
      description: _descriptionController.text,
      imageUrl: _uploadedImageUrl ?? '', // Use the uploaded image URL
      location: _locationController.text,
      keywords: _keywords,
      uid: FirebaseAuth.instance.currentUser!.uid,
    );

    // Save the gig to Firestore

    Gig_firestote_function gigFirestoreFunction = Gig_firestote_function();

    await gigFirestoreFunction.addGig(gigModel, context);

    // Clear the form fields after submission
    _jobTitleController.clear();
    _descriptionController.clear();
    _selectedCategory = null;
    _image = null;
    _uploadedImageUrl = null;
    setState(() {}); // Refresh the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  controller: _jobTitleController,

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

                TextField(
                  controller: _locationController,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                    ),
                    labelText: "Location",
                    hintText: 'Colombo',
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

                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },

                  hint: Text("Electrician"),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),

                    hintText: "Job Description",
                  ),
                ),
                SizedBox(height: 10),
                // Image Upload Box
                GestureDetector(
                  onTap: _pickImage,

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

                // Add this to the class variables
                TextField(
                  controller: _keywordsController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    labelText: "Keywords",
                    hintText: "Enter keyword and press Enter",
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isEmpty) return;

                    setState(() {
                      if (!_keywords.contains(value.trim())) {
                        if (_keywords.length >= 5) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Maximum 5 keywords allowed'),
                            ),
                          );
                          return;
                        }
                        _keywords.add(value.trim());
                      }
                      // Clear the text field after adding the keyword
                      _keywordsController.clear();
                    });
                  },
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children:
                      _keywords
                          .map(
                            (keyword) => Chip(
                              label: Text(keyword),
                              deleteIcon: Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  _keywords.remove(keyword);
                                });
                              },
                            ),
                          )
                          .toList(),
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitGig,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
