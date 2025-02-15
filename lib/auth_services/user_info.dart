import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentUserInfo {
  static Future<DocumentSnapshot?> getUserInfo(User user) async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
    } catch (e) {
      print("Error fetching user info: $e");
      return null;
    }
  }
}
