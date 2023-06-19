import 'package:chitchat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'Registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}
class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth=FirebaseAuth.instance;
  String email='';
  String password='';

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
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$e',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.orange,
      ));
                }
              },
              ),
            ],
          ),
        ),
    );
  }
}