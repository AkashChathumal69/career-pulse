class UserData {
  String name;
  String email;
  String phone;
  String address;
  String photoUrl;
  String uid;

  UserData({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.photoUrl,
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
    };
  }

  // Convert JSON to model (for Firestore)
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      photoUrl: map['photoUrl'],
      uid: map['uid'],
    );
  }
}
