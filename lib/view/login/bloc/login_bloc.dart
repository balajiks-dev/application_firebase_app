import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:application_firebase_app/utils/colors.dart';
import 'package:application_firebase_app/utils/constants.dart';
import 'package:application_firebase_app/view/home/home_page.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(InitialLoginState());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is GoogleSigninPressedEvent) {
      yield ShowProgressBar();

      GoogleSignIn _googleSignIn = GoogleSignIn();
      User user;

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userDetail =
          await FirebaseAuth.instance.signInWithCredential(credential);

      user = userDetail.user!;
      await _googleSignIn.isSignedIn();

      print(userDetail.user!.email);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(AppStrings.userName, userDetail.user!.displayName!);
      prefs.setString(AppStrings.userMail, userDetail.user!.email!);
      prefs.setString(AppStrings.userUID, userDetail.user!.uid);
      prefs.setString(AppStrings.userPhoto, userDetail.user!.photoURL!);

      yield DismissProgressBar();
      yield LoginSuccess(user: user);
    } else if (event is PhoneNumberSigninPressedEvent) {
      yield ShowProgressBar();
      if (event.phoneNumber.isEmpty || event.phoneNumber.length != 10) {
        yield DismissProgressBar();
        yield LoginValidationFailure(
            error: event.phoneNumber.isEmpty
                ? AppStrings.enterMobileNumber
                : AppStrings.enterValidMobileNumber);
      } else {
        FirebaseAuth _auth = FirebaseAuth.instance;
        TextEditingController _codeController = TextEditingController();
        _auth.verifyPhoneNumber(
          phoneNumber: "+91" + event.phoneNumber,
          timeout: Duration(seconds: 120),
          verificationCompleted: (AuthCredential credential) async {
            final snackBar = SnackBar(
                duration: Duration(seconds: 2),
                backgroundColor: ColorData.toastColor,
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "OTP Sent to your phone number successfully!",
                    style: GoogleFonts.merriweather(
                        color: ColorData.text_base_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ));
            ScaffoldMessenger.of(event.context).showSnackBar(snackBar);
          },
          verificationFailed: (FirebaseAuthException e) {
            print(e);
            final snackBar = SnackBar(
                duration: Duration(seconds: 2),
                backgroundColor: ColorData.toastColor,
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    e.message!,
                    style: GoogleFonts.merriweather(
                        color: ColorData.text_base_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ));
            ScaffoldMessenger.of(event.context).showSnackBar(snackBar);
          },
          codeSent: (String? verificationId, [int? forceResendingToken]) {
            showDialog(
                context: event.context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15)),
                        child: Container(
                            height: 140.0,
                            margin: EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: _codeController,
                                      decoration: InputDecoration(
                                        labelText: AppStrings.otp,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () async {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();

                                        if (_codeController.text.isNotEmpty) {
                                          try {
                                            String code =
                                                _codeController.text.trim();
                                            final AuthCredential credential =
                                                PhoneAuthProvider.credential(
                                              verificationId: verificationId!,
                                              smsCode: code,
                                            );
                                            final UserCredential user =
                                                await _auth
                                                    .signInWithCredential(
                                                        credential);

                                            if (user.user!.phoneNumber!
                                                .isNotEmpty) {
                                              _codeController.clear();
                                              prefs.setString(
                                                  AppStrings.phoneNumber,
                                                  user.user!.phoneNumber!);
                                              prefs.setString(
                                                  AppStrings.userUID,
                                                  user.user!.uid);

                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        HomePage()),
                                                ModalRoute.withName('/'),
                                              );
                                            } else {
                                              _codeController.clear();
                                              Navigator.pop(context);
                                              final snackBar = SnackBar(
                                                  duration:
                                                      Duration(seconds: 2),
                                                  backgroundColor:
                                                      ColorData.toastColor,
                                                  content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Login Failed!",
                                                      style: GoogleFonts
                                                          .merriweather(
                                                              color: ColorData
                                                                  .text_base_color,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  ));
                                              ScaffoldMessenger.of(
                                                      event.context)
                                                  .showSnackBar(snackBar);
                                            }
                                          } catch (e) {
                                            _codeController.clear();
                                            print(e);
                                            Navigator.pop(context);
                                            final snackBar = SnackBar(
                                                duration: Duration(seconds: 2),
                                                backgroundColor:
                                                    ColorData.toastColor,
                                                content: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    e.toString(),
                                                    style: GoogleFonts
                                                        .merriweather(
                                                            color: ColorData
                                                                .text_base_color,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ),
                                                ));
                                            ScaffoldMessenger.of(event.context)
                                                .showSnackBar(snackBar);
                                          }
                                        } else {
                                          Navigator.pop(context);
                                          final snackBar = SnackBar(
                                              duration: Duration(seconds: 2),
                                              backgroundColor:
                                                  ColorData.toastColor,
                                              content: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Login Failed!",
                                                  style:
                                                      GoogleFonts.merriweather(
                                                          color: ColorData
                                                              .text_base_color,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ));
                                          ScaffoldMessenger.of(event.context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            15.0, 5.0, 15.0, 5.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          color: Colors.blue,
                                        ),
                                        child: Text(
                                          AppStrings.submitOTP,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            )));
                  });
                });
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }
    }
  }
}
