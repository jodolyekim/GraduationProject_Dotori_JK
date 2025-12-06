// lib/services/quiz_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class QuizService {
  /// 문제 1개 받기
  static Future<Map<String, dynamic>?> next({
    String? type,
    String? difficulty, // 'EASY' | 'MEDIUM' | 'HARD'
    String locale = 'ko',
  }) async {
    final http.Response res = await ApiClient.get(
      '/api/quizzes/next',
      query: {
        if (type != null) 'type': type,
        if (difficulty != null) 'difficulty': difficulty,
        'locale': locale,
      },
      //  로그인 토큰을 같이 보내서 request.user를 인식하게
      auth: true,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    // 204(no content) 등은 null
    return null;
  }

  /// 정답 제출
  static Future<Map<String, dynamic>> submit({
    required int quizId,
    required int optionId,
    int timeMs = 0,
  }) async {
    final http.Response res = await ApiClient.postJson(
      '/api/quizzes/submit',
      {
        'quiz_id': quizId,
        'option_id': optionId,
        'time_ms': timeMs,
      },
      //  여기서도 반드시 auth: true
      auth: true,
    );

    if (res.statusCode != 200) {
      throw Exception('submit failed: ${res.statusCode} ${res.body}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
