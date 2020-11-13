import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Let\'s Chat',
          style: TextStyle(fontFamily: 'Space Grotesk'),
        ),
        backgroundColor: Colors.black87,
        elevation: 5.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await auth.signOut();
                Navigator.pop(context);
              })
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: firestore.collection('users').getDocuments(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List users = snapshot.data.documents;
                List<Widget> userWidgets = [];
                if (users.length > 0) {
                  for (var i = 0; i < users.length; i++) {
                    var userName = users[i].get('name');
                    var userEmail = users[i].get('email');
                    Widget userWidget = Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/chat',
                              arguments: {
                                'to': userName,
                                'to_email': userEmail,
                                'currentUser': auth.currentUser.email
                              },
                            );
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                child: Text(userName[0].toUpperCase()),
                              ),
                              addHorizontalSpacing(15.0),
                              Text(userName, style: TextStyle(fontSize: 19.0)),
                            ],
                          ),
                        ));
                    if (userEmail != auth.currentUser.email) {
                      userWidgets.add(userWidget);
                    }
                  }
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    child: Column(children: userWidgets),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
