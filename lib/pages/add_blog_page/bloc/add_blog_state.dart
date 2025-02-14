part of 'add_blog_bloc.dart';

@immutable
sealed class AddBlogState {}

final class AddBlogInitial extends AddBlogState {}

final class AddBlogLoadingState extends AddBlogState {}

final class AddBlogSuccessState extends AddBlogState {}

final class AddBlogErrorState extends AddBlogState {
  final String error;

  AddBlogErrorState(this.error);
}
