import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application_firebase_app/bloc_delegate.dart';
import 'package:application_firebase_app/view/app/app.dart';

Future<void> main() async {
    Bloc.observer =
      SimpleBlocObserver();

  print("=====> main() called");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

