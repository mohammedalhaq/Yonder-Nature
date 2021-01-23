import 'package:Yonder/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Yonder/setting.dart';
import 'package:Yonder/model/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:Yonder/ExtraIcons.dart';
import 'DetailedPage.dart';
import 'analytics.dart';
import 'post.dart';
import 'package:Yonder/model/settings_model.dart';
class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.title, this.user}) : super(key: key);
  final String title;
  final String user;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController accountLoginController = new TextEditingController();
  final PostModel _model = PostModel();
  var allPosts;

  Future getPosts() async {
    var settingsModel = SettingsModel();
    settingsModel.getSettings().then((settings) {
      setState(() {
          allPosts = _model.getUserPost(widget.user);
      });
    });
    return await allPosts;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                padding: EdgeInsets.only(top: 70.0, left: 30),
                child: Text(
                  widget.user,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/background_header.png'))),
              ),
              ListTile(
                leading: Icon(Icons.face),
                title: Text("HomePage"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage(title: "Yonder", user: widget.user)));
                },
              ),
              ListTile(

                title: Text("Settings"),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SettingPage(title: "Settings", user: widget.user)));
                },
              ),
              ListTile(
                leading: Icon(Icons.android),
                title: Text("Analytics"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => analyticsPage(
                              title: "Analytics", user: widget.user)));
                },
              ),
            ],
          )),
      body: Container(
            child: ListView(
                children: <Widget>[
            SingleChildScrollView(),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.greenAccent,
                    ),


            ListTile(
              title: new Center(child: Text(widget.user, style: TextStyle(
                fontSize: 22.0,
                color: Colors.green,
              ))),
            ),
                  SizedBox(height: 10),
      FutureBuilder(
              future: getPosts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView(
                    shrinkWrap: true,
                    children:
                    snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
                      final postMessage = PostMessage.fromMap(document.data(),
                          reference: document.reference);
                      String numofpost = snapshot.data.size.toString();
                      return new GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailedPage(
                                        title: "Yonder",
                                        postMessage: postMessage,
                                        ref: document.reference
                                            .toString()
                                            .split('/')[1]
                                            .split(')')[0],
                                        user: widget.user)));
                          },
                          child: new Container(
                            width: 350,
                            height: 350,
                            child: Card(
                                child: Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 3 / 2,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Container(
                                            decoration: new BoxDecoration(
                                                image: new DecorationImage(
                                                    fit: BoxFit.fitWidth,
                                                    alignment: FractionalOffset.center,
                                                    image: new NetworkImage(
                                                        postMessage.imageURL))),
                                          )),
                                    ),
                                    Container(
                                      width: 450,
                                      height: 70,
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Container(
                                              padding: EdgeInsets.only(right: 10),
                                              child: FlatButton(
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                        postMessage.plant.toString() == '1'
                                                            ? ExtraIcons.tree
                                                            : ExtraIcons.guidedog,
                                                        color: postMessage.plant.toString() == '1'
                                                  ? Colors.green
                                                  : Colors.brown),
                                                    Expanded(
                                                        child: Align(
                                                            alignment: Alignment.bottomLeft,
                                                            child: Text(postMessage.voting
                                                                .toString()))),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  var value = postMessage.voting;
                                                  setState(() {
                                                  });
                                                  _model.updatePost(
                                                      document.reference
                                                          .toString()
                                                          .split('/')[1]
                                                          .split(')')[0],
                                                      value);
                                                },
                                              )),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Expanded(
                                                    child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Text(postMessage.message))),
                                                Expanded(
                                                    child: Align(
                                                        alignment: Alignment.bottomLeft,
                                                        child: Text(postMessage.location))),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              child: Column(children: [
                                                Expanded(
                                                    child: Align(
                                                      alignment: Alignment.topRight,
                                                      child: Text(postMessage.username.split("@")[0]),
                                                    )),
                                                Expanded(
                                                    child: Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: Text(postMessage.postDate),
                                                    ))
                                              ]))
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ));
                  }).toList());
            }
    )
      ],
          ),
      ),

    );
  }
}
