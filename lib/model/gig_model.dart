class GigModel {
  String gig_title;
  String occupation;
  String description;
  String imageUrl;
  String uid;

  GigModel({
    required this.gig_title,
    required this.occupation,
    required this.description,
    required this.imageUrl,
    required this.uid,
  });

  // Convert model to JSON (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'gig_title': gig_title,
      'occupation': occupation,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  // Convert JSON to model (for Firestore)
  factory GigModel.fromMap(Map<String, dynamic> map) {
    return GigModel(
      gig_title: map['gig_title'],
      occupation: map['occupation'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      uid: map['uid'],
    );
  }
}
