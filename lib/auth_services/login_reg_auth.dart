import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailPassAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SnackBar Function
  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  // Sign up with email and password
  Future<User?> register(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      showSnackBar(context, 'Sign up successful!', Color(0XFFBAE162));
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar(
          context,
          'The email is already in use.',
          const Color(0XFF162535),
        );
      } else if (e.code == 'weak-password') {
        showSnackBar(
          context,
          'The password provided is too weak.',
          const Color(0XFF162535),
        );
      } else if (e.code == 'invalid-email') {
        showSnackBar(
          context,
          'The email address is not valid.',
          const Color(0XFF162535),
        );
      }
      return null;
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e', Colors.redAccent);
      return null;
    }
  }

  // Log in with email and password
  Future<User?> login(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      showSnackBar(context, 'Login successful!', Color(0XFFBAE162));
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => HomePage()));
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        context,
        'Error: $e',
        const Color(0XFF162535),
      );
      return null;
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e', Colors.redAccent);
      return null;
    }
  }

  // Log out
  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => LoginPage()));
      showSnackBar(context, 'Logged out successfully!', Color(0XFFBAE162));
    } catch (e) {
      showSnackBar(context, 'An error occurred: $e', Colors.redAccent);
    }
  }

  // Get currently logged-in user
  User? get currentUser => _auth.currentUser;
}
