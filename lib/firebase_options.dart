import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Connected Firebase Project: antigrav-proj-efbaa
/// To regenerate fresh platform keys directly from Google Cloud:
/// `flutterfire configure --project=antigrav-proj-efbaa`
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
    projectId: 'antigrav-proj-efbaa',
    authDomain: 'antigrav-proj-efbaa.firebaseapp.com',
    storageBucket: 'antigrav-proj-efbaa.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyAndroidForFlutterFirebaseBase',
    appId: '1:100000000000:android:abcdef1234567890',
    messagingSenderId: '100000000000',
    projectId: 'antigrav-proj-efbaa',
    storageBucket: 'antigrav-proj-efbaa.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyIosForFlutterFirebaseBase',
    appId: '1:100000000000:ios:abcdef1234567890',
    messagingSenderId: '100000000000',
    projectId: 'antigrav-proj-efbaa',
    storageBucket: 'antigrav-proj-efbaa.firebasestorage.app',
    iosBundleId: 'com.example.flutterFirebaseBase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyMacosForFlutterFirebaseBase',
    appId: '1:100000000000:ios:abcdef1234567890',
    messagingSenderId: '100000000000',
    projectId: 'antigrav-proj-efbaa',
    storageBucket: 'antigrav-proj-efbaa.firebasestorage.app',
    iosBundleId: 'com.example.flutterFirebaseBase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDemoKeyWindowsForFlutterFirebaseBase',
    appId: '1:100000000000:web:abcdef1234567890',
    messagingSenderId: '100000000000',
    projectId: 'antigrav-proj-efbaa',
    authDomain: 'antigrav-proj-efbaa.firebaseapp.com',
    storageBucket: 'antigrav-proj-efbaa.firebasestorage.app',
  );
}
