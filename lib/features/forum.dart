// forum.dart is the page for allowing users to interact and communicate
// with the community by writing posts and comments. They are also allowed to
// delete their own posts.

import 'package:Tinig/firebase/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/forum_service.dart';
import '../screens/nav.dart';

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
        if (!mounted) return; // Stop if the widget is unmounted

        List<Comment> comments = await fetchComments(post.id);
        post.comments = comments;

        // Sort comments by timestamp
        post.comments.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }

      // Sort posts by timestamp before updating the state
      fetchedPosts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Update the state with posts and their comments
      if (mounted) {
        setState(() {
          posts = fetchedPosts;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load posts: $e')),
        );
      }
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      // Perform Firestore deletion (Delete the comments first if needed)
      await ForumService().deletePost(context, postId);

      // Once Firestore deletion is done, update local state
      setState(() {
        posts.removeWhere((post) => post.id == postId);
      });

      // Show a success snackbar or alert
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post deleted successfully')),
      );
    } catch (e) {
      // If an error occurs during deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post')),
      );
      print("Error deleting post: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadPosts();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        // App bar containing the icon for drawer
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color: const Color(0xFF4D8FF8),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
      ),
      drawer: NavDrawer(activeNav: '/forum'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community Forum',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D8FF8),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Welcome to Tinig's community forum. Through this, we hope to bridge hearts and experiences across our deaf community.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            Divider(
              // Adds a line or divider
              color: Colors.grey,
              thickness: 2,
            ),
            // Add the toggle button here, below the Deaf Community Forum text
            Row(
              children: [
                Text(
                  'Show only my posts',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(width: 5),
                Transform.scale(
                  scale:
                      0.8, // Adjust the scale factor to change the size (e.g., 1.5 for larger, 0.8 for smaller)
                  child: Switch(
                    value: showUserPostsOnly,
                    onChanged: (value) {
                      toggleUserPostsFilter();
                    },
                    activeColor: Color(0xFF4D8FF8),
                    activeTrackColor: Colors.blue[200],
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey[300],
                    splashRadius: 10.0,
                  ),
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
                      color: Colors.grey[100],
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
                    color: Color(0xFF4D8FF8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_upward, color: Colors.white),
                    iconSize: 20.0,
                    onPressed: () {
                      if (postController.text.isNotEmpty) {
                        handleAddPost(postController.text);

                        // Clear the text field after submission
                        postController.clear();
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
                    onDeletePost: deletePost, // Pass the delete function
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
  DateTime timestamp;
  List<Comment> comments;

  Post({
    required this.id,
    required this.content,
    this.username,
    List<Comment>? comments,
    required this.timestamp,
  }) : comments = comments ?? [];

  // Factory method to create a Post instance from Firestore data
  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Retrieve the timestamp from Firestore
    final timestamp = (data['timestamp'] as Timestamp).toDate();

    return Post(
      id: doc.id,
      content: data['content'] ?? '',
      username: data['username'],
      timestamp: timestamp,
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
  final Function(String) onDeletePost;

  const PostCard({
    required this.post,
    required this.onAddComment,
    required this.isUserPost,
    required this.onDeletePost,
    required this.currentUser,
  });

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                // PopupMenuButton for delete option
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  onSelected: (value) async {
                    if (value == 'delete') {
                      if (widget.post.username == currentUserUsername) {
                        try {
                          // Call the delete post function from the parent
                          await widget.onDeletePost(widget.post.id);

                          // Show success snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Post deleted successfully')),
                          );
                        } catch (e) {
                          // Show error snackbar if deletion fails
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to delete post')),
                          );
                        }
                      } else {
                        // Notify the user they cannot delete someone else's post
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('You cannot delete this post')),
                        );
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete Post'),
                    ),
                  ],
                )
              ],
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
                    color: Color(0xFF4D8FF8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_upward, color: Colors.white),
                    iconSize: 20.0,
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
