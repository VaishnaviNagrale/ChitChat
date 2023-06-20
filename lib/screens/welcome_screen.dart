import 'package:chitchat/auth/email/login_screen.dart';
import 'package:chitchat/auth/email/registration_screen.dart';
import 'package:chitchat/auth/mobile_no/mobile_signIn.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'Welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation =
        ColorTween(begin: Colors.orange, end: Colors.white).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'pokemon',
                  child: Container(
                    child: Image.asset('assets/pokemon (1).png'),
                    height: 75.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Chit Chat'],
                  textStyle: TextStyle(
                    fontSize: 40.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              colour: Colors.lightBlueAccent,
              title: 'Log In With Email',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            RoundedButton(
              colour: Colors.lightBlueAccent,
              title: 'Log In With Phone Number',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MobileSignInScreen()));
              },
            ),
            RoundedButton(
              colour: Colors.blueAccent,
              title: 'Register With Email',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegistrationScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
