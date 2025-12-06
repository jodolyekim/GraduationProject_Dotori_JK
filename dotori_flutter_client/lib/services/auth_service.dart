import 'dart:convert';
<<<<<<< HEAD
=======
import 'dart:typed_data';

import 'package:http/http.dart' as http;
>>>>>>> clean-summary-2_flutter
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotori_client/services/api_client.dart';

class AuthService {
  /// 회원가입 (이름/전화/인증토큰 포함)
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String name,
    required String phone,
    required String phoneVerifiedToken,
  }) async {
    final res = await ApiClient.postJson('/api/auth/register/', {
      'username': username,
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'phone_verified_token': phoneVerifiedToken,
    });
    return res.statusCode == 201;
  }

  /// 아이디 중복확인
  Future<bool> checkUsernameAvailable(String username) async {
    final u = username.trim();
    if (u.isEmpty) return false;
    final res = await ApiClient.get('/api/auth/check-username/?username=$u');
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['available'] == true;
    }
    if (res.statusCode == 409) return false;
    throw Exception('아이디 중복확인 실패 (${res.statusCode})');
  }

<<<<<<< HEAD
  /// 휴대폰 인증번호 발송
  Future<int> sendPhoneCode(String phone) async {
    // 성공 시 재전송 쿨다운(초) 반환
    final res = await ApiClient.postJson('/api/auth/phone/send_code/', {
      'phone': phone,
    });
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['cooldown'] as num?)?.toInt() ?? 60;
    }
    if (res.statusCode == 429) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['cooldown'] as num?)?.toInt() ?? 60;
    }
    throw Exception('인증번호 전송 실패 (${res.statusCode})');
=======
  /// 휴대폰 인증번호 발송 (회원가입/비번 변경 공통)
  /// 반환값: 재전송 쿨다운(초)
  Future<int> sendPhoneCode(String phone) async {
    final trimmed = phone.trim();
    print('[AuthService] sendPhoneCode 요청 phone=$trimmed');

    final res = await ApiClient.postJson(
      '/api/auth/phone/send_code/',
      {
        'phone': trimmed,
      },
    );

    print('[AuthService] sendPhoneCode 응답 status=${res.statusCode}');
    print('[AuthService] sendPhoneCode body=${res.body}');

    if (res.statusCode == 200 || res.statusCode == 429) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final cooldown = (data['cooldown'] as num?)?.toInt() ?? 60;
      return cooldown;
    }

    // 200/429가 아니면 모두 에러로 처리
    throw Exception(
      '인증번호 전송 실패: ${res.statusCode} ${res.body}',
    );
>>>>>>> clean-summary-2_flutter
  }

  /// 휴대폰 인증번호 검증 → phone_verified_token 반환
  Future<String> verifyPhoneCode({
    required String phone,
    required String code,
  }) async {
<<<<<<< HEAD
    final res = await ApiClient.postJson('/api/auth/phone/verify_code/', {
      'phone': phone,
      'code': code,
    });
=======
    final res = await ApiClient.postJson(
      '/api/auth/phone/verify_code/',
      {
        'phone': phone,
        'code': code,
      },
    );
>>>>>>> clean-summary-2_flutter
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final token = data['phone_verified_token'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('인증 토큰 수신 실패');
      }
      return token;
    }
    final msg = res.body.isNotEmpty ? res.body : '휴대폰 인증 실패';
    throw Exception(msg);
  }

<<<<<<< HEAD
  /// 로그인 성공 시 access/refresh 저장
  Future<bool> login(String username, String password) async {
=======
  ///  이메일 인증번호 발송 (마이페이지 이메일 변경) — 인증 필요
  Future<void> sendEmailCode(String email) async {
    final res = await ApiClient.postJson(
      '/api/auth/email/send_code/',
      {
        'email': email,
      },
      auth: true, // 인증 필요
    );
    if (res.statusCode != 200 && res.statusCode != 429) {
      throw Exception('이메일 인증번호 전송 실패 (${res.statusCode})');
    }
  }

  ///  이메일 인증번호 검증 → email_verified_token 반환 — 인증 필요
  Future<String> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    final res = await ApiClient.postJson(
      '/api/auth/email/verify_code/',
      {
        'email': email,
        'code': code,
      },
      auth: true, // 인증 필요
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final token = data['email_verified_token'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('이메일 인증 토큰 수신 실패');
      }
      return token;
    }
    final msg = res.body.isNotEmpty ? res.body : '이메일 인증 실패';
    throw Exception(msg);
  }

  /// 이메일 변경 (마이페이지)
  Future<void> changeEmail({
    required String newEmail,
    required String emailVerifiedToken,
  }) async {
    final res = await ApiClient.postJson(
      '/api/auth/email/change/',
      {
        'new_email': newEmail,
        'email_verified_token': emailVerifiedToken,
      },
      auth: true,
    );
    if (res.statusCode != 200) {
      throw Exception('이메일 변경 실패 (${res.statusCode})');
    }
  }

  /// 비밀번호 변경 (마이페이지)
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirm,
    required String phoneVerifiedToken,
  }) async {
    final res = await ApiClient.postJson(
      '/api/auth/password/change/',
      {
        'old_password': oldPassword,
        'new_password': newPassword,
        'new_password_confirm': newPasswordConfirm,
        'phone_verified_token': phoneVerifiedToken,
      },
      auth: true,
    );
    if (res.statusCode != 200) {
      throw Exception('비밀번호 변경 실패 (${res.statusCode})');
    }
  }

  /// 프로필 사진 업로드
  Future<String> uploadProfilePhoto(Uint8List bytes) async {
    final streamed = await ApiClient.postMultipart(
      '/api/auth/profile/upload_photo/',
      files: [ApiMultipartFile('image', bytes, 'profile.jpg')],
      auth: true,
    );
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['profile_image'] as String?) ?? '';
    }
    throw Exception('프로필 사진 업로드 실패 (${res.statusCode})');
  }

  /// 로그인 성공 시 access/refresh 저장
  Future<bool> login(String username, String password) async {
    print('[AuthService] login 요청 username=$username');

>>>>>>> clean-summary-2_flutter
    final res = await ApiClient.postJson('/api/auth/token/', {
      'username': username,
      'password': password,
    });
<<<<<<< HEAD
=======

    print('[AuthService] login 응답 status=${res.statusCode}');
    print('[AuthService] login body=${res.body}');

>>>>>>> clean-summary-2_flutter
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final access = data['access'] as String?;
      final refresh = data['refresh'] as String?;
      if (access == null || refresh == null) return false;

      final sp = await SharedPreferences.getInstance();
      await sp.setString('access_token', access);
      await sp.setString('refresh_token', refresh);
      return true;
    }
    return false;
  }

  /// 앱 시작 시 자동로그인 시도
  Future<bool> autoLoginIfPossible() async {
    final sp = await SharedPreferences.getInstance();
    final auto = sp.getBool('auto_login') ?? false;
    final refresh = sp.getString('refresh_token') ?? '';
    if (!auto || refresh.isEmpty) return false;

    final res = await ApiClient.postJson('/api/auth/token/refresh/', {
      'refresh': refresh,
    });
<<<<<<< HEAD
=======

    print('[AuthService] autoLogin 응답 status=${res.statusCode}');
    print('[AuthService] autoLogin body=${res.body}');

>>>>>>> clean-summary-2_flutter
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final newAccess = data['access'] as String?;
      if (newAccess == null || newAccess.isEmpty) return false;
      await sp.setString('access_token', newAccess);
      return true;
    }
    return false;
  }

<<<<<<< HEAD
  Future<Map<String, dynamic>?> me() async {
    final res = await ApiClient.get('/api/auth/me/', auth: true);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
=======
  /// 현재 로그인 유저 정보
  Future<Map<String, dynamic>?> me() async {
    final res = await ApiClient.get('/api/auth/me/', auth: true);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body) as Map<String, dynamic>;

      //  터미널에 JSON 출력
      print('ME API RESPONSE = $json');

      return json;
>>>>>>> clean-summary-2_flutter
    }
    return null;
  }

  Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('access_token');
    await sp.remove('refresh_token');
  }

  Future<bool> isLoggedIn() async {
    final sp = await SharedPreferences.getInstance();
    return (sp.getString('access_token') ?? '').isNotEmpty;
  }
<<<<<<< HEAD
=======

  // ==== 마이페이지 프로필 ====

  /// 프로필 조회
  Future<Map<String, dynamic>> fetchProfile() async {
    final res = await ApiClient.get('/api/auth/profile/', auth: true);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('프로필 조회 실패 (${res.statusCode})');
  }

  /// 프로필 수정 (닉네임/전화번호)
  Future<Map<String, dynamic>> updateProfile({
    String? displayName,
    String? phone,
  }) async {
    final body = <String, dynamic>{};

    if (displayName != null) body['display_name'] = displayName;
    if (phone != null) body['phone'] = phone;

    final res = await ApiClient.patchJson(
      '/api/auth/profile/',
      body,
      auth: true,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('프로필 수정 실패 (${res.statusCode})');
  }
>>>>>>> clean-summary-2_flutter
}
