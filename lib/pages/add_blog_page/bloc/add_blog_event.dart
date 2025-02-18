part of 'add_blog_bloc.dart';

@immutable
sealed class AddBlogEvent {}

final class AddBlogButtonPressedEvent extends AddBlogEvent {
  final String title;
  final String content;

  AddBlogButtonPressedEvent(this.title, this.content);
}

class UpdateBlogButtonPressedEvent extends AddBlogEvent {
  final String blogId;
  final String title;
  final String content;

  UpdateBlogButtonPressedEvent(this.blogId, this.title, this.content);
}

class DeleteBlogButtonPressedEvent extends AddBlogEvent {
  final String blogId;

  DeleteBlogButtonPressedEvent(this.blogId);
}
