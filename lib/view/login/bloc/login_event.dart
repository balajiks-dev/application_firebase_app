part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class GoogleSigninPressedEvent extends LoginEvent {
  @override
  List<Object> get props => [];
}

class PhoneNumberSigninPressedEvent extends LoginEvent {
  final String phoneNumber;
  final BuildContext context;
  PhoneNumberSigninPressedEvent({required this.phoneNumber, required this.context});
  @override
  List<Object> get props => [phoneNumber, context];
}
