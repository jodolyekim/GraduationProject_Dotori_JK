<<<<<<< HEAD
=======
// lib/services/api_client.dart
>>>>>>> clean-summary-2_flutter
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotori_client/config.dart';

/// 공통 HTTP 클라이언트
/// - Authorization: Bearer <access>
<<<<<<< HEAD
/// - 401 이면 refresh 토큰으로 1회 재발급 후 재시도
class ApiClient {
  static Uri _u(String path) => Uri.parse('${Config.baseUrl}$path');

  /// JSON POST (auth=true면 토큰 첨부, 401 시 자동 리프레시 후 1회 재시도)
=======
/// - 401이면 refresh 토큰으로 1회 갱신 후 재시도
class ApiClient {
  static Uri _u(String path, [Map<String, dynamic>? query]) {
    final uri = Uri.parse('${Config.baseUrl}$path');
    if (query == null || query.isEmpty) return uri;

    final qp = <String, String>{};
    query.forEach((k, v) {
      if (v != null) qp[k] = v.toString();
    });
    return uri.replace(queryParameters: qp);
  }

  /// JSON POST
>>>>>>> clean-summary-2_flutter
  static Future<http.Response> postJson(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    return _requestWithRetry(
<<<<<<< HEAD
      () async => http.post(_u(path),
          headers: await _headers(auth: auth), body: jsonEncode(body)),
=======
      () async => http.post(
        _u(path),
        headers: await _headers(auth: auth),
        body: jsonEncode(body),
      ),
>>>>>>> clean-summary-2_flutter
      auth: auth,
    );
  }

<<<<<<< HEAD
  /// GET (auth=true면 토큰 첨부, 401 시 자동 리프레시 후 1회 재시도)
  static Future<http.Response> get(
    String path, {
    bool auth = false,
  }) async {
    return _requestWithRetry(
      () async => http.get(_u(path), headers: await _headers(auth: auth)),
=======
  /// JSON PATCH
  static Future<http.Response> patchJson(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    return _requestWithRetry(
      () async => http.patch(
        _u(path),
        headers: await _headers(auth: auth),
        body: jsonEncode(body),
      ),
>>>>>>> clean-summary-2_flutter
      auth: auth,
    );
  }

<<<<<<< HEAD
  /// 내부: 요청 실행 + 401 처리
=======
  /// GET (+ queryParameters 지원)
  static Future<http.Response> get(
    String path, {
    bool auth = false,
    Map<String, dynamic>? query,
  }) async {
    return _requestWithRetry(
      () async => http.get(
        _u(path, query),
        headers: await _headers(auth: auth),
      ),
      auth: auth,
    );
  }

  /// 멀티파트 POST (파일/이미지 업로드)
  /// - 401 발생 시 새 요청을 **재구성**하여 재시도 (스트림 재전송 이슈 방지)
  static Future<http.StreamedResponse> postMultipart(
    String path, {
    Map<String, String>? fields,
    List<ApiMultipartFile>? files,
    bool auth = false,
  }) async {
    Future<http.MultipartRequest> buildRequest() async {
      final req = http.MultipartRequest('POST', _u(path));
      req.fields.addAll(fields ?? {});

      // Authorization만 넣고, Content-Type은 MultipartRequest가 자동 설정
      if (auth) {
        final headers = await _headers(auth: true);
        final token = headers['Authorization'];
        if (token != null) {
          req.headers['Authorization'] = token;
        }
      }

      if (files != null) {
        for (final f in files) {
          req.files.add(
            http.MultipartFile.fromBytes(
              f.field,
              f.bytes,
              filename: f.filename,
            ),
          );
        }
      }
      return req;
    }

    // 1차 요청
    final firstReq = await buildRequest();
    http.StreamedResponse first = await firstReq.send();
    if (!auth || first.statusCode != 401) return first;

    // 토큰 갱신 후 2차 요청(새 요청으로 재구성)
    final refreshed = await _refreshAccessToken();
    if (!refreshed) return first;

    final secondReq = await buildRequest();
    return await secondReq.send();
  }

  // -- 내부 공통 --

>>>>>>> clean-summary-2_flutter
  static Future<http.Response> _requestWithRetry(
    Future<http.Response> Function() doRequest, {
    required bool auth,
  }) async {
    final first = await doRequest();
    if (!auth || first.statusCode != 401) return first;

<<<<<<< HEAD
    // 401 → refresh 시도
    final refreshed = await _refreshAccessToken();
    if (!refreshed) return first; // 갱신 실패 → 원 응답 반환

    // refresh 성공 → 다시 요청
    return await doRequest();
  }

  /// 헤더 생성 (auth=true면 access 토큰 포함)
  static Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (auth) {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString('access_token');
=======
    final refreshed = await _refreshAccessToken();
    if (!refreshed) return first;
    return await doRequest();
  }

  static Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (auth) {
      final sp = await SharedPreferences.getInstance();

      // 예전/새 키 이름 모두 지원
      final token =
          sp.getString('access_token') ?? sp.getString('access');
>>>>>>> clean-summary-2_flutter
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

<<<<<<< HEAD
  /// access 토큰을 refresh 토큰으로 갱신
  static Future<bool> _refreshAccessToken() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final refresh = sp.getString('refresh_token');
=======
  static Future<bool> _refreshAccessToken() async {
    try {
      final sp = await SharedPreferences.getInstance();

      // 예전/새 키 이름 모두 지원
      final refresh =
          sp.getString('refresh_token') ?? sp.getString('refresh');
>>>>>>> clean-summary-2_flutter
      if (refresh == null || refresh.isEmpty) return false;

      final res = await http.post(
        _u('/api/auth/token/refresh/'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refresh}),
      );
<<<<<<< HEAD
=======

>>>>>>> clean-summary-2_flutter
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final newAccess = data['access'] as String?;
        if (newAccess == null || newAccess.isEmpty) return false;
<<<<<<< HEAD
        await sp.setString('access_token', newAccess);
=======

        // 두 키 모두에 저장해서 어디서 읽어도 되도록
        await sp.setString('access_token', newAccess);
        await sp.setString('access', newAccess);
>>>>>>> clean-summary-2_flutter
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
<<<<<<< HEAD
=======

/// 외부에서 사용할 수 있게 public으로 유지
class ApiMultipartFile {
  final String field;
  final List<int> bytes;
  final String filename;
  ApiMultipartFile(this.field, this.bytes, this.filename);
}
>>>>>>> clean-summary-2_flutter
