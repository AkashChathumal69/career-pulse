import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final supabase = Supabase.instance.client;
  File? _image;
  bool _isUploading = false;
  String? _uploadedImageUrl;

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

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Generate a unique filename using timestamp
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(_image!.path)}';

      // Upload the file to Supabase Storage
      final response = await supabase.storage
          .from('gigimages') // Replace with your bucket name
          .upload(fileName, _image!);

      // Get the public URL
      final imageUrl = supabase.storage
          .from('gigimages') // Replace with your bucket name
          .getPublicUrl(fileName);

      setState(() {
        _uploadedImageUrl = imageUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading image: $error')));
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Image to Supabase')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.file(_image!, fit: BoxFit.cover),
              )
            else
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, size: 100),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _image != null && !_isUploading ? _uploadImage : null,
              child:
                  _isUploading
                      ? const CircularProgressIndicator()
                      : const Text('Upload to Supabase'),
            ),
            if (_uploadedImageUrl != null) ...[
              const SizedBox(height: 20),
              const Text('Uploaded Image URL:'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(_uploadedImageUrl!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
