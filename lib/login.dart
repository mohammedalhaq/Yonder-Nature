import 'package:Yonder/homepage.dart';
import 'package:Yonder/signup.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Yonder/model/settings_model.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  TextEditingController accountLoginController = new TextEditingController();
  TextEditingController passwordLoginController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    var settingsModel = SettingsModel();
    settingsModel.isEmptyNull().then((empty) {
      if (!empty) {
        settingsModel.getSettings().then((settings) {
          if (settings.login == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                        title: "Yonder", user: settings.user)));
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users =
        FirebaseFirestore.instance.collection('Account');

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: ListView(
          children: <Widget>[
            Image.asset(
              'assets/Logo.png',
              width: 100.0,
              height: 200.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 100, left: 20, right: 20),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'Username'),
                    controller: accountLoginController,
                  ),
                  SizedBox(height: 40),
                  TextField(obscureText: true,
                    decoration: InputDecoration(hintText: 'Password'),
                    controller: passwordLoginController,
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                      child: Text("Login"),
                      onPressed: () async {
                        try {
                          final User user = (await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                            email: accountLoginController.text,
                            password: passwordLoginController.text,
                          ))
                              .user;
                          if (user != null) {
                            var _model = SettingsModel();
                            _model.initializeSettings(accountLoginController.text);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage(
                                        title: 'Yonder',
                                        user: accountLoginController.text)));
                          }
                        } catch (e) {
                          print(e);
                          FocusScope.of(context).unfocus();
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Account Does Not Exist!'),
                            duration: Duration(seconds: 5),
                          ));
                        }
                      },
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                  RaisedButton(
                    child: Text("Create an Account"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(top: 100, left: 20, right: 20),
                    child: new InkWell(
                      child: new Text(
                        'Welcome to Yonder',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
