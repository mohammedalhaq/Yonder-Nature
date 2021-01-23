import 'package:cloud_firestore/cloud_firestore.dart';

class PostMessage {
  PostMessage(
      {this.id,
      this.message,
      this.postDate,
      this.imageURL,
      this.voting,
      this.location,
      this.username,
      this.plant});

  DocumentReference reference;
  int voting, plant;
  String id, message, postDate, imageURL, location, username, coordinates;

  PostMessage.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.id = map['id'];
    this.message = map['message'];
    this.postDate = map['postDate'];
    this.imageURL = map['imageURL'];
    this.voting = map['voting'];
    this.location = map['location'];
    this.username = map['username'];
    this.plant = map['plant'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'message': this.message,
      'postDate': this.postDate,
      'imageURL': this.imageURL,
      'voting': this.voting,
      'location': this.location,
      'username': this.username,
      'plant': this.plant
    };
  }
}
