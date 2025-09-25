import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDeyPy6sZWeiDfsWfCRTT62xSOit4YcyMk',
    appId: '1:330662716424:web:your_web_app_id',
    messagingSenderId: '330662716424',
    projectId: 'flutter-app-ecom',
    authDomain: 'flutter-app-ecom.firebaseapp.com',
    storageBucket: 'flutter-app-ecom.firebasestorage.app',
    measurementId: 'G-MEASUREMENT_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDeyPy6sZWeiDfsWfCRTT62xSOit4YcyMk',
    appId: '1:330662716424:android:3c69d2d73c53e0f36dddbd',
    messagingSenderId: '330662716424',
    projectId: 'flutter-app-ecom',
    storageBucket: 'flutter-app-ecom.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDeyPy6sZWeiDfsWfCRTT62xSOit4YcyMk',
    appId: '1:330662716424:ios:your_ios_app_id',
    messagingSenderId: '330662716424',
    projectId: 'flutter-app-ecom',
    storageBucket: 'flutter-app-ecom.firebasestorage.app',
    iosBundleId: 'com.matlav.flutter_ecom',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDeyPy6sZWeiDfsWfCRTT62xSOit4YcyMk',
    appId: '1:330662716424:macos:your_macos_app_id',
    messagingSenderId: '330662716424',
    projectId: 'flutter-app-ecom',
    storageBucket: 'flutter-app-ecom.firebasestorage.app',
    iosBundleId: 'com.matlav.flutter_ecom',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDeyPy6sZWeiDfsWfCRTT62xSOit4YcyMk',
    appId: '1:330662716424:windows:your_windows_app_id',
    messagingSenderId: '330662716424',
    projectId: 'flutter-app-ecom',
    authDomain: 'flutter-app-ecom.firebaseapp.com',
    storageBucket: 'flutter-app-ecom.firebasestorage.app',
    measurementId: 'G-MEASUREMENT_ID',
  );
}
