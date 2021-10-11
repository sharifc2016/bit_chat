import 'package:bit_chat/constants.dart';
import 'package:bit_chat/screens/chat_screen.dart';
import 'package:bit_chat/screens/login_screen.dart';
import 'package:bit_chat/screens/registration_screen.dart';
import 'package:bit_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(BitChat());

class BitChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: kScreens.welcome_screen,
        routes: {
          kScreens.welcome_screen: (context) => WelcomeScreen(),
          kScreens.login_screen: (context) => LoginScreen(),
          kScreens.registration_screen: (context) => RegistrationScreen(),
          kScreens.chat_screen: (context) => ChatScreen(),
        });
  }
}
