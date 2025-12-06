// import 'dart:io' show File;
// import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';

// import '../services/detector_service.dart';
// import '../services/membership_service.dart';
// import '../widgets/result_card.dart';

// class DetectorVideoScreen extends StatefulWidget {
//   const DetectorVideoScreen({super.key});

//   @override
//   State<DetectorVideoScreen> createState() => _DetectorVideoScreenState();
// }

// class _DetectorVideoScreenState extends State<DetectorVideoScreen> {
//   bool _loading = false;
//   Map<String, dynamic>? _result;

//   String? _filename;
//   String? _path;
//   Uint8List? _bytes;

//   Future<void> _pick() async {
//     final res = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: [
//         'mp4',
//         'mov',
//         'mkv',
//         'webm',
//       ],
//       withData: true,
//     );
//     if (res == null) return;
//     final f = res.files.single;

//     setState(() {
//       _filename = f.name;
//       if (kIsWeb) {
//         _bytes = f.bytes;
//         _path = null;
//       } else {
//         _path = f.path;
//         _bytes = null;
//       }
//       _result = null;
//     });
//   }

//   Future<void> _analyze() async {
//     // 멤버십 사용량 체크
//     final ok = await MembershipService.instance.useDetector();
//     if (!ok) {
//       _snack("오늘 사용 가능한 AI 디텍터 횟수를 모두 사용했습니다.");
//       return;
//     }

//     if (_loading) return;
//     if (_filename == null) {
//       _snack("영상 파일을 선택하세요.");
//       return;
//     }

//     setState(() => _loading = true);

//     try {
//       Map<String, dynamic> data;

//       if (!kIsWeb && _path != null) {
//         data = await DetectorService.detectVideoFile(File(_path!));
//       } else if (_bytes != null) {
//         data = await DetectorService.detectVideoBytes(
//           _bytes!,
//           _filename!,
//         );
//       } else {
//         throw Exception("파일 데이터를 읽을 수 없습니다.");
//       }

//       // 터미널 디버그용
//       // ignore: avoid_print
//       print('🔎 detector video result: $data');

//       setState(() => _result = data);
//     } catch (e) {
//       _snack("분석 실패: $e");
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   void _snack(String msg) =>
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('영상 디텍터')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: _loading ? null : _pick,
//                   child: const Text('영상 선택'),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     _filename ?? '선택된 파일 없음',
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: (_filename == null || _loading) ? null : _analyze,
//                 child:
//                     _loading ? const Text("분석 중...") : const Text("영상 분석하기"),
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (_result != null)
//               Expanded(
//                 child: ResultCard(
//                   result: _result!,
//                   onBack: () => Navigator.pop(context),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/screens/detector_video_screen.dart
// lib/screens/detector_video_screen.dart
import 'dart:io' show File;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../services/detector_service.dart';
import '../services/membership_service.dart';
import '../widgets/result_card.dart';

class DetectorVideoScreen extends StatefulWidget {
  const DetectorVideoScreen({super.key});

  @override
  State<DetectorVideoScreen> createState() => _DetectorVideoScreenState();
}

class _DetectorVideoScreenState extends State<DetectorVideoScreen> {
  bool _loading = false;
  Map<String, dynamic>? _result;

  String? _filename;
  String? _path;
  Uint8List? _bytes;

  Future<void> _pick() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'mkv', 'webm'],
      withData: true,
    );
    if (res == null) return;

    final file = res.files.single;

    setState(() {
      _filename = file.name;
      if (kIsWeb) {
        _bytes = file.bytes;
        _path = null;
      } else {
        _path = file.path;
        _bytes = null;
      }
      _result = null;
    });
  }

  Future<void> _analyze() async {
    final ok = await MembershipService.instance.useDetector();
    if (!ok) {
      _snack("오늘 사용 가능한 AI 디텍터 횟수를 모두 소진했습니다.");
      return;
    }

    if (_filename == null) {
      _snack("영상을 선택하세요.");
      return;
    }

    setState(() => _loading = true);

    try {
      Map<String, dynamic> data;
      if (!kIsWeb && _path != null) {
        data = await DetectorService.detectVideoFile(File(_path!));
      } else if (_bytes != null) {
        data = await DetectorService.detectVideoBytes(_bytes!, _filename!);
      } else {
        throw Exception("파일 데이터를 읽을 수 없습니다.");
      }

      setState(() => _result = data);
    } catch (e) {
      _snack("분석 실패: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));


  // HEADER

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: DotoriTheme.card,
        borderRadius: BorderRadius.circular(26),
        boxShadow: DotoriTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: DotoriTheme.brownDark.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.movie_outlined,
              size: 28,
              color: DotoriTheme.brownDark,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "영상 AI 탐지",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: DotoriTheme.brownDark,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "영상이 AI 생성물인지 분석해요.",
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.3,
                    color: DotoriTheme.brown,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // UPLOAD CARD

  Widget _uploadCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DotoriTheme.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: DotoriTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("영상 선택", style: DotoriTheme.subtitle),
          const SizedBox(height: 12),

          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _loading ? null : _pick,
                icon: const Icon(Icons.folder_open_rounded),
                label: const Text("파일 선택"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DotoriTheme.brownDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _filename ?? '선택된 파일 없음',
                  overflow: TextOverflow.ellipsis,
                  style: DotoriTheme.body,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            children: const [
              _Chip("mp4"),
              _Chip("mov"),
              _Chip("mkv"),
              _Chip("webm"),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: DotoriTheme.ivory,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.smart_display_outlined,
                    color: DotoriTheme.brownDark),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _filename != null
                        ? "선택된 영상: $_filename"
                        : "분석할 영상을 선택해 주세요.",
                    style: DotoriTheme.body,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _loading ? null : _analyze,
            style: ElevatedButton.styleFrom(
              backgroundColor: DotoriTheme.brownDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    "영상 분석하기",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ],
      ),
    );
  }


  // BUILD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DotoriTheme.background,
      appBar: AppBar(
        title: const Text('영상 디텍터'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
          child: Column(
            children: [
              _headerCard(),
              const SizedBox(height: 20),
              _uploadCard(),
              const SizedBox(height: 20),
              if (_result != null)
                ResultCard(
                  result: _result!,
                  onBack: () => setState(() => _result = null),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: DotoriTheme.ivory,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
