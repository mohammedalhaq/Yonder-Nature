import 'package:Yonder/model/reply_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Yonder/post.dart';
import 'reply.dart';
import 'ExtraIcons.dart';

class DetailedPage extends StatefulWidget {
  DetailedPage({Key key, this.title, this.postMessage, this.ref, this.user})
      : super(key: key);
  final String title, ref, user;
  final PostMessage postMessage;

  @override
  _DetailedPageState createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  TextEditingController repliesController = new TextEditingController();
  ReplyModel _model = new ReplyModel();
  var iconColor = Colors.grey;
  var icon = Icons.star_border;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Text(widget.postMessage.message, style: TextStyle(fontSize: 24)),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Text(widget.postMessage.location),
            ),
            Image.network(widget.postMessage.imageURL),
            Container(
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Icon(
                      widget.postMessage.plant.toString() == '1'
                          ? ExtraIcons.tree
                          : ExtraIcons.guidedog,
                      color: (widget.postMessage.plant.toString() == '1')
                          ? Colors.green
                          : Colors.brown,
                    ),
                    Text(widget.postMessage.voting.toString()),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(widget.postMessage.username.split("@")[0],
                            style: TextStyle(fontSize: 16)),
                      ),
                    )
                  ],
                )),
            Divider(color: Colors.grey),
            FutureBuilder(
                future: _model.getAllPostReplies(widget.ref),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text("Be the first to reply");
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data.docs
                        .map<Widget>((DocumentSnapshot document) {
                      final reply = Reply.fromMap(document.data(),
                          reference: document.reference);
                      return new ListTile(
                        title: Text(reply.message),
                        leading:
                        SizedBox(
                          width: 20.0,
                          child: FlatButton(
                            padding: new EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                Icon(
                                  icon,
                                  color: iconColor,
                                ),
                                Text(reply.score.toString())
                              ],
                            ),
                            onPressed: () {
                              var value = reply.score;
                              setState(() {
                                if (iconColor == Colors.grey) {
                                  iconColor = Colors.orange;
                                  icon = Icons.star;
                                  value++;
                                } else {
                                  iconColor = Colors.grey;
                                  icon = Icons.star_border;
                                  value--;
                                }
                              });
                              _model.updateReply(
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
                          ),
                        ),
                        subtitle: Text(reply.username.split("@")[0]),
                        trailing: Text(reply.postDate.toString()),
                      );
                    }).toList(),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.reply),
        label: Text("Reply"),
        onPressed: () async {
          TextEditingController replyController = new TextEditingController();

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0)),
                  child: Container(
                    height: 320,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: replyController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Reply!'),
                          ),
                          SizedBox(height: 100),
                          SizedBox(
                            width: 340.0,
                            child: RaisedButton(
                              onPressed: () {
                                Reply reply = new Reply(
                                    message: replyController.text,
                                    postDate: DateTime.now()
                                        .toString()
                                        .substring(0, 10),
                                    username: widget.user);

                                _model.insertReplies(reply, widget.ref);
                                Navigator.of(context).pop(reply);
                                setState(() {});
                              },
                              child: Text(
                                "Send!",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.green,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
