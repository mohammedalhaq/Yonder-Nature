import 'package:Yonder/homepage.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Yonder/model/settings_model.dart';


class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController accountSignController = new TextEditingController();
  TextEditingController passwordSignController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  String _value = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );
    if (picked != null) setState(() => _value = picked.toString());
    _value = _value.substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    final _notifications = Notifications();
    String _title = "Welcome to yonder";
    String _body = "enjoy nature";
    String _payload = "the Payload";

    _notifications.init();
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Card(
          color: Colors.lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(140), // if you need this
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/Logo.png',
                width: 100.0,
                height: 200.0,
              ),
              Container(
                padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Name'),
                      controller: nameController,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(labelText: 'Email'),
                      controller: accountSignController,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(labelText: 'Password'),
                      controller: passwordSignController,
                    ),
                    FlatButton(
                        onPressed: () async {
                          selectDate();
                        },
                        child: new Text('Select date of birth')),
                    Text(
                      _value,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40),
                    RaisedButton(
                      child: Text("Create an Account"),
                      onPressed: () async {
                        if (accountSignController.text == '' ||
                            passwordSignController.text == '' ||
                            _value == '' ||
                            nameController.text == '') {
                          FocusScope.of(context).unfocus();
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('INVALID! Please fill in form!'),
                            duration: Duration(seconds: 3),
                          ));
                        } else {
                          try {
                            User user = (await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                              email: accountSignController.text,
                              password: passwordSignController.text,
                            ))
                                .user;
                            if (user != null) {
                              _notifications.sendNotificationNow(
                                  _title, _body, _payload);
                              var _model = SettingsModel();
                              _model.initializeSettings(accountSignController.text);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(
                                          title: 'Yonder', user: user.email)));
                            }
                          } catch (e) {
                            FocusScope.of(context).unfocus();
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Invalid Email, Please enter 8 character email and password!'),
                              duration: Duration(seconds: 8),
                            ));
                          }
                        }
                      },
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    RaisedButton(
                      child: Text("Go back"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
