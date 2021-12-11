import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:application_firebase_app/utils/constants.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(InitialAuthenticationState());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStatusCheck) {
      await Future.delayed(Duration(seconds: 3));

      bool isUserSignedIn = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString(AppStrings.userUID) != null) {
        isUserSignedIn = true;
      }


      if (isUserSignedIn) {
        yield AuthenticatedState();
      } else {
        yield UnauthenticatedState();
      }
    }
  }
}
