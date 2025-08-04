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
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const App());


}

//  Arka planda gelen bildirimleri işleyen fonksiyon
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(" Arka planda mesaj alındı: ${message.messageId}");
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Bildirim izni iste
    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print(' Bildirim izni verildi');

      // Cihaz token'ı al
      String? token = await messaging.getToken();
      print(' Firebase Token: $token');
    }

    // Uygulama açıkken mesaj alma
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(' Uygulama içindeyken mesaj alındı: ${message.notification?.title}');
    });

    // Uygulama açık değilken ve tıklandığında mesaj
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(' Bildirime tıklandı: ${message.notification?.title}');
    });
  }

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
      home:  MainScreen(),
    );
  }
}

