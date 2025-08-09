import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

// 임시 스텁: 실제 Firebase 프로젝트 연결 후 flutterfire configure로 대체하세요.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          '지원되지 않는 플랫폼입니다. Firebase 설정 후 다시 시도하세요.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'placeholder',
    appId: '1:000000000000:web:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'placeholder-project',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'placeholder',
    appId: '1:000000000000:android:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'placeholder-project',
  );
}


