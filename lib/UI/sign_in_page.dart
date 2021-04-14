import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_app/UI/sign_up_page.dart';
import 'package:meet_app/blocs/authentication_bloc/authentication_bloc.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _controllerMail = TextEditingController();
  final _controllerPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Calender"),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ////////// FLUTTER LOGO ///////////
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Image.asset(
                    "images/splash_screen_image/flutter-logo.jpeg",
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                ),
              ),
            ),

            ///////// MAIL TEXTFORMFIELD /////////

            Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: TextFormField(
                controller: _controllerMail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  hintText: "mail address",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ///////// PASSWORD TEXTFORMFIELD ///////////////
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
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            /////////// LOG IN BUTTON ////////////////
            Container(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 10),
              child: RaisedButton(
                color: Colors.blue.shade400,
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                      LoginEmailAndPassword(
                          email: _controllerMail.text,
                          password: _controllerPassword.text));
                },
                child: Text("Log In"),
              ),
            ),

            Row(
              children: <Widget>[
                Expanded(
                  child: Divider(
                    height: 5,
                    color: Colors.black,
                    indent: 20,
                    endIndent: 5,
                  ),
                ),
                Text("Or"),
                Expanded(
                  child: Divider(
                    height: 5,
                    color: Colors.black,
                    indent: 5,
                    endIndent: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            /////////////// FACEBOOK LOG IN /////////////////
            Container(
              margin: EdgeInsets.only(right: 8, left: 8),
              child: SizedBox(
                height: 50,
                child: RaisedButton(
                  color: Color(0xFF334D92),
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(SignInViaFacebook());
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 4),
                      Image.asset(
                        "images/sign_in_icons/facebook-logo.png",
                      ),
                      SizedBox(width: 65),
                      Text(
                        "Sign In with Facebook",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            //////////////////// ANONYMOUS LOG IN ////////////////
            Container(
              margin: EdgeInsets.only(right: 8, left: 8),
              child: SizedBox(
                height: 50,
                child: RaisedButton(
                  color: Colors.grey,
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(SignInAnonymous());
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 35,
                      ),
                      SizedBox(width: 80),
                      Text(
                        "Sign In as Guest",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
              ),
            ),

            Divider(
              color: Colors.black,
              indent: 5,
              endIndent: 5,
            ),
            /////////////////////// NEW ACCOUNT ///////////////////////
            Row(
              children: <Widget>[
                SizedBox(width: 60),
                Text("Don't have an account? "),
                FlatButton(
                  onPressed: () async {
                    final list = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ),
                    );
                    BlocProvider.of<AuthenticationBloc>(context).add(
                        SignUpEmailAndPassword(
                            email: list[0].toString(),
                            password: list[1].toString()));
                  },
                  child: Text("Sign up."),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
