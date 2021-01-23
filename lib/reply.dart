
import 'package:cloud_firestore/cloud_firestore.dart';


class Reply {
  Reply(
      {this.id,
      this.username,
      this.message,
      this.score,
      this.postDate,
      this.postId});

  String id, username, message, postId, postDate;
  int score;
  DocumentReference reference;

  Reply.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.id = map['id'];
    this.message = map['message'];
    this.username = map['username'];
    this.score = map['score'];
    this.postId = map['postId'];
    this.postDate = map['postDate'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'message': this.message,
      'username': this.username,
      'score': this.score,
      'postId': this.postId,
      'postDate': this.postDate
    };
  }
}
