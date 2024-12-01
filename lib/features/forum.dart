import 'package:Ulayaw/firebase/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase/forum_service.dart';

void main() {
  runApp(ForumApp());
}

class ForumApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ForumPage(),
    );
  }
}

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final TextEditingController postController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  List<Post> posts = [];
  bool showUserPostsOnly = false; // Flag to filter posts by current user
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void handleAddPost(String content) {
    ForumService forumService = ForumService();
    forumService.addPost(context, content).then((_) {
      loadPosts(); // Reload the posts after adding a new post
    });
  }

  void handleAddComment(String postId, String commentContent) {
    ForumService forumService = ForumService();
    forumService.addComment(context, postId, commentContent).then((_) {
      loadPosts(); // Reload the posts after adding a comment
    });
  }

  void _addCommentToPost(String postId, String commentContent) {
    final postIndex = posts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      setState(() {
        posts[postIndex].addComment(Comment(
          content: commentContent,
          username: 'Current User',
          timestamp: DateTime.now(),
        ));
      });
    }
  }

  // Toggle the filter for showing only user's posts
  void toggleUserPostsFilter() {
    setState(() {
      showUserPostsOnly = !showUserPostsOnly;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<List<Comment>> fetchComments(String postId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      return querySnapshot.docs.map((doc) {
        return Comment.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch comments for post $postId: $e');
    }
  }

  Future<void> loadPosts() async {
    ForumService forumService = ForumService();
    try {
      // Fetch all posts first
      List<Post> fetchedPosts = await forumService.getPosts();

      // Fetch comments for each post
      for (var post in fetchedPosts) {
        List<Comment> comments = await fetchComments(post.id);
        post.comments = comments;
      }

      // Update the state with posts and their comments
      setState(() {
        posts = fetchedPosts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load posts: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<UserProvider>(context, listen: false).currentUser;
    // Filter posts based on the showUserPostsOnly flag
    List<Post> filteredPosts = showUserPostsOnly
        ? posts.where((post) => post.username == currentUser).toList()
        : posts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
        actions: [
          // Button to toggle the filter
          IconButton(
            icon: Icon(
                showUserPostsOnly ? Icons.visibility_off : Icons.visibility),
            onPressed: toggleUserPostsFilter,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deaf Community Forum',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16),
            // Add the toggle button here, below the Deaf Community Forum text
            Row(
              children: [
                Text(
                  'Show only my posts',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                Switch(
                  value: showUserPostsOnly,
                  onChanged: (value) {
                    toggleUserPostsFilter();
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: postController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Write your thoughts here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_upward, color: Colors.white),
                    onPressed: () {
                      if (postController.text.isNotEmpty) {
                        handleAddPost(postController.text);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPosts.length,
                itemBuilder: (context, index) {
                  final post = filteredPosts[index];
                  return PostCard(
                    post: post,
                    onAddComment: (comment) =>
                        handleAddComment(post.id, comment),
                    isUserPost: post.username == currentUser,
                    currentUser: '', // Check if the post is by the user
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Post {
  String id;
  String content;
  String? username;
  List<Comment> comments;

  Post({
    required this.id,
    required this.content,
    this.username,
    List<Comment>? comments,
  }) : comments = comments ?? [];

  // Factory method to create a Post instance from Firestore data
  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      content: data['content'] ?? '',
      username: data['username'],
      comments: (data['comments'] as List<dynamic>?)
              ?.map((commentData) => Comment.fromMap(commentData))
              .toList() ??
          [],
    );
  }

  // Method to sort comments by timestamp
  void sortComments() {
    comments.sort((a, b) => a.timestamp
        .compareTo(b.timestamp)); // Sort in ascending order (oldest first)
  }

  void addComment(Comment comment) {
    comments.add(comment);
    sortComments();
  }
}

class Comment {
  String content;
  String? username; // Username of the commenter
  DateTime timestamp;

  Comment({
    required this.content,
    required this.username,
    required this.timestamp,
  });

  // Factory method to create a Comment instance from a map
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      content: map['content'],
      username: map['username'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}

class PostCard extends StatefulWidget {
  final String currentUser;
  final Post post;
  final Function(String) onAddComment;
  final bool isUserPost; // Flag to check if the post is by the user

  const PostCard(
      {required this.currentUser,
      required this.post,
      required this.onAddComment,
      required this.isUserPost});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUserUsername = context.watch<UserProvider>().currentUser;

    widget.post.comments.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.username ??
                  'Anonymous', // Display post author's username
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              widget.post.content,
              style: TextStyle(
                fontSize: widget.isUserPost
                    ? 18
                    : 14, // Small text for non-user posts
                color: widget.isUserPost ? Colors.black : Colors.grey,
              ),
            ),
            Divider(),
            // Display the comments with alignment based on the username
            ...widget.post.comments.map(
              (comment) {
                bool isCurrentUser = comment.username == currentUserUsername;
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Align(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? const Color.fromARGB(255, 218, 238, 255)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${comment.username}: ${comment.content}', // Display commenter's username
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_upward, color: Colors.white),
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        widget.onAddComment(commentController.text);

                        // Clear the text field after submission
                        commentController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
