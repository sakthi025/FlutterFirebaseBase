import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Configure your real credentials via FlutterFire CLI:
/// `flutterfire configure --project=<YOUR_FIREBASE_PROJECT_ID>`
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyWebForFlutterFirebaseBase',
    appId: '1:100000000000:web:abcdef1234567890',
    messagingSenderId: '100000000000',
    projectId: 'flutter-firebase-base-demo',
    authDomain: 'flutter-firebase-base-demo.firebaseapp.com',
    storageBucket: 'flutter-firebase-base-demo.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyAndroidForFlutterFirebaseBase',
    appId: '1:100000000000:android:abcdef1234567890',
    messagingSenderId: '100000000000',
    projectId: 'flutter-firebase-base-demo',
    storageBucket: 'flutter-firebase-base-demo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyIosForFlutterFirebaseBase',
    appId: '1:100000000000:ios:abcdef1234567890',
    messagingSenderId: '100000000000',
    projectId: 'flutter-firebase-base-demo',
    storageBucket: 'flutter-firebase-base-demo.appspot.com',
    iosBundleId: 'com.example.flutterFirebaseBase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyMacosForFlutterFirebaseBase',
    appId: '1:100000000000:ios:abcdef1234567890',
    messagingSenderId: '100000000000',
    projectId: 'flutter-firebase-base-demo',
    storageBucket: 'flutter-firebase-base-demo.appspot.com',
    iosBundleId: 'com.example.flutterFirebaseBase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyWindowsForFlutterFirebaseBase',
    appId: '1:100000000000:web:abcdef1234567890',
    messagingSenderId: '100000000000',
    projectId: 'flutter-firebase-base-demo',
    authDomain: 'flutter-firebase-base-demo.firebaseapp.com',
    storageBucket: 'flutter-firebase-base-demo.appspot.com',
  );
}
