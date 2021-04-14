import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _controllerMail = TextEditingController();
  final _controllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Form(
              key: _formKey,
              child: TextFormField(
                autovalidate: true,
                controller: _controllerMail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) {
                    return null;
                  } else if (!EmailValidator.validate(value)) {
                    return "Invalid email";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  hintText: "mail address",
                  labelText: "mail address",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: TextFormField(
              controller: _controllerPassword,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.edit),
                hintText: "password",
                labelText: "password",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
            child: RaisedButton(
              color: Colors.blue.shade400,
              onPressed: () {
                if (EmailValidator.validate(_controllerMail.text)) {
                  Navigator.pop(context,
                      [_controllerMail.text, _controllerPassword.text]);
                } else {}
              },
              child: Text("Sign Up"),
            ),
          ),
        ],
      ),
    );
  }
}
