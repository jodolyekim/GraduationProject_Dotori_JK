// lib/services/roleplay_service.dart

import 'dart:convert';

import 'package:dotori_client/services/api_client.dart';

class RoleplayScenario {
  final String code;
  final String title;
  final String description;
  final String goal;
  final List<String> tags;

  RoleplayScenario({
    required this.code,
    required this.title,
    required this.description,
    required this.goal,
    required this.tags,
  });

  factory RoleplayScenario.fromJson(Map<String, dynamic> json) {
    return RoleplayScenario(
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      goal: json['goal'] as String,
      tags: (json['tags'] as List).map((e) => e.toString()).toList(),
    );
  }
}

class RoleplayChatResponse {
  final String scenarioCode;
  final String assistantReply;
  final String coachComment;
  final String suggestedNextAction;

  RoleplayChatResponse({
    required this.scenarioCode,
    required this.assistantReply,
    required this.coachComment,
    required this.suggestedNextAction,
  });

  factory RoleplayChatResponse.fromJson(Map<String, dynamic> json) {
    return RoleplayChatResponse(
      scenarioCode: json['scenario_code'] as String,
      assistantReply: json['assistant_reply'] as String,
      coachComment: json['coach_comment'] as String,
      suggestedNextAction: json['suggested_next_action'] as String,
    );
  }
}

class RoleplayService {
  /// 기존 코드와 시그니처 맞추기용 (실제로는 ApiClient 를 사용하므로 baseUrl은 쓰지 않음)
  final String? baseUrl;

  RoleplayService({this.baseUrl});

  /// 시나리오 목록 조회
  ///
  /// [token] 파라미터는 더 이상 사용하지 않지만,
  /// 기존 호출부와의 호환을 위해 유지한다.
  Future<List<RoleplayScenario>> fetchScenarios(String token) async {
    final res = await ApiClient.get(
      '/api/roleplay/scenarios/',
      auth: true, //  JWT 토큰 자동 첨부
    );

    if (res.statusCode != 200) {
      throw Exception(
        '시나리오 목록 불러오기 실패: ${res.statusCode} ${res.body}',
      );
    }

    final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
    return data
        .map((e) => RoleplayScenario.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 역할극 대화 요청
  Future<RoleplayChatResponse> sendChat({
    required String token, // 실제로는 사용 안 함 (호환용)
    required String scenarioCode,
    required List<Map<String, String>> messages,
  }) async {
    final res = await ApiClient.postJson(
      '/api/roleplay/chat/',
      {
        'scenario_code': scenarioCode,
        'messages': messages,
      },
      auth: true, //  여기서도 항상 인증 붙여서 보냄
    );

    if (res.statusCode != 200) {
      throw Exception(
        '역할극 대화 요청 실패: ${res.statusCode} ${res.body}',
      );
    }

    final Map<String, dynamic> data =
        jsonDecode(res.body) as Map<String, dynamic>;
    return RoleplayChatResponse.fromJson(data);
  }
}
