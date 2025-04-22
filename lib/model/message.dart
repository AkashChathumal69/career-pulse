

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  final String id;
  final String senderId;
  final String senderEmail;
  final String recieverId;
  String? gigId;
  final String message;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.senderEmail,
    required this.recieverId,
    this.gigId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'SenderEmail': senderEmail,
      'recieverId': recieverId,
      'gigId': gigId ,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      senderId: map['senderId'],
      senderEmail: map['SenderEmail'],
      recieverId: map['recieverId'],
      message: map['message'],
      gigId: map['gigId'],
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.parse(map['timestamp']),
    );
  }
}





