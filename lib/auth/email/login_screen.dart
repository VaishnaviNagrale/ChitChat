import 'package:chitchat/constants.dart';
import 'package:chitchat/screens/chat_screen.dart';
import 'package:chitchat/auth/email/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forget_pass.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'Login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _auth = FirebaseAuth.instance;
  // String email='';
  // String password='';
 final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();
  String? email;
  String? password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  VerifyEmail() async {
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      print('Verification email has been sent');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black38,
          content: Text(
            'Verification email has been sent',
            style: TextStyle(fontSize: 15.0, color: Colors.amber),
          ),
        ),
      );
    }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(),
        ),
      );
  }

  void userLogin() async {
    try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      if (currentUser.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(),
          ),
        );
      } else {
        VerifyEmail();
      }
    } else {
      print('Failed to retrieve the current user');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blueGrey,
          content: Text(
            'Failed to retrieve the current user',
            style: TextStyle(fontSize: 18.0, color: Colors.amber),
          ),
        ),
      );
    }
  } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        print('No User Found For that email');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text(
              'No User Found For that email',
              style: TextStyle(fontSize: 18.0, color: Colors.amber),
            ),
          ),
        );
      } else if (error.code == 'wrong-password') {
        print('Wrong password provided by the user');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text(
              'Wrong password provided by the user',
              style: TextStyle(fontSize: 18.0, color: Colors.red),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKeyLogin,
        autovalidateMode: AutovalidateMode.always,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
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
              TextFormField(
            
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                // onChanged: (value) {
                //   email = value;
                // },
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter your email'),
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter email';
                  } else if (!value.contains('@')) {
                    return "please enter 'Valid Email'";
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFormField(
              
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                obscureText: true,
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please enter password';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value!;
                },
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundedButton(
                      colour: Colors.lightBlueAccent,
                      title: 'Log In',
                      onPressed: () async {
                        if (_formKeyLogin.currentState!.validate()) {
                          _formKeyLogin.currentState!.save();
                          setState(() {
                            email = emailController.text;
                            password = passwordController.text;
                          });
                          userLogin();
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPassword(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forget password',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New here?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, a, b) => RegistrationScreen(),
                            transitionDuration: Duration(seconds: 0),
                          ),
                        );
                      },
                      child: const Text(
                        'Create an account',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
