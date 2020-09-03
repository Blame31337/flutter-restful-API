import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_services.dart';
import '../animations/singin_animation.dart';
import '../components/Rregister_form.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _loginButtonController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _emailValue;
  String _passwordValue;
  String _nameValue;
  String _aboutValue;
  String _usernameValue;
  String _mccValue;
  String _mobileNumberValue;

  emailOnSaved(String value) {
    _emailValue = value;
  }

  passwordOnSaved(String value) {
    _passwordValue = value;
  }

  nameOnSaved(String value) {
    _nameValue = value;
  }

  aboutOnSaved(String value) {
    _aboutValue = value;
  }

  usernameOnSaved(String value) {
    _usernameValue = value;
  }

  mccOnSaved(String value) {
    _mccValue = value;
  }

  mobileNumberOnSaved(String value) {
    _mobileNumberValue = value;
  }

  @override
  void initState() {
    super.initState();
    _loginButtonController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 3000));
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = .4;
    var page = MediaQuery.of(context).size;

    return new Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: new Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(colors: <Color>[
          const Color(0xff2c5364),
          const Color(0xff0f2027)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: new Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            new Opacity(
              opacity: .1,
              child: new Container(
                width: page.width,
                height: page.height,
                decoration: new BoxDecoration(
                    // image: new DecorationImage(
                    //     image:
                    //         new AssetImage("assets/images/icon-background.png"),
                    //     repeat: ImageRepeat.repeat),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: new ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RegisterFormContainer(
                    formKey: _formKey,
                    emailOnSaved: emailOnSaved,
                    passwordOnSaved: passwordOnSaved,
                    aboutOnSaved: aboutOnSaved,
                    mccOnSaved: mccOnSaved,
                    mobileNumberOnSaved: mobileNumberOnSaved,
                    nameOnSaved: nameOnSaved,
                    usernameOnSaved: usernameOnSaved,
                  ),
                  new FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: new Text(
                      "آیا قبلا عضو شدید؟ ورود",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.5,
                          color: Colors.white,
                          fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: new GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          sendDataForLogin();
                        }
                      },
                      child: new SingInAnimation(
                        controller: _loginButtonController.view,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendDataForLogin() async {
    await _loginButtonController.animateTo(0.150);
    Map response = await (new AuthService()).sendDataToRegister({
      "email": _emailValue,
      "password": _passwordValue,
      "mobile_number": _mobileNumberValue,
      "mcc": _mccValue,
      "username": _usernameValue,
      "name": _nameValue,
      "about": _aboutValue,
      "type": "user",
    });

    if (response["success"] == true) {
      await storeUserData(response["token"]);
      await _loginButtonController.forward();
      Navigator.pushReplacementNamed(context, "/");
    } else {
      print(response.toString());
      await _loginButtonController.reverse();
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          content: new Text(
//            response['message'],
            "eroooooor",
            style: new TextStyle(fontFamily: 'Vazir'),
          ),
        ),
      );
    }
  }

  storeUserData(Map userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", userData["token"]);
  }
}
