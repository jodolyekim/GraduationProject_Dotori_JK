// import 'dart:io' show File;
// import 'dart:typed_data';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';

// import '../services/detector_service.dart';
// import '../services/membership_service.dart';
// import '../widgets/result_card.dart';

// class DetectorAudioScreen extends StatefulWidget {
//   const DetectorAudioScreen({super.key});

//   @override
//   State<DetectorAudioScreen> createState() => _DetectorAudioScreenState();
// }

// class _DetectorAudioScreenState extends State<DetectorAudioScreen> {
//   bool _loading = false;
//   Map<String, dynamic>? _result;

//   String? _filename;
//   String? _path;
//   Uint8List? _bytes;

//   Future<void> _pick() async {
//     final res = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['wav','mp3','mp4','m4a'],
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
//     //  멤버십 제한
//     final ok = await MembershipService.instance.useDetector();
//     if (!ok) {
//       _snack("오늘 사용 가능한 AI 디텍터 횟수를 모두 소진했습니다.");
//       return;
//     }

//     if (_loading) return;
//     if (_filename == null) {
//       _snack("오디오 파일을 선택하세요.");
//       return;
//     }

//     setState(() => _loading = true);

//     try {
//       Map<String, dynamic> data;

//       if (!kIsWeb && _path != null) {
//         data = await DetectorService.detectAudioFile(File(_path!));
//       } else if (_bytes != null) {
//         data = await DetectorService.detectAudioBytes(_bytes!, _filename!);
//       } else {
//         throw Exception("파일 데이터를 읽을 수 없습니다.");
//       }

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
//       appBar: AppBar(title: const Text('오디오 디텍터')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 ElevatedButton(onPressed: _loading ? null : _pick, child: const Text('파일 선택')),
//                 const SizedBox(width: 12),
//                 Expanded(child: Text(_filename ?? '선택된 파일 없음', overflow: TextOverflow.ellipsis)),
//               ],
//             ),

//             const SizedBox(height: 12),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: (_filename == null || _loading) ? null : _analyze,
//                 child: _loading ? const Text("분석 중...") : const Text("분석하기"),
//               ),
//             ),

//             const SizedBox(height: 16),

//             if (_result != null)
//               ResultCard(result: _result!, onBack: () => Navigator.pop(context)),
//           ],
//         ),
//       ),
//     );
//   }
// }
