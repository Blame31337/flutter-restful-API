import 'package:flutter/material.dart';
import 'pages/login_screen.dart';
import 'pages/register_screen.dart';
import 'pages/splash_screen.dart';
import 'pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'WhatsApp',
      theme: ThemeData(
          fontFamily: 'Vazir',
          primaryColor: new Color(0xff075E54),
          accentColor: new Color(0xff25d366)),
      initialRoute: "/splash_screen",
      routes: {
        "/": (context) => new Directionality(
            textDirection: TextDirection.rtl, child: WhatsAppHome()),
        "/login": (context) => new Directionality(
            textDirection: TextDirection.rtl, child: new LoginScreen()),
        "/register": (context) => new Directionality(
            textDirection: TextDirection.rtl, child: new RegisterScreen()),
        "/splash_screen": (context) => new Directionality(
            textDirection: TextDirection.rtl, child: new SplashScreen()),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
