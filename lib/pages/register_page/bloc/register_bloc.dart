import 'dart:async';

import 'package:bloc/bloc.dart';
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(RegisterSuccessState());
    } catch (e) {
      emit(RegisterErrorState(e.toString()));
    }
  }
}
