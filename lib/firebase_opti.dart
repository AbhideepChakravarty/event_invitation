// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'dart:html' as html;
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
    const environment = String.fromEnvironment('env', defaultValue: 'dev');
    print("Environment = " + environment);
    if (kIsWeb) {
      if (environment == 'prod') {
        return webProd;
      }
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
    apiKey: 'AIzaSyDYsDj4Kal-j0_d1aLjwSpMWbwRe587ZUk',
    appId: '1:278098228747:web:8038461818a36458e4390e',
    messagingSenderId: '278098228747',
    projectId: 'weddingproject-175d4',
    authDomain: 'weddingproject-175d4.firebaseapp.com',
    storageBucket: 'weddingproject-175d4.appspot.com',
    measurementId: 'G-3GF1X0BFGR',
  );

  static const FirebaseOptions webProd = FirebaseOptions(
    apiKey: "AIzaSyCAzAvcPNinume4xZFe_y0eHPvF-c2HgpE",
    authDomain: "occur-prod.firebaseapp.com",
    projectId: "occur-prod",
    storageBucket: "occur-prod.appspot.com",
    messagingSenderId: "320096968809",
    appId: "1:320096968809:web:7163ab68b9fa7081b342f8",
    measurementId: "G-Q1BQ1L9NRR",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTBY6dntZuugEZCe-LYovG02kJHd7CkB8',
    appId: '1:278098228747:android:2945873242001fc1e4390e',
    messagingSenderId: '278098228747',
    projectId: 'weddingproject-175d4',
    storageBucket: 'weddingproject-175d4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbb0yDXifhylAOvEQU9wgGgJUxXZ3cjow',
    appId: '1:278098228747:ios:621c78afc46b78b6e4390e',
    messagingSenderId: '278098228747',
    projectId: 'weddingproject-175d4',
    storageBucket: 'weddingproject-175d4.appspot.com',
    iosClientId:
        '278098228747-354kkfudvse2838mv8472cl7g5aisthv.apps.googleusercontent.com',
    iosBundleId: 'com.example.eventInvitation',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbb0yDXifhylAOvEQU9wgGgJUxXZ3cjow',
    appId: '1:278098228747:ios:621c78afc46b78b6e4390e',
    messagingSenderId: '278098228747',
    projectId: 'weddingproject-175d4',
    storageBucket: 'weddingproject-175d4.appspot.com',
    iosClientId:
        '278098228747-354kkfudvse2838mv8472cl7g5aisthv.apps.googleusercontent.com',
    iosBundleId: 'com.example.eventInvitation',
  );
}