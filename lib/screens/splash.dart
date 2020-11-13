import 'package:demoapp/widgets/form_fields.dart';
import 'package:demoapp/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

String userEmail, password;

class _SplashState extends State<Splash> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/undraw_online_chat.svg',
                  height: 150,
                ),
                addVerticalSpacing(10.0),
                Text(
                  'Let\'s Chat',
                  style: TextStyle(
                      fontSize: 35.0,
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w600),
                ),
                addVerticalSpacing(5.0),
                Text(
                  'Chat with your buddies easily and much faster',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                addVerticalSpacing(25.0),
                InputField(
                  onChanged: (value) {
                    userEmail = value;
                  },
                  label: 'Email',
                ),
                addVerticalSpacing(15.0),
                PasswordField(
                  label: 'Password',
                  onChanged: (value) {
                    password = value;
                  },
                ),
                addVerticalSpacing(25.0),
                ActionButton(
                  label: 'Login',
                  color: Colors.red[300],
                  onPressed: () async {
                    try {
                      final user = await auth.signInWithEmailAndPassword(
                          email: userEmail, password: password);
                      print(user);
                      if (user != null) {
                        setState(() {
                          userEmail = null;
                          password = null;
                        });
                        Navigator.pushNamed(context, '/home');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
                addVerticalSpacing(35.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account, ',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.red[400],
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
