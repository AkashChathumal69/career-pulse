class User {
  String name;
  String email;
  String password;
  String phone;
  String address;
  String image;
  String id;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.image,
    required this.id,
  });

  // Convert model to JSON (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'image': image,
    };
  }

  // Convert JSON to model (for Firestore)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['uid'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
      address: map['address'],
      image: map['image'],
    );
  }
}
