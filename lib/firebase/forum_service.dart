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
      List<Post> posts = [];

      for (var postDoc in querySnapshot.docs) {
        // Get the post data
        var postData = postDoc.data() as Map<String, dynamic>;

        // Retrieve the timestamp for the post
        Timestamp postTimestamp = postData['timestamp'];

        // Fetch the comments for each post and order them by timestamp
        QuerySnapshot commentSnapshot = await _firestore
            .collection('posts')
            .doc(postDoc.id)
            .collection('comments')
            .orderBy('timestamp',
                descending: false) // Order by comment timestamp
            .get();

        List<Comment> comments = commentSnapshot.docs.map((doc) {
          final comment = Comment.fromMap(doc.data() as Map<String, dynamic>);
          return comment;
        }).toList();

        // Sort comments by timestamp if they are not already sorted
        comments.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        // Add the post to the list, including its timestamp and comments
        posts.add(Post(
          id: postDoc.id,
          content: postData['content'],
          username: postData['username'],
          timestamp:
              postTimestamp.toDate(), // Convert Timestamp to DateTime if needed
          comments: comments,
        ));
      }

      return posts;
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  // delete post
  Future<void> deletePost(String postId) async {
    try {
      // Delete all comments first (optional: if you want to delete comments as well)
      var commentsSnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      for (var commentDoc in commentsSnapshot.docs) {
        await commentDoc.reference.delete(); // Delete each comment
      }

      // Now delete the post document
      await _firestore.collection('posts').doc(postId).delete();

      print("Post deleted successfully.");
    } catch (e) {
      print("Error deleting post: $e");
      throw Exception("Failed to delete post");
    }
  }
}
