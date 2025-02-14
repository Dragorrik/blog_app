import 'package:blog_app/pages/home_page/bloc/home_bloc.dart';
import 'package:blog_app/pages/login_page/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is LogoutSuccessState) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            }
          },
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Flutter Blog App'),
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    context.read<HomeBloc>().add(LogoutButtonPressedEvent());
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
