class User {
  String name;
  String email;
  String password;
  String phone;
  String address;
  String image;
  String token;
  String id;
  String role;
  String status;
  String createdAt;
  String updatedAt;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.image,
    required this.token,
    required this.id,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert model to JSON (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'image': image,
      'token': token,
      'id': id,
      'role': role,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Convert JSON to model (for Firestore)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
      address: map['address'],
      image: map['image'],
      token: map['token'],
      id: map['id'],
      role: map['role'],
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
