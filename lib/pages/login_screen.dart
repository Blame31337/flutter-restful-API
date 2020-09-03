import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_services.dart';
import '../animations/singin_animation.dart';
import '../components/login_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _loginButtonController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _emailValue;
  String _passwordValue;

  emailOnSaved(String value) {
    _emailValue = value;
  }

  passwordOnSaved(String value) {
    _passwordValue = value;
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
          gradient: new LinearGradient(
              colors: <Color>[const Color(0xffA9A9A9), const Color(0xff000000)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: new Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            new Opacity(
              opacity: .1,
              child: new Container(
                width: page.width,
                height: page.height,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new LoginFormContainer(
                    formKey: _formKey,
                    emailOnSaved: emailOnSaved,
                    passwordOnSaved: passwordOnSaved,
                  ),
                  new FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: new Text(
                      "آیا هیچ اکانتی ندارید؟ عضویت",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.5,
                          color: Colors.white,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            new GestureDetector(
              onTap: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  sendDataForLogin();
                }
              },
              child: new SingInAnimation(
                controller: _loginButtonController.view,
              ),
            )
          ],
        ),
      ),
    );
  }

  sendDataForLogin() async {
    await _loginButtonController.animateTo(0.150);
    Map response = await (new AuthService()).sendDataToLogin({
      "email": _emailValue,
      "password": _passwordValue,
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
