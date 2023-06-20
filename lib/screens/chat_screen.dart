import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/messageBubble.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'Chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String messageText = '';
  final messageTextController = TextEditingController();
  late User currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUser = user;
      });
    }
  }

  @override
  void dispose() {
    messageTextController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    messageTextController.clear();
    await _firestore.collection('messages').add({
      'text': messageText,
      'sender': currentUser.email ?? currentUser.phoneNumber,
      'createdAt': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('✨Chating Screen'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final messages = snapshot.data?.docs.reversed;
                List<Widget> messageWidgets = [];
                if (currentUser != null) {
                  for (var message in messages!) {
                    final messageText = message.get('text') as String?;
                    final messageSender = message.get('sender') as String?;
                    final isMe = (currentUser.email != null &&
                        messageSender != null &&
                        currentUser.email == messageSender) ||
                        (currentUser.phoneNumber != null &&
                        messageSender != null &&
                        currentUser.phoneNumber == messageSender);
                    if (messageText != null && messageSender != null) {
                      final messageWidget = MessageBubble(
                        sender: messageSender,
                        text: messageText,
                        isMe: isMe,
                      );
                      messageWidgets.add(messageWidget);
                    }
                  }
                }

                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    children: messageWidgets,
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        hintText: 'Type your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      sendMessage();
                    },
                    child: Icon(
                      Icons.send,
                      size: 30.0,
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
}
