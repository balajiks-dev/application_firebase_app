import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application_firebase_app/utils/assets.dart';
import 'package:application_firebase_app/utils/colors.dart';
import 'package:application_firebase_app/view/app/bloc/authentication_bloc.dart';
import 'package:application_firebase_app/view/home/home_page.dart';
import 'package:application_firebase_app/view/login/login_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationBloc()..add(AuthenticationStatusCheck()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (BuildContext context, state) {
            if (state is UnauthenticatedState) {
                Navigator.pushAndRemoveUntil(
                    context, LoginPage.route(), (route) => false);
            } else if (state is AuthenticatedState){
                                  Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomePage()),
            ModalRoute.withName('/'),
          );
            }
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              double height = MediaQuery.of(context).size.height;
              double width = MediaQuery.of(context).size.width;
              return Container(
                  height: height,
                  width: width,
                  color: ColorData.white,
                  child: Center(
                    child: Image.asset(
                      UIAssets.zartekLogoImage,
                    ),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
