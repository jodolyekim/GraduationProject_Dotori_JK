import 'dart:convert';
import 'dart:io' show File;
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'api_client.dart';

class DetectorService {
  // ─ 공통: AI 디텍터 사용량 1회 차감 ─
  static Future<void> _consumeDetector() async {
    final res = await ApiClient.postJson(
      '/api/memberships/consume/DETECTOR/',
      {}, // 바디 없음
      auth: true,
    );

    // 200대가 아니면 = 한도 초과 or 기타 오류
    if (res.statusCode < 200 || res.statusCode >= 300) {
      // 백엔드에서 내려주는 메시지를 그대로 보여주고 싶으면 이렇게:
      try {
        final body = jsonDecode(res.body);
        final detail = body is Map && body['detail'] != null
            ? body['detail'].toString()
            : res.body;
        throw Exception('AI 디텍터 사용 불가: $detail');
      } catch (_) {
        throw Exception(
            'AI 디텍터 사용 불가: ${res.statusCode} ${res.body}');
      }
    }

    // 200이면 ok: true/false 상관 없이 일단 1회 소모 성공이라고 가정
    // (FeatureConsumeView는 한도 초과 시 400을 던지므로 여기선 정상 케이스뿐)
  }

  // ─ 텍스트 ─
  static Future<Map<String, dynamic>> detectText(String text) async {
    //  먼저 멤버십 사용량 1회 소모
    await _consumeDetector();

    final res = await ApiClient.postJson(
      '/api/detector/text/',
      {'text': text},
      auth: true,
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('detectText failed: ${res.statusCode} ${res.body}');
    }
    return Map<String, dynamic>.from(jsonDecode(res.body));
  }

  // ─ 이미지 ─
  static Future<Map<String, dynamic>> detectImageFile(File file) async {
    final bytes = await file.readAsBytes();
    return detectImageBytes(bytes, _basename(file.path));
  }

  static Future<Map<String, dynamic>> detectImageBytes(
    Uint8List bytes,
    String filename,
  ) async {
    //  사용량 차감
    await _consumeDetector();

    final streamed = await ApiClient.postMultipart(
      '/api/detector/image/',
      auth: true,
      files: [ApiMultipartFile('file', bytes, filename)],
    );
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('detectImage failed: ${res.statusCode} ${res.body}');
    }
    return Map<String, dynamic>.from(jsonDecode(res.body));
  }

  // ─ 비디오 ─
  static Future<Map<String, dynamic>> detectVideoFile(File file) async {
    final bytes = await file.readAsBytes();
    return detectVideoBytes(bytes, _basename(file.path));
  }

  static Future<Map<String, dynamic>> detectVideoBytes(
    Uint8List bytes,
    String filename,
  ) async {
    //  사용량 차감
    await _consumeDetector();

    final streamed = await ApiClient.postMultipart(
      '/api/detector/video/',
      auth: true,
      files: [ApiMultipartFile('file', bytes, filename)],
    );
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('detectVideo failed: ${res.statusCode} ${res.body}');
    }
    return Map<String, dynamic>.from(jsonDecode(res.body));
  }

  // ─ 오디오 ─
  static Future<Map<String, dynamic>> detectAudioFile(File file) async {
    final bytes = await file.readAsBytes();
    return detectAudioBytes(bytes, _basename(file.path));
  }

  static Future<Map<String, dynamic>> detectAudioBytes(
    Uint8List bytes,
    String filename,
  ) async {
    //  사용량 차감
    await _consumeDetector();

    final streamed = await ApiClient.postMultipart(
      '/api/detector/audio/',
      auth: true,
      files: [ApiMultipartFile('file', bytes, filename)],
    );
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('detectAudio failed: ${res.statusCode} ${res.body}');
    }
    return Map<String, dynamic>.from(jsonDecode(res.body));
  }

  // ─ (구버전 호환용) 이미지/비디오 자동 분기 ─
  @Deprecated('이미지는 detectImage*, 비디오는 detectVideo* 를 직접 사용하세요.')
  static Future<Map<String, dynamic>> detectImageOrVideoFile(File file) async {
    final bytes = await file.readAsBytes();
    final name = _basename(file.path);
    return detectImageOrVideoBytes(bytes, name);
  }

  @Deprecated('이미지는 detectImage*, 비디오는 detectVideo* 를 직접 사용하세요.')
  static Future<Map<String, dynamic>> detectImageOrVideoBytes(
    Uint8List bytes,
    String filename,
  ) async {
    final ext = _ext(filename);
    final isImage = const {
      'jpg',
      'jpeg',
      'png',
      'webp',
      'bmp',
      'gif',
    }.contains(ext);
    final isVideo = const {
      'mp4',
      'mov',
      'mkv',
      'webm',
    }.contains(ext);

    if (isImage) {
      return detectImageBytes(bytes, filename);
    } else if (isVideo) {
      return detectVideoBytes(bytes, filename);
    } else {
      // 모르면 일단 이미지로 시도 (이전 코드 호환)
      return detectImageBytes(bytes, filename);
    }
  }

  // ─ 유틸 ─
  static String _basename(String path) {
    final i = path.replaceAll('\\', '/').lastIndexOf('/');
    return i >= 0 ? path.substring(i + 1) : path;
  }

  static String _ext(String filename) {
    final dot = filename.lastIndexOf('.');
    return (dot >= 0 ? filename.substring(dot + 1) : '').toLowerCase();
  }
}
