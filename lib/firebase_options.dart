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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB0wEBCpB8OwlJBgpivdvF4HeYgF-hj3_4',
    appId: '1:625199994649:web:7dbd601a42b7176bad5788',
    messagingSenderId: '625199994649',
    projectId: 'medix-sds',
    authDomain: 'medix-sds.firebaseapp.com',
    storageBucket: 'medix-sds.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDq1fd67EGCFZJChjhM1qkOYuXaF1yb9ko',
    appId: '1:625199994649:android:e505097af7905109ad5788',
    messagingSenderId: '625199994649',
    projectId: 'medix-sds',
    storageBucket: 'medix-sds.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDBErgGabbc-zClIxKsWecVbEMqhjT2WwE',
    appId: '1:625199994649:ios:84f01aa73c5c6babad5788',
    messagingSenderId: '625199994649',
    projectId: 'medix-sds',
    storageBucket: 'medix-sds.appspot.com',
    iosBundleId: 'com.sdssoum.medix',
  );
}
