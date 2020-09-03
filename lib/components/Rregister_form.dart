import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import 'InputFields.dart';

class RegisterFormContainer extends StatelessWidget {
  final formKey;
  final emailOnSaved;
  final passwordOnSaved;
  final nameOnSaved;
  final aboutOnSaved;
  final usernameOnSaved;
  final mccOnSaved;
  final mobileNumberOnSaved;

  RegisterFormContainer(
      {@required this.formKey,
      this.emailOnSaved,
      this.passwordOnSaved,
      this.nameOnSaved,
      this.aboutOnSaved,
      this.usernameOnSaved,
      this.mccOnSaved,
      this.mobileNumberOnSaved});

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: new Column(
        children: <Widget>[
          new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                new InputFieldArea(
                    hint: "ایمیل کاربری",
                    obscure: false,
                    icon: Icons.person_outline,
                    validator: (String value) {
                      if (!isEmail(value)) {
                        return 'ایمیل وارد شده معتبر نیست';
                      }
                    },
                    onSaved: emailOnSaved),
                new InputFieldArea(
                    hint: "پسورد",
                    obscure: true,
                    icon: Icons.lock_open,
                    validator: (String value) {
                      if (value.length < 5) {
                        return 'طول پسورد باید حداقل 6 کاراکتر باشد';
                      }
                    },
                    onSaved: passwordOnSaved),
                new InputFieldArea(
                    hint: "نام و نام خانوادگی",
                    obscure: false,
                    icon: Icons.person_outline,
                    onSaved: nameOnSaved),
                new InputFieldArea(
                    hint: "تلفن همراه",
                    obscure: false,
                    icon: Icons.person_outline,
                    // validator: (String value) {
                    //   if (!isInt(value)) {
                    //     return 'شماره تلفن وارد شده معتبر نیست';
                    //   }
                    // },
                    onSaved: mobileNumberOnSaved),
                new InputFieldArea(
                    hint: "نام کاربری",
                    obscure: false,
                    icon: Icons.person_outline,
                    validator: (String value) {},
                    onSaved: usernameOnSaved),
                new InputFieldArea(
                    hint: "متنی کوتاه درباره ی شما",
                    obscure: false,
                    icon: Icons.person_outline,
                    onSaved: aboutOnSaved),
                new InputFieldArea(
                    hint: "کد نظام پزشکی",
                    obscure: false,
                    icon: Icons.person_outline,
                    validator: (String value) {
                      if (!isInt(value)) {
                        return 'کد نظام پزشکی وارد شده معتبر نیست';
                      }
                    },
                    onSaved: mccOnSaved),
              ],
            ),
          )
        ],
      ),
    );
  }
}
