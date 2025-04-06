import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class Storage {
  final supabase = Supabase.instance.client;

  Future<String?> upload_image(File image, String imageCategory ) async {
    String? imageUrl;
    String bucketName ;

    try {
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.basename(image!.path)}';

      if (imageCategory == "profile") {
        bucketName = "profileimages";
      } else if (imageCategory == "gig") {
        bucketName = "gigimages";
      } else {
        return null;
      }

      

      String response = await supabase.storage
          .from(bucketName)
          .upload(fileName, image);

      imageUrl = supabase.storage.from(bucketName).getPublicUrl(fileName);

      print("Image URL: $imageUrl");

      if (imageUrl == null) {
        throw Exception("Failed to get public URL for the image.");
      }



      return imageUrl;
    } on StorageException catch (e) {

       
      print( e.message);
      return null;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
