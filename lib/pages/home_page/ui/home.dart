import 'package:blog_app/pages/add_blog_page/ui/add_blog_page.dart';
import 'package:blog_app/pages/home_page/bloc/home_bloc.dart';
import 'package:blog_app/pages/login_page/ui/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  final String currentUserName;
  final String currentUserEmail;
  const Home(
      {super.key,
      required this.currentUserName,
      required this.currentUserEmail});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot> getBlogsStream() {
    return FirebaseFirestore.instance
        .collection('blogs')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Future<void> addReaction(String blogId, String reaction) async {
    await FirebaseFirestore.instance
        .collection('blogs')
        .doc(blogId)
        .collection('reactions')
        .doc(widget.currentUserEmail)
        .set({'username': widget.currentUserName, 'reaction': reaction});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is LogoutSuccessState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else if (state is AddButtonPressedState) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBlogPage()),
              );
            }
          },
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Flutter Blog App'),
                    Text(
                      'Welcome, ${widget.currentUserName}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (widget.currentUserEmail == 'aarik@gmail.com')
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.greenAccent),
                        onPressed: () {
                          context.read<HomeBloc>().add(AddButtonPressedEvent());
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      onPressed: () {
                        context
                            .read<HomeBloc>()
                            .add(LogoutButtonPressedEvent());
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getBlogsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No blogs available.'));
          }

          var blogs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              var blog = blogs[index];
              String blogId = blog.id;
              String title = blog['title'];
              String content = blog['content'];

              return Card(
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        content,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: widget.currentUserEmail == 'aarik@gmail.com'
                          ? SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddBlogPage(
                                            blogId: blogId,
                                            existingTitle: title,
                                            existingContent: content,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('blogs')
                                          .doc(blogId)
                                          .delete();
                                    },
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('blogs')
                          .doc(blogId)
                          .collection('reactions')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return SizedBox();
                        var reactions = snapshot.data!.docs;
                        return Wrap(
                          spacing: 10,
                          children: reactions.map((reaction) {
                            return Text('${reaction['reaction']} ');
                          }).toList(),
                        );
                      },
                    ),
                    Wrap(
                      spacing: 10,
                      children: ['👍', '❤️', '😂', '😢'].map((emoji) {
                        return IconButton(
                          onPressed: () => addReaction(blogId, emoji),
                          icon: Text(emoji, style: TextStyle(fontSize: 24)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
