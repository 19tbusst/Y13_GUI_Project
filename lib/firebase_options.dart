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
    apiKey: 'AIzaSyDKDKTv3056Zm930-F6JtfzQwYcPykliz8',
    appId: '1:553839103651:web:bb252cef6e4dfa911b3916',
    messagingSenderId: '553839103651',
    projectId: 'y13-gui-project',
    authDomain: 'y13-gui-project.firebaseapp.com',
    databaseURL: 'https://y13-gui-project-default-rtdb.firebaseio.com',
    storageBucket: 'y13-gui-project.appspot.com',
    measurementId: 'G-1C2K817Y97',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1aGIC-ekvA4AmWnQumFNZcyQmOZUQvso',
    appId: '1:553839103651:android:72fcfc167796ca981b3916',
    messagingSenderId: '553839103651',
    projectId: 'y13-gui-project',
    databaseURL: 'https://y13-gui-project-default-rtdb.firebaseio.com',
    storageBucket: 'y13-gui-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcxIRYDNpnMdMKhZ6GBoSsAMzGAT8GuUI',
    appId: '1:553839103651:ios:dfbf4c971f4be5151b3916',
    messagingSenderId: '553839103651',
    projectId: 'y13-gui-project',
    databaseURL: 'https://y13-gui-project-default-rtdb.firebaseio.com',
    storageBucket: 'y13-gui-project.appspot.com',
    iosClientId: '553839103651-s3kgo8d2vsgddqt3e48f3r1pmr5ld04e.apps.googleusercontent.com',
    iosBundleId: 'com.example.y13GuiProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBcxIRYDNpnMdMKhZ6GBoSsAMzGAT8GuUI',
    appId: '1:553839103651:ios:dfbf4c971f4be5151b3916',
    messagingSenderId: '553839103651',
    projectId: 'y13-gui-project',
    databaseURL: 'https://y13-gui-project-default-rtdb.firebaseio.com',
    storageBucket: 'y13-gui-project.appspot.com',
    iosClientId: '553839103651-s3kgo8d2vsgddqt3e48f3r1pmr5ld04e.apps.googleusercontent.com',
    iosBundleId: 'com.example.y13GuiProject',
  );
}
