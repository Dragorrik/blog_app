import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterButtonPressedEvent>(registerButtonPressedEvent);
  }

  FutureOr<void> registerButtonPressedEvent(
      RegisterButtonPressedEvent event, Emitter<RegisterState> emit) async {
    emit(RegisterLoadingState());
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // Get UID of the registered user
      String uid = userCredential.user!.uid;

      // Store user information in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': event.userName,
        'email': event.email,
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      emit(RegisterSuccessState());
    } catch (e) {
      emit(RegisterErrorState(e.toString()));
    }
  }
}
