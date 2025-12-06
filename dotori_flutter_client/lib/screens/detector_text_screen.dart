// import 'package:flutter/material.dart';
// import '../services/detector_service.dart';
// import '../services/membership_service.dart';
// import '../widgets/result_card.dart';

// class DetectorTextScreen extends StatefulWidget {
//   const DetectorTextScreen({super.key});

//   @override
//   State<DetectorTextScreen> createState() => _DetectorTextScreenState();
// }

// class _DetectorTextScreenState extends State<DetectorTextScreen> {
//   final _controller = TextEditingController();
//   bool _loading = false;
//   Map<String, dynamic>? _result;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("텍스트 디텍터")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               maxLines: 8,
//               decoration: const InputDecoration(
//                 hintText: "텍스트를 붙여넣거나 직접 입력하세요",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),

//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _loading
//                     ? null
//                     : () async {
//                         //  멤버십 제한 체크
//                         final ok = await MembershipService.instance.useDetector();
//                         if (!ok) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("오늘 AI 디텍터 사용 횟수를 모두 소진했습니다.")),
//                           );
//                           return;
//                         }

//                         setState(() => _loading = true);
//                         try {
//                           final data = await DetectorService.detectText(_controller.text);
//                           setState(() => _result = data);
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("분석 실패: $e")),
//                           );
//                         } finally {
//                           setState(() => _loading = false);
//                         }
//                     },
//                 child: Text(_loading ? "분석 중..." : "분석하기"),
//               ),
//             ),

//             const SizedBox(height: 16),

//             if (_result != null)
//               ResultCard(
//                 result: _result!,
//                 onBack: () => Navigator.pop(context),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/screens/detector_text_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/detector_service.dart';
import '../services/membership_service.dart';
import '../widgets/result_card.dart';

class DetectorTextScreen extends StatefulWidget {
  const DetectorTextScreen({super.key});

  @override
  State<DetectorTextScreen> createState() => _DetectorTextScreenState();
}

class _DetectorTextScreenState extends State<DetectorTextScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  Map<String, dynamic>? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _runDetection() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _snack("텍스트를 입력하세요.");
      return;
    }

    final ok = await MembershipService.instance.useDetector();
    if (!ok) {
      _snack("오늘 사용 가능한 AI 디텍터 횟수를 모두 소진했습니다.");
      return;
    }

    setState(() => _loading = true);

    try {
      final data = await DetectorService.detectText(text);
      setState(() => _result = data);
    } catch (e) {
      _snack("분석 실패: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

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
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: DotoriTheme.brownDark.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.text_snippet_rounded,
              color: DotoriTheme.brownDark,
              size: 28,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("텍스트 AI 탐지",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: DotoriTheme.brownDark,
                    )),
                SizedBox(height: 6),
                Text("문장이 AI 생성물인지 분석해요.",
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.3,
                      color: DotoriTheme.brown,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _inputCard() {
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
          Text("텍스트 입력",
              style: DotoriTheme.subtitle),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: "여기에 텍스트를 입력하세요.",
              filled: true,
              fillColor: DotoriTheme.ivory,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                    color: Colors.brown.withOpacity(0.3)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loading ? null : _runDetection,
            style: ElevatedButton.styleFrom(
              backgroundColor: DotoriTheme.brownDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: _loading
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text("AI 분석하기",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DotoriTheme.background,
      appBar: AppBar(
        title: const Text("텍스트 디텍터"),
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
              _inputCard(),
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
