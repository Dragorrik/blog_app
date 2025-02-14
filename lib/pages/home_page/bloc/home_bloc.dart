import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LogoutButtonPressedEvent>(logoutButtonPressedEvent);
    on<AddButtonPressedEvent>(addButtonPressedEvent);
  }

  FutureOr<void> logoutButtonPressedEvent(
      LogoutButtonPressedEvent event, Emitter<HomeState> emit) async {
    await FirebaseAuth.instance.signOut();
    emit(LogoutSuccessState());
  }

  FutureOr<void> addButtonPressedEvent(
      AddButtonPressedEvent event, Emitter<HomeState> emit) async {
    emit(AddButtonPressedState());
  }
}
