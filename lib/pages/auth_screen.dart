import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp_clone/main.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _verificationId;

  void _sendCodetoPhone() async {
    if(_formKey.currentState!.validate()) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneController.text.trim(),
        verificationCompleted: (PhoneAuthCredential credential) {
          print('Verification completed: ${credential.smsCode}');
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}'))
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    }   
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login with your phone number"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number',),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if(value == null || value.isEmpty || !RegExp(r'^\+\d{1,3}\d{9,10}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  } return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendCodetoPhone,
                child: Text('Send Code'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  textStyle: TextStyle(color:Theme.of(context).colorScheme.onSecondary),
                ),
              )
            ],
          )
        )
      ),
    );
  }
}

class OTPScreen extends StatefulWidget {
  final String verificationId;

  OTPScreen({required this.verificationId});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OTPScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: _otpController.text.trim(),
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        // Redirect to home if OTP is valid
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _otpController,
                decoration: InputDecoration(labelText: 'OTP'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 6) {
                    return 'Please enter a valid 6-digit OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}