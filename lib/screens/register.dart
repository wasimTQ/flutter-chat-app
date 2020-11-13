import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/widgets/form_fields.dart';
import 'package:demoapp/widgets/spacing.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String userName, userEmail, password, confirmPass;
  bool inCorrectPass = false;

  final auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 250.0,
            child: Column(
              children: [
                Text(
                  'Register new user',
                  style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'Space Grotesk',
                      color: Colors.grey[700]),
                ),
                addVerticalSpacing(30.0),
                InputField(
                  onChanged: (value) {
                    userName = value;
                  },
                  label: 'User Name',
                ),
                addVerticalSpacing(10.0),
                InputField(
                  onChanged: (value) {
                    userEmail = value;
                  },
                  label: 'Email',
                ),
                addVerticalSpacing(10.0),
                PasswordField(
                  onChanged: (value) {
                    password = value;
                  },
                  label: 'Password',
                ),
                addVerticalSpacing(10.0),
                PasswordField(
                  onChanged: (value) {
                    confirmPass = value;
                  },
                  label: 'Re-type Password',
                  error_text: inCorrectPass ? 'Password must be same' : null,
                ),
                addVerticalSpacing(15.0),
                ActionButton(
                  onPressed: () async {
                    if (password == confirmPass) {
                      try {
                        var user = await auth.createUserWithEmailAndPassword(
                            email: userEmail, password: password);
                        var addUser = await firestore
                            .collection('users')
                            .add({'name': userName, 'email': userEmail});

                        if (user != null) {
                          // Navigator.pushNamed(context, '/home');
                          Navigator.popAndPushNamed(context, '/home');
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  label: 'Register',
                  color: Colors.redAccent,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
