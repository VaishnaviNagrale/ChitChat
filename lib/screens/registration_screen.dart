import 'dart:async';
import 'package:chitchat/screens/chat_screen.dart';
import 'package:chitchat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
// //import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'Registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}
class _RegistrationScreenState extends State<RegistrationScreen> {
 // bool showSpiner=false;
  final _auth=FirebaseAuth.instance;
  String email='';
  String password='';

  //final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  // void _doSomething() async {
  //   Timer(Duration(seconds: 3), () {
  //     _btnController.success();
  //   });
  //   try{
  //     final newUser =await _auth.createUserWithEmailAndPassword(email: email, password: password);
  //     print(newUser);
  //     if(newUser != null){
  //       Navigator.pushNamed(context, ChatScreen.id);
  //     }
  //   }
  //   catch(e){
  //     print(e);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'pokemon',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('assets/pokemon (1).png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kInputDecoration.copyWith(
                    hintText: 'Enter your email'
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kInputDecoration.copyWith(
                    hintText: 'Enter your password'
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(colour: Colors.blueAccent, title: 'Register', onPressed: ()async{
                try{
                  final newUser =await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  print(newUser);
                  if(newUser != null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                }
                catch(e){
                  print(e);
                }
              },
              ),
            ],
          ),
        ),
    );
  }
}