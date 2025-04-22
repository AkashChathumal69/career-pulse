import 'package:career_pulse/model/message.dart';
import 'package:career_pulse/service/auth/auth_gate.dart';
import 'package:career_pulse/service/chat/chat_service.dart';
import 'package:career_pulse/service/firestore/gig_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;
  final String? gigId;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
    this.gigId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _messageController = TextEditingController();
  Gig_firestote_function _gigFirestore = Gig_firestote_function();

  @override
  void initState() {
    super.initState();

    if (widget.gigId != null) {
      _chatService.sendMessage(
        widget.receiverId,
        _messageController.text,
        widget.gigId,
      );
      _messageController.clear(); // Clear it after sending
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage(BuildContext context) {
    if (_messageController.text.isNotEmpty) {
      _chatService.sendMessage(
        widget.receiverId,
        _messageController.text,
        null,
      );
      _messageController.clear();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Message is empty!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.receiverEmail)),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => sendMessage(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    if (user == null) {
      return const Center(child: Text('User not logged in.'));
    }

    return StreamBuilder(
      stream: _chatService.getMessages(user!.uid, widget.receiverId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No messages yet'));
        }

        return ListView(
          children:
              snapshot.data!.docs
                  .map<Widget>((doc) => _buildMessageItem(doc, context))
                  .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, BuildContext context) {
    final message = Message.fromMap(doc.data() as Map<String, dynamic>);
    final isSentByMe = message.senderId == user?.uid;

    var alignment = isSentByMe ? Alignment.centerRight : Alignment.centerLeft;

    final time =
        message.timestamp != null
            ? "${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}"
            : "";

    if (message.gigId != null) {
      //get gig details from firestore
      _gigFirestore.getGigById(message.senderId, message.gigId!).then((gig) {
        if (gig != null) {
          return ListTile(
            title: Text(gig.gig_title),
            subtitle: Text(gig.description),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to gig details page
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Align(
        alignment: alignment,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSentByMe
                      ? Theme.of(context).primaryColor.withOpacity(0.9)
                      : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft:
                    isSentByMe
                        ? const Radius.circular(16)
                        : const Radius.circular(4),
                bottomRight:
                    isSentByMe
                        ? const Radius.circular(4)
                        : const Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  style: TextStyle(
                    color: isSentByMe ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: TextStyle(
                    color: isSentByMe ? Colors.white70 : Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
