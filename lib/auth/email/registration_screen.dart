import 'package:chitchat/auth/email/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'Registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // final _auth=FirebaseAuth.instance;
  // String email='';
  // String password='';

  final GlobalKey<FormState> _formKeyRegister = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confromPass = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    conformpassController.dispose();
    super.dispose();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformpassController = TextEditingController();

  Registration() async {
    if (password == confromPass) {
      try {
        UserCredential userCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print(userCredentials);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text(
              'Registration Successfully, Please Sign In',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } on FirebaseAuthException catch (error) {
        if (error.code == 'weak-password') {
          print('Password is too weak');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black26,
              content: Text(
                'Password is too weak',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.amberAccent,
                ),
              ),
            ),
          );
        } else if (error.code == 'email-already-in-use') {
          print('Account is already exits');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black26,
              content: Text(
                'Account is already exits',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.amber,
                ),
              ),
            ),
          );
        } else {
          print('Password and Conform Password does not matched');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.black26,
              content: Text(
                'Password and Conform Password does not matched',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKeyRegister,
          autovalidateMode: AutovalidateMode.always,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'pokemon',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('assets/pokemon (1).png'),
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
                  decoration:
                      kInputDecoration.copyWith(hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                  obscureText: true,
                  // onChanged: (value) {
                  //   password = value;
                  // },
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
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Conform Password',
                      hintText: 'Password (8+ characters)',
                      labelStyle: TextStyle(fontSize: 15),
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                    controller: conformpassController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter password again';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      confromPass = value!;
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKeyRegister.currentState!.validate()) {
                            _formKeyRegister.currentState!.save();
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                              confromPass = conformpassController.text;
                            });
                            Registration();
                          }
                        },
                        child: const Text(
                          'SignUp',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account ?',
                        style: TextStyle(fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  LoginScreen(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
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
