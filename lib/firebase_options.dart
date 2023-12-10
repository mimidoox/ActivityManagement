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
    apiKey: 'AIzaSyCp7wmOAyhePz1A2xs3aA4WwD-weltJpIU',
    appId: '1:347834423860:web:727c58467c5b739eb20861',
    messagingSenderId: '347834423860',
    projectId: 'mvpdb-8b567',
    authDomain: 'mvpdb-8b567.firebaseapp.com',
    storageBucket: 'mvpdb-8b567.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6F52Labg0GcCPPcrLFJUdpSs5TEUHuCc',
    appId: '1:347834423860:android:873b1d530d7918d7b20861',
    messagingSenderId: '347834423860',
    projectId: 'mvpdb-8b567',
    storageBucket: 'mvpdb-8b567.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3ioE-zeKTabKvTYCubGa4uOuUTEUUjB8',
    appId: '1:347834423860:ios:3b8dab7584688de4b20861',
    messagingSenderId: '347834423860',
    projectId: 'mvpdb-8b567',
    storageBucket: 'mvpdb-8b567.appspot.com',
    iosBundleId: 'com.example.mvp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC3ioE-zeKTabKvTYCubGa4uOuUTEUUjB8',
    appId: '1:347834423860:ios:3b8dab7584688de4b20861',
    messagingSenderId: '347834423860',
    projectId: 'mvpdb-8b567',
    storageBucket: 'mvpdb-8b567.appspot.com',
    iosBundleId: 'com.example.mvp',
  );
}
