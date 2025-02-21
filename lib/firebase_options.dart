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
    apiKey: 'AIzaSyC1HkpwrxUuvsv-RTy0KyoO1S2rcIsOPHo',
    appId: '1:220302249046:web:542a777e52d8bfc6193ff7',
    messagingSenderId: '220302249046',
    projectId: 'conveyor-2929b',
    authDomain: 'conveyor-2929b.firebaseapp.com',
    databaseURL: 'https://conveyor-2929b-default-rtdb.firebaseio.com',
    storageBucket: 'conveyor-2929b.firebasestorage.app',
    measurementId: 'G-JR71TD5ZMR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFIFLXARRp-v3F5udxX3XIsENQfaAElA0',
    appId: '1:220302249046:android:2eb36bd08b32f880193ff7',
    messagingSenderId: '220302249046',
    projectId: 'conveyor-2929b',
    databaseURL: 'https://conveyor-2929b-default-rtdb.firebaseio.com',
    storageBucket: 'conveyor-2929b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_R10Agyg_571AHiR-OS3b4Ijsoef45JM',
    appId: '1:220302249046:ios:691d308b543ee8e5193ff7',
    messagingSenderId: '220302249046',
    projectId: 'conveyor-2929b',
    databaseURL: 'https://conveyor-2929b-default-rtdb.firebaseio.com',
    storageBucket: 'conveyor-2929b.firebasestorage.app',
    iosBundleId: 'com.example.conveyorapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC_R10Agyg_571AHiR-OS3b4Ijsoef45JM',
    appId: '1:220302249046:ios:691d308b543ee8e5193ff7',
    messagingSenderId: '220302249046',
    projectId: 'conveyor-2929b',
    databaseURL: 'https://conveyor-2929b-default-rtdb.firebaseio.com',
    storageBucket: 'conveyor-2929b.firebasestorage.app',
    iosBundleId: 'com.example.conveyorapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC1HkpwrxUuvsv-RTy0KyoO1S2rcIsOPHo',
    appId: '1:220302249046:web:b0dd6e038a31f8a4193ff7',
    messagingSenderId: '220302249046',
    projectId: 'conveyor-2929b',
    authDomain: 'conveyor-2929b.firebaseapp.com',
    databaseURL: 'https://conveyor-2929b-default-rtdb.firebaseio.com',
    storageBucket: 'conveyor-2929b.firebasestorage.app',
    measurementId: 'G-BFLJKQQGDD',
  );
}
