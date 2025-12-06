import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class AnalyticsApiService {
  static final AnalyticsApiService instance = AnalyticsApiService._internal();
  AnalyticsApiService._internal();

  // 사용자 분석
  Future<Map<String, dynamic>> getUserAnalytics() async {
    final res = await ApiClient.get(
      '/api/memberships/analytics/user/',
      auth: true,
    );

    if (res.statusCode != 200) {
      throw Exception("사용자 분석 조회 실패: ${res.body}");
    }

    return jsonDecode(res.body);
  }

  // 관리자 분석
  Future<Map<String, dynamic>> getAdminAnalytics() async {
    final res = await ApiClient.get(
      '/api/memberships/analytics/admin/',
      auth: true,
    );

    if (res.statusCode != 200) {
      throw Exception("관리자 분석 조회 실패: ${res.body}");
    }

    return jsonDecode(res.body);
  }
}
