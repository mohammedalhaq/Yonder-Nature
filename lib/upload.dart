import 'dart:io';
import 'package:Yonder/MapPage.dart';
import 'package:Yonder/model/post_model.dart';
import 'package:Yonder/post.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';


class UploadImage extends StatefulWidget {
  UploadImage({this.title, this.user}) : super();

  final String title;
  final String user;

  @override
  _UploadImage createState() => _UploadImage();
}

class _UploadImage extends State<UploadImage> {
  var _model = new PostModel();
  //var accountModel = new AccountModel();
  String url = "", coordinates, buttonText = "Upload an Image", path = "";

  TextEditingController titleController = new TextEditingController();
  TextEditingController notesController = new TextEditingController();
  TextEditingController locController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  File _image;
  var plant = 0;
  var visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: titleController,
            ),
            Container(
                child: Visibility(
              visible: visible,
              child: Image.network(
                url,
                height: 280,
              ),
            )),
            RaisedButton(
              //Maybe make FAB on main go straight to upload then next page this
              child: Text(buttonText),
              onPressed: getImageUpload,
            ),
            ToggleSwitch(
              initialLabelIndex: plant,
              labels: ["Wildlife", "Plant"],
              activeBgColor: Colors.green,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              onToggle: (index) {
                setState(() {
                  plant = index;
                });
              },
            ),
            new GestureDetector(
              child: TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Location Found'),
                  controller: locController,
                  enabled: false),
              onTap: () async {
                List list = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MapPage(title: "Location Found")));
                locController.text = list.first;
                coordinates = list.last;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Additional Notes'),
              controller: notesController,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Upload"),
                  content: Text("Submit post?"),
                  actions: [
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text("Confirm"),
                      onPressed: () async {
                        if (url.isNotEmpty &&
                            titleController.text.isNotEmpty &&
                            locController.text.isNotEmpty) {
                          PostMessage newPost = new PostMessage(
                              message: titleController.text,
                              postDate:
                                  DateTime.now().toString().substring(0, 10),
                              imageURL: url,
                              location: locController.text,
                              username: widget.user,
                              plant: plant,
                              voting: 0);
                          _model.insertPost(newPost);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();

                        } else {
                          Navigator.of(context).pop();
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Must fill all fields'),
                            duration: Duration(seconds: 5),
                          ));
                        }
                      },
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.file_upload),
      ),
    );
  }

  Future getImageUpload() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
        path = image.path;
      }
    });

    FirebaseStorage _storage = FirebaseStorage.instance;
    Reference ref = _storage.ref().child("images" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((value) {
        setState(() {
          url = value;
          visible = true;
        });
      });
    });

    buttonText = "Change uploaded image";
  }
}
