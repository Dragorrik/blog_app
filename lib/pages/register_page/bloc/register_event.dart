part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

final class RegisterButtonPressedEvent extends RegisterEvent {
  final String email;
  final String password;

  RegisterButtonPressedEvent(this.email, this.password);
}
