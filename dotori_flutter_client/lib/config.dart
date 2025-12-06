<<<<<<< HEAD
import 'dart:io';
import 'package:flutter/foundation.dart';

class Config {
  /// Base URL 자동 감지:
  /// - Web or Desktop → http://127.0.0.1:8000
  /// - Android Emulator → http://10.0.2.2:8000
  /// - Physical Device (same Wi-Fi) → http://<PC IP>:8000
  static String get baseUrl {
    // 웹(Chrome 등)
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    // 모바일 플랫폼만 검사 가능
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }
    if (Platform.isIOS) {
      // iOS 시뮬레이터에서는 localhost로 접근 가능
      return 'http://127.0.0.1:8000';
    }

    // 데스크톱 (Windows/macOS/Linux)
    return 'http://127.0.0.1:8000';
  }
=======
// lib/config.dart

class Config {
  ///  절대 실패하지 않는 고정 서버 주소
  /// 배포 버전은 어떤 플랫폼(android/iOS/web)이든
  /// 반드시 AWS EC2로 요청을 보내야 한다.
  ///
  /// ⚠ HTTPS 도입 시 아래 주소만 수정하면 전 앱이 자동 변경됨.
  static const String baseUrl = 'http://54.180.149.45:8000';
>>>>>>> clean-summary-2_flutter
}
