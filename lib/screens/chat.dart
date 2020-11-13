import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/utils/encryption.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

Map data;

class _ChatState extends State<Chat> {
  var textController = TextEditingController();
  final firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    print(data);

    return Scaffold(
      appBar: AppBar(
        title: Text(data['to']),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  List messages = snapshot.data.documents;
                  List<Message> messageWidgets = [];
                  for (var i = 0; i < messages.length; i++) {
                    var message =
                        decodeCaesarCipher(messages[i].get('message'));
                    var sender = messages[i].get('sender');
                    var receiver = messages[i].get('to');
                    if (sender == data['currentUser'] ||
                        receiver == data['currentUser']) {
                      if (sender == data['to_email'] ||
                          receiver == data['to_email']) {
                        bool isMe = false;
                        if (sender == data['currentUser']) {
                          isMe = true;
                        }

                        Widget messageWidget =
                            Message(message: message, isMe: isMe);
                        messageWidgets.add(messageWidget);
                      }
                    }
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messageWidgets,
                    ),
                  );
                }),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        hintText: 'Enter your message',
                        focusColor: Colors.green[100],
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 10.0),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (textController.text.length > 0) {
                        var now = DateTime.now().microsecondsSinceEpoch;
                        var encrypted = encodeCaesarCipher(textController.text);

                        var addMessage =
                            await firestore.collection('messages').add({
                          'message': encrypted,
                          'sender': data['currentUser'],
                          'to': data['to_email'],
                          'timestamp': now,
                        });

                        if (addMessage != null) {
                          textController.clear();
                        }
                      }
                    },
                    color: Colors.green[500],
                    textColor: Colors.white,
                    child: Icon(
                      Icons.send,
                      size: 23,
                    ),
                    padding: EdgeInsets.all(14),
                    shape: CircleBorder(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String encodeCaesarCipher(String text) {
  String result = '';
  for (var i = 0; i < text.length; i++) {
    var charcode = text.codeUnitAt(i) + 4;
    var letter = String.fromCharCode(charcode);
    result = result + letter;
  }
  return result;
}

String decodeCaesarCipher(String text) {
  String result = '';
  for (var i = 0; i < text.length; i++) {
    print(text);
    var charcode = text.codeUnitAt(i) - 4;
    var letter = String.fromCharCode(charcode);
    result = result + letter;
    print(letter);
  }
  return result;
}

class Message extends StatelessWidget {
  String message;
  bool isMe;

  Message({this.message, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Material(
            color: isMe ? Colors.lightBlue[200] : Colors.lightBlue[100],
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(message),
            ),
          ),
        ),
      ],
    );
  }
}
