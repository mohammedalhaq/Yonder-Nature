import 'package:Yonder/reply.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyModel {
  Future<QuerySnapshot> getAllReplies(document) async {
    return await FirebaseFirestore.instance.collection('Replies').get();
  }

  Future<QuerySnapshot> getAllPostReplies(document) async {
    return await FirebaseFirestore.instance
        .collection('Replies')
        .where('postId', isEqualTo: document)
        .get();
  }

  Future<QuerySnapshot> getAllUserReplies(username) async {
    return await FirebaseFirestore.instance
        .collection('Replies')
        .where('username', isEqualTo: username)
        .get();
  }

  Future<void> insertReplies(Reply reply, String postId) async {
    FirebaseFirestore.instance.collection('Replies').add({
      "message": reply.message,
      "postDate": reply.postDate,
      "username": reply.username,
      "postId": postId,
      "score": 0,
    });
  }

  Future<void> updateReply(document, value) async {
    FirebaseFirestore.instance.collection('Replies').doc(document).update({
      "score": value,
    });
  }
}
