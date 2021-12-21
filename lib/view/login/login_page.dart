import 'package:application_firebase_app/view/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:application_firebase_app/custom_widgets/modal_rounded_progress_bar.dart';
import 'package:application_firebase_app/utils/assets.dart';
import 'package:application_firebase_app/utils/colors.dart';
import 'package:application_firebase_app/utils/constants.dart';
import 'package:application_firebase_app/view/home/home_page.dart';
import 'package:application_firebase_app/view/login/bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    ProgressBarHandler _handler = ProgressBarHandler();
    TextEditingController phoneNumberTextController = TextEditingController();
    bool isLoading = false;

  

    Future<bool> onWillPop() {
      DateTime? currentBackPressTime;
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: ColorData.toastColor,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStrings.appClosingWarning,
                style: GoogleFonts.merriweather(
                    color: ColorData.text_base_color,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return Future.value(false);
      }
      return Future.value(true);
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: ColorData.white,
        body: BlocProvider(
          create: (context) {
            return LoginBloc();
          },
          child: BlocListener<LoginBloc, LoginState>(
            listener: (BuildContext context, state) {
              if (state is ShowProgressBar) {
                isLoading = true;
                _handler.show();
              } else if (state is DismissProgressBar) {
                isLoading = false;
                _handler.dismiss();
              } else if (state is LoginFailure) {
                final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: ColorData.toastColor,
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.error,
                        style: GoogleFonts.merriweather(
                            color: ColorData.text_base_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (state is LoginValidationFailure) {
                final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: ColorData.toastColor,
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.error,
                        style: GoogleFonts.merriweather(
                            color: ColorData.text_base_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else if (state is LoginSuccess) {
                final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: ColorData.toastColor,
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppStrings.userLoggedSuccessful,
                        style: GoogleFonts.merriweather(
                            color: ColorData.text_base_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()),
                  ModalRoute.withName('/'),
                );
              }
            },
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                double height = MediaQuery.of(context).size.height;
                double width = MediaQuery.of(context).size.width;
                return Stack(
                  children: [
                    buildLoginView(
                        height, width, context, phoneNumberTextController),
                    if (isLoading)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      Container()
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  buildLoginView(double height, double width, BuildContext context,
      TextEditingController phoneNumberTextController) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: height / 4.5),
            height: height / 3,
            width: width / 3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(UIAssets.firebaseLogoImage),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                InkWell(
                  splashColor: ColorData.gray_shade_1,
                  onTap: () {
                    BlocProvider.of<LoginBloc>(context)
                        .add((GoogleSigninPressedEvent()));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 12,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20.0),
                          padding: const EdgeInsets.all(5.0),
                          height: height / 24,
                          width: height / 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                            image: DecorationImage(
                              image: AssetImage(UIAssets.googleIcon),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height / 7),
                          child: Text(
                            AppStrings.google,
                            style: GoogleFonts.merriweather(
                                color: ColorData.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    BuildContext con = context;
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15)),
                              child: Container(
                                  height: height * 0.25,
                                  margin: EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: AppStrings.phoneNumberSignin ==
                                                  AppStrings.orderStatusTxt
                                              ? Text(
                                                  AppStrings.phoneNumberSignin,
                                                  style:
                                                      TextStyle(fontSize: 26),
                                                )
                                              : TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      phoneNumberTextController,
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(
                                                        10)
                                                  ],
                                                  decoration: InputDecoration(
                                                    labelText: AppStrings.phone,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode());
                                              BlocProvider.of<LoginBloc>(con).add(
                                                  (PhoneNumberSigninPressedEvent(
                                                      phoneNumber:
                                                          phoneNumberTextController
                                                              .text,
                                                      context: con)));

                                              phoneNumberTextController.clear();
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                color: Colors.blue,
                                              ),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15.0, 5.0, 15.0, 5.0),
                                              child: Text(
                                                AppStrings.ok,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: true,
                                            child: InkWell(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                Navigator.of(context).pop();
                                                phoneNumberTextController
                                                    .clear();
                                                print(AppStrings
                                                    .phoneNumberSignInFailed);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          8.0),
                                                  color: Colors.blue,
                                                ),
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15.0, 5.0, 15.0, 5.0),
                                                child: Text(
                                                  AppStrings.cancel,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                    ],
                                  )));
                        });
                  },
                  child: Container(
                    height: height / 12,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(left: 25.0),
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 27.0,
                            )),
                        Container(
                          margin: EdgeInsets.only(left: height / 7),
                          child: Text(
                            AppStrings.phone,
                            style: GoogleFonts.merriweather(
                                color: ColorData.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  splashColor: ColorData.gray_shade_1,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  child: Container(
                      height: height / 12,
                      margin:
                      EdgeInsets.symmetric(horizontal: 20.0, ),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    child: Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(left: 25.0),
                            child: Icon(
                              Icons.email,
                              color: Colors.white,
                              size: 27.0,
                            )),
                        Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height / 7),
                          child: Text(
                            "Email",
                            style: GoogleFonts.merriweather(
                                color: ColorData.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
