// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD_LmZCEoxLcldlCY4IdBtgqXjCau6xV3s',
    appId: '1:995458264256:web:66af5765756e99b11bd125',
    messagingSenderId: '995458264256',
    projectId: 'status-getter-otto',
    authDomain: 'status-getter-otto.firebaseapp.com',
    storageBucket: 'status-getter-otto.appspot.com',
    measurementId: 'G-155M76YSHM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6BQuTwiBF1e7VuaBRSVkk4X8j1DthT68',
    appId: '1:995458264256:android:917c84b299a1e24b1bd125',
    messagingSenderId: '995458264256',
    projectId: 'status-getter-otto',
    storageBucket: 'status-getter-otto.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB_bA0y5AAOtpAsHyxF-6wbNljx2ynzAzE',
    appId: '1:995458264256:ios:19f90c3ebfb8e4a21bd125',
    messagingSenderId: '995458264256',
    projectId: 'status-getter-otto',
    storageBucket: 'status-getter-otto.appspot.com',
    iosBundleId: 'com.androidsaver.statusgetter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB_bA0y5AAOtpAsHyxF-6wbNljx2ynzAzE',
    appId: '1:995458264256:ios:337de4b4be1610f31bd125',
    messagingSenderId: '995458264256',
    projectId: 'status-getter-otto',
    storageBucket: 'status-getter-otto.appspot.com',
    iosBundleId: 'com.androidsaver.statusgetter.RunnerTests',
  );
}
