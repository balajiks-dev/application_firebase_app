import 'package:application_firebase_app/utils/colors.dart';
import 'package:application_firebase_app/utils/constants.dart';
import 'package:application_firebase_app/view/authentication.dart';
import 'package:application_firebase_app/view/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/home_page.dart';


class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          SizedBox(height: 80),
          // logo
          Column(
            children: [
              FlutterLogo(
                size: 55,
              ),
              SizedBox(height: 50),
              Text(
                'Welcome back!',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),

          SizedBox(
            height: 50,
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LoginForm(),
          ),

          // SizedBox(height: 20),

          // Row(
          //   children: <Widget>[
          //     SizedBox(width: 30),
          //     Text('New here? ',
          //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          //     GestureDetector(
          //       onTap: () {
          //         Navigator.push(context,
          //             MaterialPageRoute(builder: (context) => Signup()));
          //       },
          //       child: Text('Get Registered Now!!',
          //           style: TextStyle(fontSize: 20, color: Colors.blue)),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }

  Container buildLogo() {
    return Container(
      height: 80,
      width: 80,
      // padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.blue),
      child: Center(
        child: Text(
          "T",
          style: TextStyle(color: Colors.white, fontSize: 60.0),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // email
            TextFormField(
              // initialValue: 'Input text',
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    const Radius.circular(100.0),
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (val) {
                email = val!;
              },
            ),
            SizedBox(
              height: 20,
            ),

            // password
            TextFormField(
              // initialValue: 'Input text',
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    const Radius.circular(100.0),
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              obscureText: _obscureText,
              onSaved: (val) {
                password = val!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),

            SizedBox(height: 30),

            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    AuthenticationHelper()
                        .signIn(email: email, password: password)
                        .then((result) {
                      if (result != null) {
                        prefs.setString(AppStrings.userName, result.displayName == null ?"":result.displayName);
                        prefs.setString(AppStrings.userMail, result.email);
                        prefs.setString(AppStrings.userUID, result.uid);
                        prefs.setString(AppStrings.userPhoto, result.photoURL == null?"":result.photoURL);
                        final snackBar = SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: ColorData.toastColor,
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Logged Successfully",
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
                      } else {
                        final snackBar = SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: ColorData.toastColor,
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                               result,
                                style: GoogleFonts.merriweather(
                                    color: ColorData.text_base_color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ));

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
                       SizedBox(height: 30),
          Row(
            children: [
              Text("Don't have an account? ", style: TextStyle(
                color: Colors.black,
              ),),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  child: Text("Sign up account", style: TextStyle(
                    color: Colors.blue,
                  ),),
                ),
              ),
            ],
          )
          ],
        ),
      ),
    );
  }
}
