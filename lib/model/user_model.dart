class UserData {
  String name;
  String email;
  String phone;
  String address;
  String photoUrl;
  String uid;
  String? occupation;
  String location;


  UserData({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.photoUrl,
    required this.occupation,
    required this.location,
    required this.uid,
  });

  // Convert model to JSON (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'photoUrl': photoUrl,
      'occupation': occupation,
      'location': location,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      photoUrl: map['photoUrl'],
      occupation: map['occupation'],
      location: map['location'],
      uid: map['uid'],
    );
  }
}
