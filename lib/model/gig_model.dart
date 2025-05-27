import 'package:cloud_firestore/cloud_firestore.dart';

class GigModel {
  String? gig_id;
  String gig_title;
  String occupation;
  String description;
  String imageUrl;
  String uid;
  String location;
  List<String> keywords;

  GigModel({
    this.gig_id,
    required this.gig_title,
    required this.occupation,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.uid,
    required this.keywords,
  });

  // Convert model to JSON (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'gig_title': gig_title,
      'occupation': occupation,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'keywords': keywords,
    };
  }

  // Convert JSON to model
  factory GigModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return GigModel(
      gig_id: doc.id,
      gig_title: data['gig_title'],
      occupation: data['occupation'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      location: data['location'],
      uid: data['uid'],
      keywords: List<String>.from(data['keywords'] ?? []),
    );
  }
}
