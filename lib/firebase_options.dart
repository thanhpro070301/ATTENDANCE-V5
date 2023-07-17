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
    apiKey: 'AIzaSyCtHkPi98YQgFlV7DqFPnDNm1-uL557ZpU',
    appId: '1:867612230220:web:9bae850dda20c1ee5b2ae9',
    messagingSenderId: '867612230220',
    projectId: 'attendance-v7',
    authDomain: 'attendance-v7.firebaseapp.com',
    storageBucket: 'attendance-v7.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCaGifT7PUDXpxtuxeVC9gAB_0avPza6So',
    appId: '1:867612230220:android:8e808fdc81cc40f85b2ae9',
    messagingSenderId: '867612230220',
    projectId: 'attendance-v7',
    storageBucket: 'attendance-v7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCXs0DOizk_55d8-aLA1s3lyieeQOEFsQ',
    appId: '1:867612230220:ios:b3d0e8d67f6533cb5b2ae9',
    messagingSenderId: '867612230220',
    projectId: 'attendance-v7',
    storageBucket: 'attendance-v7.appspot.com',
    iosClientId: '867612230220-1joau44guvm9a0vh85b3epr1a9mfpjb4.apps.googleusercontent.com',
    iosBundleId: 'com.example.attendance',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCXs0DOizk_55d8-aLA1s3lyieeQOEFsQ',
    appId: '1:867612230220:ios:5b48c5db64279f2d5b2ae9',
    messagingSenderId: '867612230220',
    projectId: 'attendance-v7',
    storageBucket: 'attendance-v7.appspot.com',
    iosClientId: '867612230220-jq797ihil8eg0stfpji71agek6t0qdnb.apps.googleusercontent.com',
    iosBundleId: 'com.example.attendance.RunnerTests',
  );
}
