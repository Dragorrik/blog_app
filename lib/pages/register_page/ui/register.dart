import 'package:blog_app/pages/login_page/ui/login.dart';
import 'package:blog_app/pages/register_page/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "You have registered successfully,\nplease login now",
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.lightGreen,
              ));
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            } else if (state is RegisterErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ));
            }
          },
          builder: (context, state) {
            if (state is RegisterLoadingState) {
              return Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.5),
                  child: Center(child: CircularProgressIndicator()));
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //Register title
                Container(
                  height: screenHeight * 0.24,
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
                        text: 'Register\n',
                        style: TextStyle(
                          fontSize: screenWidth * 0.15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'Create your account',
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
                      //User name input
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                      //confirm pass input
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Comfirm password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      //Register button
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (passwordController.text !=
                              confirmPasswordController.text) {
                            return;
                          }
                          context.read<RegisterBloc>().add(
                              RegisterButtonPressedEvent(emailController.text,
                                  passwordController.text));
                          emailController.clear();
                          passwordController.clear();
                          confirmPasswordController.clear();
                          nameController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFFBAE162),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      //don't have an account text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Have an account?',
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
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Login',
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
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
