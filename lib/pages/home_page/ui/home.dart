import 'package:blog_app/pages/home_page/bloc/home_bloc.dart';
import 'package:blog_app/pages/login_page/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  final String currentUserEmail;
  const Home({super.key, required this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is LogoutSuccessState) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            } else if (state is AddButtonPressedState) {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => AddBlogPage()));
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
                      'Welcome, $currentUserEmail',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    currentUserEmail == 'aarik@gmail.com'
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.greenAccent,
                              ),
                              onPressed: () {
                                context
                                    .read<HomeBloc>()
                                    .add(LogoutButtonPressedEvent());
                              },
                            ),
                          )
                        : SizedBox(),
                    SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          context
                              .read<HomeBloc>()
                              .add(LogoutButtonPressedEvent());
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
