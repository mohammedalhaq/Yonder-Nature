import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:Yonder/model/settings_model.dart';

void main() {
  runApp(SplashScreen());
}

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    int darkMode;
      var settingsModel = SettingsModel();
      settingsModel.isEmptyNull().then((empty) {
        if (!empty) {
          settingsModel.getSettings().then((settings) {
      darkMode = settings.darkMode;
          });
        }
      });

    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Error with firebase");

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Flutter Demo',
              theme:  ThemeData(
                brightness: darkMode == 0 ? Brightness.light : Brightness.dark,
                primarySwatch: Colors.lightGreen,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: LoginPage(
                title: 'Yonder',
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}