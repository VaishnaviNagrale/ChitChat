import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/constants.dart';
import '../components/messageBubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'Chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{
  final _auth = FirebaseAuth.instance;
  final _autth = FirebaseFirestore.instance;
  String messageText='';
  final messageTextController = new TextEditingController();
  @override
  void initState(){
    super.initState();
    getCurrentUserChekin();
  }
  void getCurrentUserChekin()async{
   try{
     final user =await _auth.currentUser;
     if(user != null){
       print(user.emailVerified);
     }
   }catch(e){
     print(e);
   }
  }
  // void getMessage()async{
  //   final Messages = await _autth.collection('messages').get();
  //   for(var message in Messages.docs){
  //     print(message.data());
  //   }
  // }
  void MessagesStream()async{
    await for(var snapshot in _autth.collection('messages').snapshots()){
      for(var message in snapshot.docs){
            print(message.data());
          }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
               // setState(() {
               //   MessagesStream();
               // });
              }),
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
                stream: _autth.collection('messages').snapshots(),
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(
                     backgroundColor: Colors.lightBlueAccent,
                    ),
                    );
                   }
                    final messages = snapshot.data?.docs.reversed;
                    List<messageBubble> messageWidgets = [];
                    if(messages!= null){
                      for(var message in messages){
                         final messageText = message.get('text');
                         final messageSender = message.get('sender');
                         final currentUser = FirebaseAuth.instance.currentUser?.email;
                         bool IsIlogedIn=false;
                         if(currentUser == messageSender){
                           // message from login user
                           IsIlogedIn = true;
                         }
                         final messageWidget = messageBubble(messageSender,messageText,IsIlogedIn);
                         messageWidgets.add(messageWidget);
                      }
                    }
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                        children: messageWidgets,
                      ),
                    );
                },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // message , sender ,text
                      messageTextController.clear();
                      _autth.collection('messages').add({
                        'text': messageText,
                        'sender': FirebaseAuth.instance.currentUser?.email,
                      });
                    },
                    child: Icon(Icons.send,size: 30.0,),
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
// Text(
// 'Send',
// style: kSendButtonTextStyle,
// ),