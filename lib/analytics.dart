import 'package:Yonder/model/post_model.dart';
import 'package:Yonder/post.dart';
import 'package:Yonder/profile.dart';
import 'package:Yonder/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ExtraIcons.dart';

class analyticsPage extends StatefulWidget {
  analyticsPage({this.title, this.user}) : super();

  final String title;
  final String user;

  @override
  _analytics createState() => _analytics();
}

class _analytics extends State<analyticsPage> {
  final PostModel pModel = PostModel();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
            ListTile(leading: Icon(Icons.android), title: Text("HomePage")),
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
        body:
            FutureBuilder(
          future: pModel.getAllPosts(),
        builder: (context, snapshot){
            return new  DataTable(
              columns: <DataColumn>[
                DataColumn(label: Text("Username")),
                DataColumn(label: Text("Score")),
                DataColumn(label: Text("Species")),
              ],
              rows: getData(context, snapshot.data),

            );
        })
      /*
            FutureBuilder(
                future: pModel.getAllAnimals(),
                builder: (context, snapshot) {
                  if(snapshot.data == null) return CircularProgressIndicator();

                  return charts.BarChart([
                    new charts.Series<PostMessage, String>(
                      colorFn: (_, __) =>
                          charts.MaterialPalette.green.shadeDefault,
                      id: 'posts',
                      domainFn: (p, _) => p.postDate.substring(5, 7),
                      measureFn: (PostMessage p, _) => p.voting,
                      data: setPlantData(context, snapshot.data),
                    ),
                    new charts.Series<PostMessage, String>(
                      colorFn: (_, __) =>
                          charts.MaterialPalette.red.shadeDefault,
                      id: 'posts',
                      domainFn: (p, _) => p.postDate.substring(5, 7),
                      measureFn: (PostMessage p, _) => p.voting,
                      data: setAnimalData(context, snapshot.data),
                    ),
                  ]);
                })*/
                );

  }

  getData(context, QuerySnapshot snapshot) {
    List<DataRow> rows = snapshot.docs.map((DocumentSnapshot document) {
      return new DataRow(cells: <DataCell>[
        DataCell(Text(document['username'])),
        DataCell(Text(document['voting'].toString())),
        DataCell( Icon(document['plant'] == 0 ? ExtraIcons.tree : ExtraIcons.guidedog))
      ]);
    }).toList();
    return rows;
  }

  setAnimalData(context, snapshot) {

    List<PostMessage> rows =
        snapshot.docs.map<PostMessage>((DocumentSnapshot document) {
          if (document['plant'] == 0)
      return new PostMessage(
          postDate: document['postDate'], voting: document['voting']);
    }).toList();
    return rows;
  }


  setPlantData(context, snapshot) {
    List<PostMessage> rows =
    snapshot.docs.map<PostMessage>((DocumentSnapshot document) {
      if (document['plant'] == 1)
        return new PostMessage(
          postDate: document['postDate'], voting: document['voting']);
    }).toList();
    return rows;
  }
}

class SimplePost {
  SimplePost({this.postDate, this.voting});

  String postDate;
  int voting;
}
