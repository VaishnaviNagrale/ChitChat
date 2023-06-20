import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'otp_controller.dart';

class MobileSignInScreen extends StatefulWidget {
  const MobileSignInScreen({super.key});

  @override
  State<MobileSignInScreen> createState() => _MobileSignInScreenState();
}

class _MobileSignInScreenState extends State<MobileSignInScreen> {
  String dialCodeDigits = "+00";
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'pokemon',
                child: Container(
                  margin: EdgeInsets.only(top: 30),
                  height: 200.0,
                  child: Image.asset('assets/pokemon (1).png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Center(
                    child: Text(
                  'Phone (OTP) Authentication',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 60,
                width: 400,
                child: CountryCodePicker(
                  onChanged: (country) {
                    setState(() {
                      dialCodeDigits = country.dialCode!;
                    });
                  },
                  initialSelection: "IN",
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  favorite: [
                    "+1",
                    "US",
                    "+91",
                    "IN",
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, right: 10, left: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    prefix: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(dialCodeDigits),
                    ),
                  ),
                  maxLength: 12,
                  keyboardType: TextInputType.number,
                  controller: _textEditingController,
                ),
              ),
              Container(
                margin: EdgeInsets.all(15.0),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OTPControllerSccreen(
                          phone: _textEditingController.text,
                          codeDigits: dialCodeDigits,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
