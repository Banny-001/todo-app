// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

    

// / Default [FirebaseOptions] for use with your Firebase apps.
// /
// / Example:
// / ```dart
// / import 'firebase_options.dart';
// / // ...
// / await Firebase.initializeApp(
// /   options: DefaultFirebaseOptions.currentPlatform,
// / );
// / ```
// / 
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
    apiKey: 'AIzaSyA7wYv3llE58N_KReOEebPFQQIVAH0VJiE',
    appId: '1:754998609451:web:80861ac8f52f3b020f8c6e',
    messagingSenderId: '754998609451',
    projectId: 'cookhub-d3a46',
    authDomain: 'cookhub-d3a46.firebaseapp.com',
    storageBucket: 'cookhub-d3a46.firebasestorage.app',
    measurementId: 'G-R8PHHF9QZT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCoIeYfaCXKIRieTixi4QjRy9f3ikdZ-Zs',
    appId: '1:754998609451:android:3af1d04e6889d8250f8c6e',
    messagingSenderId: '754998609451',
    projectId: 'cookhub-d3a46',
    storageBucket: 'cookhub-d3a46.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9R2unnmvUAgrJ3zqi7PNHDX4Aj_WS2Rw',
    appId: '1:754998609451:ios:7dd665fcb9ec9eb20f8c6e',
    messagingSenderId: '754998609451',
    projectId: 'cookhub-d3a46',
    storageBucket: 'cookhub-d3a46.firebasestorage.app',
    iosBundleId: 'com.example.cookhub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA9R2unnmvUAgrJ3zqi7PNHDX4Aj_WS2Rw',
    appId: '1:754998609451:ios:7dd665fcb9ec9eb20f8c6e',
    messagingSenderId: '754998609451',
    projectId: 'cookhub-d3a46',
    storageBucket: 'cookhub-d3a46.firebasestorage.app',
    iosBundleId: 'com.example.cookhub',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA7wYv3llE58N_KReOEebPFQQIVAH0VJiE',
    appId: '1:754998609451:web:fa095ae5fe2de7f70f8c6e',
    messagingSenderId: '754998609451',
    projectId: 'cookhub-d3a46',
    authDomain: 'cookhub-d3a46.firebaseapp.com',
    storageBucket: 'cookhub-d3a46.firebasestorage.app',
    measurementId: 'G-CRYTMK4DHR',
  );
}
