import 'package:career_pulse/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> sendMessage(String receiverId, String? message , String? gigId) async {
    try {
      //get the current user data
      final currentUser = user!.uid;
      final currentUserEmail = user!.email;
      final Timestamp timestamp = Timestamp.now();

      // create a new message document in the 'messages' collection

      Message newMessage = Message(
        id: _firestore.collection('messages').doc().id,
        senderId: currentUser,
        senderEmail: currentUserEmail!,
        recieverId: receiverId,
        gigId: gigId,
        message: message.toString(),
        timestamp: timestamp.toDate(),
      );

      //construct chat room id

      List<String> userIds = [currentUser, receiverId];
      userIds.sort(); // Sort to ensure consistent chat room ID
      String chatRoomId = userIds.join('_'); // Create a unique chat room ID

      // Add the message to the 'messages' collection
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  //get messages from firestore

  Stream<QuerySnapshot> getMessages(String userId, String receiverId) {
    //construct chat room id

    List<String> userIds = [user!.uid, receiverId];
    userIds.sort(); // Sort to ensure consistent chat room ID
    String chatRoomId = userIds.join('_'); // Create a unique chat room ID

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
