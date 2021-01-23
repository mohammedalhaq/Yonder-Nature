import 'package:Yonder/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Yonder/post.dart';

class PostModel {
  Future<QuerySnapshot> getAllPosts() async {
    return await FirebaseFirestore.instance.collection('posts').get();
  }

  Future<QuerySnapshot> getAllPlants() async {
    return await FirebaseFirestore.instance
        .collection('posts')
        .where('plant', isEqualTo: 1)
        .get();
  }

  Future<QuerySnapshot> getUserPost(user) async {
    return await FirebaseFirestore.instance
        .collection('posts')
        .where('username', isEqualTo: user)
        .get();
  }

  Future<QuerySnapshot> getAllAnimals() async {
    return await FirebaseFirestore.instance
        .collection('posts')
        .where('plant', isEqualTo: 0)
        .get();
  }

  Future<void> insertPost(PostMessage post) async {
    FirebaseFirestore.instance.collection('posts').add({
      "message": post.message,
      "postDate": post.postDate,
      "imageURL": post.imageURL,
      "location": post.location,
      "username": post.username,
      "plant": post.plant,
      "voting": post.voting,
    });

  }

  Future<void> updatePost(document, value) async {
    FirebaseFirestore.instance.collection('posts').doc(document).update({
      "voting": value,
    });
  }
}
