import 'package:Yonder/login.dart';
import 'package:Yonder/main.dart';
import 'package:Yonder/model/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key, this.title, this.user}) : super(key: key);
  final String title;
  final String user;

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var filterTypes = ['Both', 'Plants', 'Animals'];
  var langTypes = ['English', 'Portuguese'];

  var _model = SettingsModel();
  bool notifs = false, darkMode = false;

  int filter = 0;
  int lang = 0;

  String _darkmode = 'Dark mode';
  String _logout = 'Log Out';
  String _Noti = 'Disable Notifications';
  String filterText = "filter results to only show";

  @override
  void initState() {
    _model.getSettings().then((settings) {
      setState(() {
        filter = settings.filter;
        lang = settings.lang;
        notifs = settings.notification == 0 ? false : true;
        darkMode = settings.darkMode == 0 ? false : true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(children: [
        ListTile(
            title: Text(widget.user, style: TextStyle(color: Colors.grey))),
        ListTile(
          title: Text(_Noti),
          trailing: Switch(
            value: notifs,
            onChanged: (value) {
              setState(() {
                notifs = value;
              });
            },
          ),
        ),
        ListTile(
          trailing: DropdownButton<String>(
            value: filterTypes[filter],
            items:
                filterTypes.map<DropdownMenuItem<String>>((String selection) {
              return DropdownMenuItem<String>(
                value: selection,
                child: new Text(selection),
              );
            }).toList(),
            onChanged: (item) {
              setState(() {
                filter = filterTypes.indexOf(item);
              });
            },
          ),
          title: Text(filterText),
        ),
        ListTile(
          trailing: DropdownButton<String>(
            value: langTypes[lang],
            items: langTypes.map<DropdownMenuItem<String>>((String selection) {
              return DropdownMenuItem<String>(
                value: selection,
                child: new Text(selection),
              );
            }).toList(),
            onChanged: (item) {
              setState(() {
                lang = langTypes.indexOf(item);
                print(lang);
              });
              if (lang == 0) {
                print('Switching to english');
                Locale newLocale = Locale('en');
                FlutterI18n.refresh(context, newLocale);
                _darkmode = 'Dark mode';
                _logout = 'Log Out';
                _Noti = 'Disable Notifications';
                setState(() {
                  lang = 0;
                });
              } else if (lang == 1) {
                print('Switching to english');
                Locale newLocale = Locale('pt');
                FlutterI18n.refresh(context, newLocale);
                _darkmode = 'Modo Escuro';
                _logout = 'Sair';
                _Noti = 'Disable Notificação';
                filterText = "filtrar resultados para mostrar apenas";
                setState(() {
                  lang = 1;
                });
              }
            },
          ),
          title: Text('Language'),
        ),
        ListTile(
          title: Text(_darkmode),
          trailing: Switch(
            value: darkMode,
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },
          ),
        ),
        FlatButton(
          child: Text(_logout, style: TextStyle(color: Colors.red)),
          onPressed: () {
            alert(context);
          },
        )
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          int tempNotif = notifs ? 1 : 0;
          int tempDark = darkMode ? 1 : 0;
          Settings newSettings = Settings(
              id: 0,
              login: 1,
              notification: tempNotif,
              filter: filter,
              lang: lang,
              user: widget.user,
              darkMode: tempDark);
          _model.updateSettings(newSettings);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SplashScreen()));
        },
      ),
    );
  }

  void alert(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text(_logout),
      content: Text("Are you sure you want to logout?"),
      actions: [
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(_logout),
          onPressed: () {
            Settings update;
            _model.getSettings().then((settings) {
              update = Settings(
                  id: 0,
                  login: 0,
                  notification: settings.notification,
                  filter: settings.filter,
                  lang: settings.lang,
                  darkMode: settings.darkMode);
              _model.updateSettings(update);
            });
            NavigatorState navigatorState = Navigator.of(context);
            while (navigatorState.canPop()) navigatorState.pop();

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(title: "Yonder")));
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class Settings {
  Settings(
      {this.id,
      this.login,
      this.notification,
      this.filter,
      this.lang,
      this.darkMode,
      this.user});

  int id, login, notification, filter, lang, darkMode;
  String user;

  Settings.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.login = map['login'];
    this.notification = map['notification'];
    this.filter = map['filter'];
    this.user = map['username'];
    this.lang = map['lang'];
    this.darkMode = map['darkMode'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'login': this.login,
      'notification': this.notification,
      'filter': this.filter,
      'username': this.user,
      'lang': this.lang,
      'darkMode': this.darkMode
    };
  }
}
