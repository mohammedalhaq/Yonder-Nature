import 'package:Yonder/DetailedPage.dart';
import 'package:Yonder/ExtraIcons.dart';
import 'package:Yonder/model/post_model.dart';
import 'package:Yonder/profile.dart';
import 'package:Yonder/analytics.dart';
import 'package:Yonder/setting.dart';
import 'package:Yonder/upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'post.dart';
import 'package:Yonder/model/settings_model.dart';

class HomePage extends StatefulWidget {
  HomePage({this.title, this.user}) : super();

  final String title;
  final String user;

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final PostModel _model = PostModel();
  Future<QuerySnapshot> allPosts;
  var iconColor = Colors.grey;

  Future getPosts() async {
    var settingsModel = SettingsModel();
    settingsModel.getSettings().then((settings) {
      setState(() {
        if (settings.filter == 0) {
          allPosts = _model.getAllPosts();
        } else if (settings.filter == 1) {
          allPosts = _model.getAllPlants();
        } else {
          allPosts = _model.getAllAnimals();
        }
      });
    });
    return await allPosts;
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
            title: Text("Your Profile"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(title: "Profile", user: widget.user)));
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
          )
        ],
      )),
      body: Container(
          child: FutureBuilder(
        future: getPosts(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView(
              children:
                  snapshot.data.docs.map<Widget>((DocumentSnapshot document) {
            final postMessage = PostMessage.fromMap(document.data(),
                reference: document.reference);

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
                            SizedBox(
                              width: 45,
                              //padding: EdgeInsets.only(right: 10),
                                child: FlatButton(
                                  child: Column(
                                    children: [
                                      Icon(
                                          postMessage.plant.toString() == '1'
                                              ? ExtraIcons.tree
                                              : ExtraIcons.guidedog,
                                          color: iconColor),
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
                                      if (iconColor == Colors.grey) {
                                        if (postMessage.plant.toString() ==
                                            '1') {
                                          iconColor = Colors.green;
                                        } else {
                                          iconColor = Colors.brown;
                                        }
                                        value++;
                                      } else {
                                        iconColor = Colors.grey;
                                        value--;
                                      }
                                    });
                                    _model.updatePost(
                                        document.reference
                                            .toString()
                                            .split('/')[1]
                                            .split(')')[0],
                                        value);
                                    
                                    Future.delayed(const Duration(milliseconds: 500), (){
                                      setState(() {
                                        iconColor = Colors.grey;
                                      });
                                    });
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
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      UploadImage(title: "Create a Post", user: widget.user)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
