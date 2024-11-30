import 'package:Ulayaw/features/forum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class ForumService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPost(BuildContext context, String content) async {
    final currentUser =
        Provider.of<UserProvider>(context, listen: false).currentUser;

    if (content.isEmpty || currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: User is not logged in or content is empty.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'username': currentUser,
        'content': content,
        'comments': [],
        'timestamp': FieldValue
            .serverTimestamp(), // Optional: To store when the post was created
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add post: $e')),
      );
    }
  }

  Future<void> addComment(
      BuildContext context, String postId, String commentContent) async {
    final currentUser =
        Provider.of<UserProvider>(context, listen: false).currentUser;

    if (commentContent.isEmpty || currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error: User is not logged in or comment content is empty.')),
      );
      return;
    }

    try {
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      // Create the comment object with content and timestamp
      var comment = {
        'username': currentUser,
        'content': commentContent,
        // Add timestamp directly with FieldValue.serverTimestamp()
        'timestamp': FieldValue.serverTimestamp(),
      };

      await postRef.collection('comments').add(comment);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment: $e')),
      );
    }
  }

  Future<List<Post>> getPosts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('posts').get();
      List<Post> posts = querySnapshot.docs
          .map(
              (doc) => Post.fromFirestore(doc)) // Use fromFirestore method here
          .toList();
      return posts;
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }
}
