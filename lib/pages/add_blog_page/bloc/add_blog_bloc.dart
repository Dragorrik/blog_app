import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'add_blog_event.dart';
part 'add_blog_state.dart';

class AddBlogBloc extends Bloc<AddBlogEvent, AddBlogState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  AddBlogBloc() : super(AddBlogInitial()) {
    on<AddBlogButtonPressedEvent>(addBlogButtonPressedEvent);
    on<UpdateBlogButtonPressedEvent>(updateBlogButtonPressedEvent);
  }

  FutureOr<void> addBlogButtonPressedEvent(
      AddBlogButtonPressedEvent event, Emitter<AddBlogState> emit) async {
    emit(AddBlogLoadingState());
    try {
      firestore.collection('blogs').add({
        'title': event.title,
        'content': event.content,
        'created_at': FieldValue.serverTimestamp(),
      });
      await Future.delayed(Duration(seconds: 2));
      emit(AddBlogSuccessState());
    } catch (e) {
      emit(AddBlogErrorState(e.toString()));
    }
  }

  FutureOr<void> updateBlogButtonPressedEvent(
      UpdateBlogButtonPressedEvent event, Emitter<AddBlogState> emit) async {
    emit(AddBlogLoadingState());

    try {
      await FirebaseFirestore.instance
          .collection('blogs')
          .doc(event.blogId)
          .update({
        'title': event.title,
        'content': event.content,
        'updated_at': FieldValue.serverTimestamp(),
      });

      emit(AddBlogSuccessState());
    } catch (e) {
      emit(AddBlogErrorState(e.toString()));
    }
  }
}
