import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataHandler {
  Future<void> handleUserData(User user) async {
    if (user != null) {
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
          'name': user.displayName ?? 'New User',
          'email': user.email,
          'photoUrl': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        print("New User Created!");
      }
    } else {
      print("No user signed in.");
    }
  }
}
