import 'package:chitchat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPControllerSccreen extends StatefulWidget {
  final String phone;
  final String codeDigits;
  OTPControllerSccreen({required this.phone, required this.codeDigits});

  @override
  State<OTPControllerSccreen> createState() => _OTPControllerSccreenState();
}

class _OTPControllerSccreenState extends State<OTPControllerSccreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPController = TextEditingController();
  final FocusNode _pinOTPFocus = FocusNode();
  String? verificationCode;

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
    color: Colors.blueAccent,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: Colors.grey,
    ),
  );

  VerifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${widget.codeDigits + widget.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          if (value.user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 10),
          ),
        );
      },
      codeSent: (String vID, int? resentToken) {
        setState(() {
          verificationCode = vID;
        });
      },
      codeAutoRetrievalTimeout: (String vID) {
        setState(() {
          verificationCode = vID;
        });
      },
      timeout: Duration(
        seconds: 60,
      ),
    );
  }

  @override
  void initState() {
    VerifyPhoneNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/otp.png'),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  VerifyPhoneNumber();
                },
                child: Text(
                  'Verifying: ${widget.codeDigits},${widget.phone}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(40),
            child: PinPut(
              fieldsCount: 6,
              textStyle: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
              eachFieldWidth: 40,
              eachFieldHeight: 55,
              focusNode: _pinOTPFocus,
              controller: _pinOTPController,
              submittedFieldDecoration: pinOTPCodeDecoration,
              selectedFieldDecoration: pinOTPCodeDecoration,
              followingFieldDecoration: pinOTPCodeDecoration,
              pinAnimationType: PinAnimationType.rotation,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(
                    PhoneAuthProvider.credential(
                      verificationId: verificationCode!,
                      smsCode: pin,
                    ),
                  )
                      .then((value) {
                    if (value.user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    }
                  });
                } catch (error) {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hey! Invalid OTP'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
