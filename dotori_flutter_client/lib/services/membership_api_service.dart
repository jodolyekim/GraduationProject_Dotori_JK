// lib/services/membership_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_client.dart';
import 'membership_service.dart';

class MembershipApiService {
  static final MembershipApiService _instance = MembershipApiService._internal();
  factory MembershipApiService() => _instance;
  MembershipApiService._internal();

  final _local = MembershipService.instance;

  // ----------------------------------------
  //  요금제 목록
  // ----------------------------------------
  Future<List<dynamic>> getPlans() async {
    final res = await ApiClient.get(
      '/api/memberships/plans/',
      auth: true,
    );

    if (res.statusCode != 200) {
      throw Exception('요금제 목록 조회 실패 (${res.statusCode})');
    }

    final body = jsonDecode(res.body);
    if (body is List) return body;

    throw Exception('응답 포맷 오류: ${res.body}');
  }

  // ----------------------------------------
  //  내 멤버십 정보
  // ----------------------------------------
  Future<Map<String, dynamic>> getMyMembership() async {
    final res = await ApiClient.get(
      '/api/memberships/me/',
      auth: true,
    );

    if (res.statusCode != 200) {
      throw Exception('내 멤버십 조회 실패 (${res.statusCode})');
    }

    final body = jsonDecode(res.body);

    //  JSON 형태 확인용 print
    print("MY MEMBERSHIP RESPONSE = $body");

    if (body is! Map<String, dynamic>) {
      throw Exception('응답 포맷 오류: ${res.body}');
    }

    final plan = body['plan'] as Map<String, dynamic>?;
    final code = plan?['code'];
    final expires = body['expires_at'] as String?;

    if (code != null) {
      DateTime? expiresAt;
      if (expires != null && expires.isNotEmpty) {
        try {
          expiresAt = DateTime.parse(expires);
        } catch (_) {}
      }
      _local.applyBackendPlan(code, expiresAt: expiresAt);
    }

    return body;
  }

  // ----------------------------------------
  //  포인트 조회
  // ----------------------------------------
  Future<Map<String, dynamic>> getMyPoints() async {
    final res = await ApiClient.get(
      '/api/memberships/points/',
      auth: true,
    );

    if (res.statusCode != 200) {
      throw Exception('포인트 조회 실패 (${res.statusCode})');
    }

    final body = jsonDecode(res.body);
    if (body is Map<String, dynamic>) return body;

    throw Exception('응답 포맷 오류: ${res.body}');
  }

  // ----------------------------------------
  //  포인트 내역
  // ----------------------------------------
  Future<List<dynamic>> getPointHistory() async {
    final res = await ApiClient.get(
      '/api/memberships/points/history/',
      auth: true,
    );

    if (res.statusCode != 200) {
      throw Exception('내역 조회 실패 (${res.statusCode})');
    }

    final body = jsonDecode(res.body);
    if (body is List) return body;

    throw Exception('응답 오류: ${res.body}');
  }

  // ----------------------------------------
  //  요금제 구독
  // ----------------------------------------
  Future<Map<String, dynamic>> subscribe({
    required String planCode,
    String paymentMethod = "CARD",
    int pointToUse = 0,
  }) async {
    final res = await ApiClient.postJson(
      '/api/memberships/subscribe/',
      {
        "plan_code": planCode,
        "payment_method": paymentMethod,
        "point_to_use": pointToUse,
      },
      auth: true,
    );

    if (res.statusCode != 200) {
      throw Exception('멤버십 변경 실패 (${res.statusCode})\n${res.body}');
    }

    final body = jsonDecode(res.body);
    if (body is! Map<String, dynamic>) {
      throw Exception('응답 포맷 오류: ${res.body}');
    }

    final membership = body['membership'];
    final plan = membership?['plan'] as Map<String, dynamic>?;
    final code = plan?['code'];
    final expires = membership?['expires_at'] as String?;

    if (code != null) {
      DateTime? expiresAt;
      if (expires != null && expires.isNotEmpty) {
        try {
          expiresAt = DateTime.parse(expires);
        } catch (_) {}
      }
      _local.applyBackendPlan(code, expiresAt: expiresAt);
    }

    return body;
  }

  // ----------------------------------------
  //  기능 사용 차감
  // ----------------------------------------
  Future<Map<String, dynamic>> consumeFeature({
    required String featureType,
  }) async {
    final res = await ApiClient.postJson(
      '/api/memberships/consume/$featureType/',
      {},
      auth: true,
    );

    if (res.statusCode != 200) {
      throw Exception('기능 사용 실패 (${res.statusCode})\n${res.body}');
    }

    final body = jsonDecode(res.body);
    if (body is Map<String, dynamic>) return body;

    throw Exception('응답 오류: ${res.body}');
  }

  // ----------------------------------------
  //   사용량 통계 — 앱 전체에서 이 함수만 사용
  // ----------------------------------------
  Future<Map<String, dynamic>?> getOverview() async {
    final res = await ApiClient.get(
      '/api/memberships/stats/overview/',
      auth: true,
    );

    if (res.statusCode != 200) {
      throw Exception('사용량 통계 실패 (${res.statusCode})\n${res.body}');
    }

    final body = jsonDecode(res.body);

    //  JSON 형태 확인용 print
    print("OVERVIEW API RESPONSE = $body");

    if (body is Map<String, dynamic>) return body;

    throw Exception('응답 오류: ${res.body}');
  }
}
