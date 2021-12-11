part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class InitialLoginState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess({required this.user});
  @override
  List<Object> get props => [user];
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});
  @override
  List<Object> get props => [error];
}

class LoginValidationFailure extends LoginState {
  final String error;

  const LoginValidationFailure({required this.error});
  @override
  List<Object> get props => [error];
}

class ShowProgressBar extends LoginState {
  @override
  List<Object> get props => [];
}

class DismissProgressBar extends LoginState {
  @override
  List<Object> get props => [];
}
