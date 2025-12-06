<<<<<<< HEAD

import 'dart:convert';
import 'package:dotori_client/services/api_client.dart';

class SummaryService {
  Future<List<Map<String, dynamic>>> listMySummaries() async {
    final res = await ApiClient.get('/api/summaries/', auth: true);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      }
    }
    return [];
  }

  Future<bool> createSummary(String text) async {
    final res = await ApiClient.postJson('/api/summaries/create/', {
      'source_text': text,
    }, auth: true);
    return res.statusCode == 201;
=======
// lib/services/summary_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dotori_client/services/api_client.dart';

class SummaryResult {
  final String summary;
  final List<Map<String, dynamic>> vocabulary;
  final List<dynamic> actions;
  final Map<String, dynamic> meta;

  SummaryResult({
    required this.summary,
    required this.vocabulary,
    required this.actions,
    required this.meta,
  });

  factory SummaryResult.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> _parseVocab(dynamic raw) {
      if (raw is List) {
        return raw.whereType<Map<String, dynamic>>().toList();
      }
      return <Map<String, dynamic>>[];
    }

    final vocabExplained = _parseVocab(json["vocabulary_explained"]);
    final vocab = vocabExplained.isNotEmpty
        ? vocabExplained
        : _parseVocab(json["vocabulary"]);

    return SummaryResult(
      summary: json["summary"]?.toString() ?? "",
      vocabulary: vocab,
      actions:
          (json["actions"] is List) ? json["actions"] as List : <dynamic>[],
      meta: (json["meta"] is Map)
          ? (json["meta"] as Map).cast<String, dynamic>()
          : <String, dynamic>{},
    );
  }
}

class WordExplainResult {
  final String word;
  final String meaning;
  final String? example;

  WordExplainResult({
    required this.word,
    required this.meaning,
    this.example,
  });

  factory WordExplainResult.fromJson(Map<String, dynamic> json) {
    return WordExplainResult(
      word: json["word"]?.toString() ?? "",
      meaning:
          json["easy_meaning"]?.toString() ?? json["meaning"]?.toString() ?? "",
      example: json["example"]?.toString(),
    );
  }
}

class SummaryService {
  // ============================================================
  // 🎯 텍스트 요약
  // ============================================================
  Future<SummaryResult> summarizeFromText(
    String text, {
    String difficulty = 'ADULT',
    String? docHint,
  }) async {
    final body = <String, dynamic>{
      'text': text,
      'difficulty': difficulty,
    };

    if (docHint != null && docHint.trim().isNotEmpty) {
      body['doc_hint'] = docHint.trim();
    }

    final res = await ApiClient.postJson(
      '/api/summaries/summarize/',
      body,
      auth: false,
    );

    if (res.statusCode != 200) {
      throw Exception("요약 실패: ${res.statusCode} ${res.body}");
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return SummaryResult.fromJson(data);
  }

  // ============================================================
  // 🖼 이미지 → OCR → 요약 (Web 완전 지원)
  // ============================================================
  Future<SummaryResult> summarizeFromImageBytes(
    Uint8List bytes, {
    String difficulty = 'ADULT',
    String? docHint,
  }) async {
    // base64 + data URI
    final b64 = base64Encode(bytes);
    final dataUri = "data:image/jpeg;base64,$b64";

    final body = <String, dynamic>{
      "difficulty": difficulty,
      "image_base64": dataUri,
    };

    if (docHint != null && docHint.trim().isNotEmpty) {
      body["doc_hint"] = docHint.trim();
    }

    final res = await ApiClient.postJson(
      '/api/summaries/summarize/',
      body,
      auth: false,
    );

    if (res.statusCode != 200) {
      throw Exception("요약 실패: ${res.statusCode} ${res.body}");
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return SummaryResult.fromJson(data);
  }

  // ============================================================
  // 📘 단일 단어 설명
  // ============================================================
  Future<WordExplainResult> explainWord({
    required String word,
    String difficulty = 'ADULT',
  }) async {
    final res = await ApiClient.postJson(
      '/api/summaries/word-explain/',
      {
        'word': word,
        'difficulty': difficulty,
      },
      auth: false,
    );

    if (res.statusCode != 200) {
      throw Exception("단어 설명 실패: ${res.statusCode} ${res.body}");
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return WordExplainResult.fromJson(data);
>>>>>>> clean-summary-2_flutter
  }
}
