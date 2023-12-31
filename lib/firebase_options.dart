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
    apiKey: 'AIzaSyA7tCjquIecgHxSsRTU4HZilY-Sg3-EYc4',
    appId: '1:20979066646:web:0420c7a388a3058c2fd237',
    messagingSenderId: '20979066646',
    projectId: 'fadduapp',
    authDomain: 'fadduapp.firebaseapp.com',
    storageBucket: 'fadduapp.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA-sFQEgCz40sSzBAOrzgxcXK5x415eCvo',
    appId: '1:20979066646:android:98df5dc416d6fa202fd237',
    messagingSenderId: '20979066646',
    projectId: 'fadduapp',
    storageBucket: 'fadduapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDj15v4vHCls2Jg_N4xOzXzPqG0SS6XRD4',
    appId: '1:20979066646:ios:637915965e19fcb42fd237',
    messagingSenderId: '20979066646',
    projectId: 'fadduapp',
    storageBucket: 'fadduapp.appspot.com',
    iosBundleId: 'com.example.fadduapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDj15v4vHCls2Jg_N4xOzXzPqG0SS6XRD4',
    appId: '1:20979066646:ios:531c888048205e8f2fd237',
    messagingSenderId: '20979066646',
    projectId: 'fadduapp',
    storageBucket: 'fadduapp.appspot.com',
    iosBundleId: 'com.example.fadduapp.RunnerTests',
  );
}
