import 'package:bit_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String messageText;
  late User loggedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getMessages();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print(user.email);
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void getMessages() async {
    try {
      final messages = await _firestore.collection("messages").get();
      print("======messages");
      messages.docs.forEach((element) {
        print(element.data());
      });
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection("messages").snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushNamed(context, kScreens.login_screen);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("messages").snapshots(),
              builder: (context, snapshot) {
                List<MessageListItem> messageListItems = [];
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final messages = snapshot.data!.docs;
                for (var message in messages) {
                  final messageListItem =
                      MessageListItem(message['sender'], message['text']);
                  messageListItems.add(messageListItem);
                }
                return Expanded(
                  child: ListView(
                    children: messageListItems,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print(messageText);
                      print(loggedInUser);
                      if (messageText.isNotEmpty) {
                        _firestore.collection("messages").add({
                          'sender': loggedInUser.email,
                          'text': messageText,
                        });
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
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

class MessageListItem extends StatelessWidget {
  final String sender;
  final String text;

  MessageListItem(this.sender, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.lightBlueAccent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: Text(
            '$sender - $text',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}
