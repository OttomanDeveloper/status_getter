import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/core/functions/http_override/http_override_fun_core.dart';
import 'package:statusgetter/firebase_options.dart';
import 'package:statusgetter/views/initial/initial_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize `HydratedBloc Storage`
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  // Set Screen `Orientation`
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Add Insecure Network Calls Handler
  HttpOverrides.global = MyHttpOverrides();
  // Initialize `GetIt` Instances
  unawaited(initializeGetIt());
  // Initialize `FirebaseCore`
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // return the run function
  return runApp(const InitialView());
}
