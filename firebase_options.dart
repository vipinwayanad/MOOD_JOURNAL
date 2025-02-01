// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAkB2CTX2-BJf91BGTF_el24keAklaIR_Y',
    appId: '1:803397693598:web:c204fc2537907e4cb4cb8f',
    messagingSenderId: '803397693598',
    projectId: 'mood-journal-bac33',
    authDomain: 'mood-journal-bac33.firebaseapp.com',
    storageBucket: 'mood-journal-bac33.firebasestorage.app',
    measurementId: 'G-483EQFJWEW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCl9UbP7kgOum44Szz9H5ZeVmLHk3edkws',
    appId: '1:803397693598:android:afa826ec3ad11793b4cb8f',
    messagingSenderId: '803397693598',
    projectId: 'mood-journal-bac33',
    storageBucket: 'mood-journal-bac33.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD77mcL-R08v0P31UYG5Fx0Q7n6AGfzcCQ',
    appId: '1:803397693598:ios:55262ccc1f47b7f3b4cb8f',
    messagingSenderId: '803397693598',
    projectId: 'mood-journal-bac33',
    storageBucket: 'mood-journal-bac33.firebasestorage.app',
    iosBundleId: 'com.example.flutterProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD77mcL-R08v0P31UYG5Fx0Q7n6AGfzcCQ',
    appId: '1:803397693598:ios:55262ccc1f47b7f3b4cb8f',
    messagingSenderId: '803397693598',
    projectId: 'mood-journal-bac33',
    storageBucket: 'mood-journal-bac33.firebasestorage.app',
    iosBundleId: 'com.example.flutterProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAkB2CTX2-BJf91BGTF_el24keAklaIR_Y',
    appId: '1:803397693598:web:be1dac36f6b307c6b4cb8f',
    messagingSenderId: '803397693598',
    projectId: 'mood-journal-bac33',
    authDomain: 'mood-journal-bac33.firebaseapp.com',
    storageBucket: 'mood-journal-bac33.firebasestorage.app',
    measurementId: 'G-B593BR7FKQ',
  );
}
