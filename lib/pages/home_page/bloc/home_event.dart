part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class LogoutButtonPressedEvent extends HomeEvent {}

final class AddButtonPressedEvent extends HomeEvent {}

final class FetchBlogsEvent extends HomeEvent {}
