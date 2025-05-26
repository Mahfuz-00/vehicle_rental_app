import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not supported for this application');
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.fuchsia:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for ${defaultTargetPlatform.name}',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAs7z73ai_Ry-pgfaY-riMOJTnoxDd5qIk',
    appId: '1:113578205977:android:db7a072132ccfb318f9b88',
    messagingSenderId: '113578205977',
    projectId: 'vehicle-rental-app-675fb',
    storageBucket: 'vehicle-rental-app-675fb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY', // Update from GoogleService-Info.plist
    appId: 'YOUR_IOS_APP_ID', // Update from GoogleService-Info.plist
    messagingSenderId: '113578205977',
    projectId: 'vehicle-rental-app-675fb',
    storageBucket: 'vehicle-rental-app-675fb.firebasestorage.app',
    iosBundleId: 'com.mahfuz.carTripApp', // Update from GoogleService-Info.plist
  );
}