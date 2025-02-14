import 'package:blog_app/pages/home_page/bloc/home_bloc.dart';
import 'package:blog_app/pages/home_page/ui/home.dart';
import 'package:blog_app/pages/login_page/bloc/login_bloc.dart';
import 'package:blog_app/pages/login_page/ui/login.dart';
import 'package:blog_app/pages/register_page/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Blog App',
      theme: ThemeData(),
      home: LoginPage(),
    );
  }
}
