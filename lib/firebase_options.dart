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
    apiKey: 'AIzaSyDXCOHqWGFBCcwZ9WzlM1GLNUZ7KwV153w',
    appId: '1:850606701308:web:73b33da2d6cc37f8a7f579',
    messagingSenderId: '850606701308',
    projectId: 'track-planner-4132',
    authDomain: 'track-planner-4132.firebaseapp.com',
    storageBucket: 'track-planner-4132.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwH6d32TmD3TL_sizIuwrzHiFeisb6HUw',
    appId: '1:850606701308:android:d9bdf0ca8963b750a7f579',
    messagingSenderId: '850606701308',
    projectId: 'track-planner-4132',
    storageBucket: 'track-planner-4132.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC62svkkgviutz2C06Bp7jk6fQqmLOkoaU',
    appId: '1:850606701308:ios:ed21e66282c0650ba7f579',
    messagingSenderId: '850606701308',
    projectId: 'track-planner-4132',
    storageBucket: 'track-planner-4132.appspot.com',
    iosBundleId: 'com.example.trackPlanner',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC62svkkgviutz2C06Bp7jk6fQqmLOkoaU',
    appId: '1:850606701308:ios:cbbe64ac49323e81a7f579',
    messagingSenderId: '850606701308',
    projectId: 'track-planner-4132',
    storageBucket: 'track-planner-4132.appspot.com',
    iosBundleId: 'com.example.trackPlanner.RunnerTests',
  );
}
