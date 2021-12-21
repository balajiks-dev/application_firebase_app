import 'package:application_firebase_app/utils/colors.dart';
import 'package:application_firebase_app/view/authentication.dart';
import 'package:application_firebase_app/view/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login/login_page.dart';


class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SizedBox(height: 80),
          // logo
          Column(
            children: [
              FlutterLogo(
                size: 55,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top:50.0,bottom: 30),
            child: Text(
              'Welcome!',
              style: TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SignupForm(),
          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Row(
                    children: <Widget>[
                      Text('Already here?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
                        },
                        child: Text(' Get Logged in Now!',
                            style: TextStyle(fontSize: 20, color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0,top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Go Back',
                              style: TextStyle(fontSize: 20, color: Colors.black)),
                        ),
                      ),
                      Icon(Icons.arrow_back,size: 25,),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String name = "";
  bool _obscureText = true;

  bool agree = false;

  final pass = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        const Radius.circular(100.0),
      ),
    );

    var space = SizedBox(height: 25);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // email
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: 'Email',
                  border: border),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (val) {
                email = val!;
              },
              keyboardType: TextInputType.emailAddress,
            ),

            space,

            // password
            TextFormField(
              controller: pass,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: border,
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
              onSaved: (val) {
                password = val!;
              },
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            space,
            // confirm passwords
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock_outline),
                border: border,
              ),
              obscureText: true,
              validator: (value) {
                if (value != pass.text) {
                  return 'password not match';
                }
                return null;
              },
            ),
            space,
            // name
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.account_circle),
                border: border,
              ),
              onSaved: (val) {
                name = val!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some name';
                }
                return null;
              },
            ),
            space,

            // signUP button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  AuthenticationHelper()
                      .signUp(email: email, password: password)
                      .then((result) {
                    if (result == null) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => SignIn()),
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
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}