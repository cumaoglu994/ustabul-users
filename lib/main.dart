import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:ustabuul/auth/alan_register.dart';
// ignore: unused_import
import 'package:ustabuul/auth/register_screen.dart';
// ignore: unused_import
import 'package:ustabuul/auth/veren_register.dart';
import 'package:ustabuul/screens/main_srceen.dart';
// ignore: unused_import
import 'package:ustabuul/screens/navigation_Screens/home_srceen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MainScreen.id,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      // ignore: prefer_const_constructors
      home: MainScreen(),
    );
  }
}
