import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LogoutButtonPressedEvent>(logoutButtonPressedEvent);
    on<AddButtonPressedEvent>(addButtonPressedEvent);
    on<FetchBlogsEvent>(fetchBlogsEvent);
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

  FutureOr<void> fetchBlogsEvent(
      FetchBlogsEvent event, Emitter<HomeState> emit) async {
    emit(FetchBlogsLoadingState());
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('blogs')
          .orderBy('createdAt', descending: true)
          .get();

      List<Blog> blogs = snapshot.docs.map((doc) {
        return Blog(
          id: doc.id,
          title: doc['title'],
          content: doc['content'],
        );
      }).toList();
      emit(FetchBlogsSuccessState(blogs));
    } catch (e) {
      emit(FetchBlogsErrorState(e.toString()));
    }
  }
}
