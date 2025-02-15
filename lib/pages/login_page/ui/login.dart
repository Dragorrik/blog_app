import 'package:blog_app/auth_services/user_info.dart';
import 'package:blog_app/pages/home_page/ui/home.dart';
import 'package:blog_app/pages/login_page/bloc/login_bloc.dart';
import 'package:blog_app/pages/register_page/ui/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    emailController.text = 'aarik@gmail.com';
    passwordController.text = '123456';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginSuccessState) {
              final currentUser = FirebaseAuth.instance.currentUser;

              if (currentUser != null) {
                // Fetch user details from Firestore using UID
                DocumentSnapshot? userDoc =
                    await CurrentUserInfo.getUserInfo(currentUser);

                // Extract username (default to 'Unknown User' if not found)
                String currentUserName = (userDoc != null && userDoc.exists)
                    ? userDoc.get('username') ?? 'Unknown User'
                    : 'Unknown User';
                String currentUserEmail = (userDoc != null && userDoc.exists)
                    ? userDoc.get('email') ?? 'Unknown User'
                    : 'Unknown User';

                // Navigate to Home page with username
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(
                      currentUserName: currentUserName,
                      currentUserEmail: currentUserEmail,
                    ),
                  ),
                );
              }
            } else if (state is LoginErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.redAccent,
              ));
            }
          },
          builder: (context, state) {
            if (state is LoginLoadingState) {
              return Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.5),
                  child: Center(child: CircularProgressIndicator()));
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //Sign in title
                Container(
                  height: screenHeight * 0.25,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0XFF162535),
                    //borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.09, left: 20, bottom: 20),
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Login\n',
                        style: TextStyle(
                          fontSize: screenWidth * 0.15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign in to your account',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.normal,
                          color: const Color.fromARGB(255, 146, 146, 146),
                        ),
                      ),
                    ]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //email input
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      //password input
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      //forgot password text
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Color(0XFFBAE162),
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.04),
                            ),
                          ),
                        ],
                      ),
                      //login button
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.read<LoginBloc>().add(LoginButtonPressed(
                              emailController.text, passwordController.text));
                          emailController.clear();
                          passwordController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFFBAE162),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      //don't have an account text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Color(0XFFBAE162),
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
