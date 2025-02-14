import 'package:blog_app/pages/add_blog_page/bloc/add_blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBlogPage extends StatefulWidget {
  const AddBlogPage({super.key});

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Blog')),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Blog added successfully!')),
                  );
                  titleController.clear();
                  contentController.clear();
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
                          context.read<AddBlogBloc>().add(
                                AddBlogButtonPressedEvent(
                                  titleController.text,
                                  contentController.text,
                                ),
                              );
                        },
                        child: Text('Add Blog'),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
