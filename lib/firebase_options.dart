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
    apiKey: 'AIzaSyCuu8GW7qm8yQu7ZAsr5xMZv39Wemt8j2s',
    appId: '1:803698196068:web:aa4865f90f7f2627342971',
    messagingSenderId: '803698196068',
    projectId: 'quickbites-3ab35',
    authDomain: 'quickbites-3ab35.firebaseapp.com',
    storageBucket: 'quickbites-3ab35.firebasestorage.app',
    measurementId: 'G-WCCRHKKJC2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdr7QucQ9I0lixaNIzKI0QyURkhTtL9yk',
    appId: '1:803698196068:android:ba4756e5f203a6ac342971',
    messagingSenderId: '803698196068',
    projectId: 'quickbites-3ab35',
    storageBucket: 'quickbites-3ab35.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNoAIzB2QPAxn8PbdLX4MTFI5yplWvPIc',
    appId: '1:803698196068:ios:148f213573498592342971',
    messagingSenderId: '803698196068',
    projectId: 'quickbites-3ab35',
    storageBucket: 'quickbites-3ab35.firebasestorage.app',
    iosBundleId: 'com.example.foodOrderingApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCNoAIzB2QPAxn8PbdLX4MTFI5yplWvPIc',
    appId: '1:803698196068:ios:148f213573498592342971',
    messagingSenderId: '803698196068',
    projectId: 'quickbites-3ab35',
    storageBucket: 'quickbites-3ab35.firebasestorage.app',
    iosBundleId: 'com.example.foodOrderingApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCuu8GW7qm8yQu7ZAsr5xMZv39Wemt8j2s',
    appId: '1:803698196068:web:1c4022c062e5675c342971',
    messagingSenderId: '803698196068',
    projectId: 'quickbites-3ab35',
    authDomain: 'quickbites-3ab35.firebaseapp.com',
    storageBucket: 'quickbites-3ab35.firebasestorage.app',
    measurementId: 'G-TJ8XW8FY86',
  );

}