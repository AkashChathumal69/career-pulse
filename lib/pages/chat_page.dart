import 'package:career_pulse/model/gig_model.dart';
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
  final Gig_firestote_function _gigFirestore = Gig_firestote_function();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Only send initial message if text exists (from gig)
    if (widget.gigId != null && _messageController.text.isNotEmpty) {
      _chatService.sendMessage(
        widget.receiverId,
        _messageController.text,
        widget.gigId,
      );
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
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
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.work_outline, color: Colors.white),
            label: const Text(
              "Proposal",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _showJobProposalDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(width: 8),
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
    );
  }

  void _showJobProposalDialog(BuildContext context) {
    GigModel? selectedGig;
    int dateCount = 1;
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Send Job Proposal"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder<List<GigModel>>(
                  future: _gigFirestore.getAllGigsForUser(user!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No gigs available from this user');
                    }

                    return DropdownButtonFormField<GigModel>(
                      decoration: const InputDecoration(
                        labelText: 'Select Gig',
                      ),
                      items:
                          snapshot.data!
                              .map(
                                (gig) => DropdownMenuItem(
                                  value: gig,
                                  child: Text(gig.gig_title),
                                ),
                              )
                              .toList(),
                      onChanged: (gig) => selectedGig = gig,
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Select Date Count (Days)",
                  ),
                  initialValue: '1',
                  onChanged: (val) => dateCount = int.tryParse(val) ?? 1,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Message"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Send Proposal"),
              onPressed: () {
                if (selectedGig != null) {
                  _chatService.sendMessage(
                    widget.receiverId,
                    "${messageController.text}\n\n[Duration: $dateCount days]",
                    selectedGig!.gig_id,
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a gig")),
                  );
                }
              },
            ),
          ],
        );
      },
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

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            );
          }
        });

        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) {
                return _buildMessageItem(doc, context);
              }).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, BuildContext context) {
    final message = Message.fromMap(doc.data() as Map<String, dynamic>);
    final isSentByMe = message.senderId == user?.uid;
    final alignment = isSentByMe ? Alignment.centerRight : Alignment.centerLeft;

    if (message.gigId != null) {
      return FutureBuilder<GigModel?>(
        future: _gigFirestore.getGigById(message.senderId, message.gigId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Gig not found'));
          } else {
            final gig = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              child: Align(
                alignment: alignment,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSentByMe
                            ? Theme.of(context).primaryColor.withOpacity(0.9)
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          gig.imageUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        gig.gig_title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSentByMe ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        gig.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSentByMe ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Align(
        alignment: alignment,
        child: Container(
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color:
                isSentByMe
                    ? Theme.of(context).primaryColor.withOpacity(0.8)
                    : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.message,
            style: TextStyle(
              color: isSentByMe ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
