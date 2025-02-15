import 'package:blog_app/pages/add_blog_page/bloc/add_blog_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBlogPage extends StatefulWidget {
  final String? blogId;
  final String? existingTitle;
  final String? existingContent;

  const AddBlogPage(
      {super.key, this.blogId, this.existingTitle, this.existingContent});

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingTitle != null) {
      titleController.text = widget.existingTitle!;
      contentController.text = widget.existingContent!;
    }
  }

  void createReactionCollection(String blogId) async {
    final reactionsRef = FirebaseFirestore.instance
        .collection('blogs')
        .doc(blogId)
        .collection('reactions');
    await reactionsRef.doc('placeholder').set({'user': '', 'reaction': ''});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.blogId == null ? 'Add Blog' : 'Edit Blog')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            const SizedBox(height: 20),
            BlocConsumer<AddBlogBloc, AddBlogState>(
              listener: (context, state) {
                if (state is AddBlogSuccessState) {
                  if (widget.blogId == null) {
                    createReactionCollection(state.blogId);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.blogId == null
                          ? 'Blog added successfully!'
                          : 'Blog updated successfully!'),
                    ),
                  );
                  Navigator.pop(context);
                } else if (state is AddBlogErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red),
                  );
                }
              },
              builder: (context, state) {
                return state is AddBlogLoadingState
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (titleController.text.isEmpty ||
                              contentController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Title and content cannot be empty")),
                            );
                            return;
                          }

                          if (widget.blogId == null) {
                            context.read<AddBlogBloc>().add(
                                  AddBlogButtonPressedEvent(
                                    titleController.text,
                                    contentController.text,
                                  ),
                                );
                          } else {
                            context.read<AddBlogBloc>().add(
                                  UpdateBlogButtonPressedEvent(
                                    widget.blogId!,
                                    titleController.text,
                                    contentController.text,
                                  ),
                                );
                          }
                        },
                        child: Text(
                            widget.blogId == null ? 'Add Blog' : 'Update Blog'),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
