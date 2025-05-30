import 'package:career_pulse/pages/chat_page.dart';
import 'package:career_pulse/pages/user_tile.dart';
import 'package:career_pulse/service/auth/auth_service.dart';
import 'package:career_pulse/service/chat/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatUserPage extends StatelessWidget {
  ChatUserPage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  User? user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat User Page')),
      body: _buildChatUserList(),
    );
  }

  Widget _buildChatUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        //ERROR HANDLING

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        //WAITING FOR DATA
        // If the connection is still waiting, show a loading indicator

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 2.0,
              backgroundColor: Colors.grey,
              semanticsLabel: 'Loading',
              semanticsValue: 'Loading users...',
            ),
          );
        }

        // If the snapshot has no data or the data is empty, show a message
        // indicating that no users were found

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found'));
        }

        // If the snapshot has data, build the list of users

        return ListView(
          children:
              snapshot.data!
                  .map<Widget>((userdata) => _buildUserListItem(userdata, context))
                  .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userdata ,BuildContext context) {

    if (userdata['uid'] != user!.uid) {

      return UserTile(
        text: userdata['name'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(receiverEmail: userdata['email'] , receiverId: userdata['uid']),
            ),
          );
        },
      ); 
     
    } else {
      return const SizedBox.shrink(); // Return an empty widget if the user is the same
    }

  }

}
