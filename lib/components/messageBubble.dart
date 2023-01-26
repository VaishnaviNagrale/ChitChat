import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/screens/chat_screen.dart';

class messageBubble extends StatelessWidget {
  messageBubble(this.sender,this.text,this.isMe);
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(sender,style: TextStyle(color: Colors.grey,fontSize: 15.0),),
          Material(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0),),
              color:isMe ? Colors.green : Colors.blue,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                child: Text(text, style: TextStyle(fontSize: 20.0,),
                ),
              )
          ),
        ],
      ),
    );
  }
}
