part of 'home_bloc.dart';

class Blog {
  final String id;
  final String title;
  final String content;

  Blog({required this.id, required this.title, required this.content});
}

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class LogoutSuccessState extends HomeState {}

final class AddButtonPressedState extends HomeState {}

final class FetchBlogsLoadingState extends HomeState {}

final class FetchBlogsSuccessState extends HomeState {
  final List<Blog> blogs;
  FetchBlogsSuccessState(this.blogs);
}

final class FetchBlogsErrorState extends HomeState {
  final String errorMessage;
  FetchBlogsErrorState(this.errorMessage);
}
