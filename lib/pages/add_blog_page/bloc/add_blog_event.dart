part of 'add_blog_bloc.dart';

@immutable
sealed class AddBlogEvent {}

final class AddBlogButtonPressedEvent extends AddBlogEvent {
  final String title;
  final String content;

  AddBlogButtonPressedEvent(this.title, this.content);
}
