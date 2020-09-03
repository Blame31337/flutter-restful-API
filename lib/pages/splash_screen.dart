import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: new Color(0xffA9A9A9),
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                width: 125,
                height: 125,
              ),
              new Text("فلاتر تست",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))
            ],
          ),
          new Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: new Align(
              alignment: Alignment.bottomCenter,
              child: new CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }

  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiToken = prefs.getString('token');
    print(apiToken);
    if (apiToken != null) {
      Navigator.pushNamed(context, "/");
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }
}
