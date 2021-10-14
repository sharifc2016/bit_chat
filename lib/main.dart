import 'package:bit_chat/constants.dart';
import 'package:bit_chat/screens/chat_screen.dart';
import 'package:bit_chat/screens/login_screen.dart';
import 'package:bit_chat/screens/registration_screen.dart';
import 'package:bit_chat/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BitChat());
}

class BitChat extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("=====================");
          print("ERROR");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          print("=====================");
          print("OK");
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(initialRoute: kScreens.welcome_screen, routes: {
          kScreens.welcome_screen: (context) => WelcomeScreen(),
          kScreens.login_screen: (context) => LoginScreen(),
          kScreens.registration_screen: (context) => RegistrationScreen(),
          kScreens.chat_screen: (context) => ChatScreen(),
        });
      },
    );
  }
}
