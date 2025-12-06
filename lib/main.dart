import 'package:flutter/material.dart';
import 'package:pawpal_app/models/user.dart';
import 'package:pawpal_app/view/welcome_screen.dart';

void main() {
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key,});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Mainmenu(),
    );
  }
}
class Mainmenu extends StatefulWidget {
  const Mainmenu({super.key});

  @override
  State<Mainmenu> createState() => _MainmenuState();
}

class _MainmenuState extends State<Mainmenu> {
  @override
  Widget build(BuildContext context) {
    return WelcomeScreen(user: User());
  }
}