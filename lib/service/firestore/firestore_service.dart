import 'package:career_pulse/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Create a reference to the collection
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> addUser(User user) async {
    // Call the user's CollectionReference to add a new user

    try {
      await users.doc(user.id).set(user.toMap());
      print('User added..!');
    } catch (e) {
      print("Error adding user: $e");
    }

    ;
  }
}
