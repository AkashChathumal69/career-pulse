import 'package:career_pulse/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataHandler {
  Future<void> handleUserData(User user) async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      // Existing user: Fetch profile data
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      print("Existing User: ${userData?['name']}");
    } else {
      // New user: Save profile data
      await userRef.set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'phone': "",
        'address': "",
        'location': "",
        'occupation': null,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("New User Created!");
    }
  }

  // Fetch user data from Firestore

  Future<UserData?> getUserData(User? user) async {
    if (user != null) {
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        // Existing user: Fetch profile data

        UserData userData = UserData.fromMap(
          userSnapshot.data() as Map<String, dynamic>,
        );

        return userData;
      }
    }
    return null;
  }


  // Update user data in Firestore
  Future<void> updateUserData(User user, Map<String, dynamic> data) async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    await userRef.update(data);
  }






}
