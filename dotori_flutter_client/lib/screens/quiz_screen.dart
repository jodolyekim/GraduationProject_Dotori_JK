// // lib/screens/quiz_screen.dart
// import 'package:flutter/material.dart';
// import 'package:dotori_client/services/quiz_service.dart';
// import 'package:dotori_client/services/membership_service.dart'; //  포인트 적립

// class QuizScreen extends StatefulWidget {
//   final String difficulty; // 'EASY' | 'MEDIUM' | 'HARD'
//   const QuizScreen({super.key, this.difficulty = 'EASY'});

//   @override
//   State<QuizScreen> createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   Map<String, dynamic>? quiz;
//   bool loading = false;
//   int? selectedId;
//   String? feedback;
//   bool showHint = false;
//   final Stopwatch sw = Stopwatch();

//   final _membershipSvc = MembershipService.instance; // 

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() {
//       loading = true;
//       quiz = null;
//       selectedId = null;
//       feedback = null;
//       showHint = false;
//     });
//     final q = await QuizService.next(difficulty: widget.difficulty);
//     setState(() {
//       loading = false;
//       quiz = q;
//     });
//     sw
//       ..reset()
//       ..start();
//   }

//   Future<void> _submit() async {
//     if (quiz == null || selectedId == null) return;
//     sw.stop();
//     final result = await QuizService.submit(
//       quizId: quiz!['id'] as int,
//       optionId: selectedId!,
//       timeMs: sw.elapsedMilliseconds,
//     );

//     final bool isCorrect = result['correct'] == true;
//     setState(() {
//       feedback = isCorrect ? '정답이에요! 🎉' : '아쉬워요. 다시 해볼까요?';
//     });

//     //  정답일 때 멤버십 등급에 따라 포인트 적립
//     if (isCorrect) {
//       await _membershipSvc.rewardAction(
//         title: '사고력 퀴즈 정답',
//         detail: '퀴즈 ID: ${quiz!['id']}',
//       );

//       final plan = _membershipSvc.currentPlan;
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               '정답! ${plan.name} 등급 기준으로 포인트 ${plan.pointPerAction}점이 적립되었어요. (하루 최대 100점)',
//             ),
//           ),
//         );
//       }
//     }

//     final rationale = (result['rationale'] as String?)?.trim();
//     if (rationale != null && rationale.isNotEmpty && mounted) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('이유: $rationale')));
//     }
//   }

//   String _getQTypeLabel(String? qtype) {
//     switch (qtype) {
//       case 'SENTENCE_MEANING':
//         return '💬 문장 의미 찾기 문제';
//       case 'SITUATION_TEXT':
//         return '💭 상황에 맞는 답변 선택';
//       case 'SITUATION_IMAGE':
//         return '🧩 상황에 맞는 이미지 선택';
//       default:
//         return '사고력 퀴즈';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     if (loading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//     if (quiz == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text('사고력 퀴즈')),
//         body: Center(
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             const Text('문제를 불러오지 못했어요.'),
//             const SizedBox(height: 12),
//             FilledButton(onPressed: _load, child: const Text('다시 시도')),
//           ]),
//         ),
//       );
//     }

//     final qtype = quiz!['qtype'] as String?;
//     final options = (quiz!['options'] as List).cast<Map<String, dynamic>>();
//     final prompt = (quiz!['prompt_text'] as String?) ?? '';
//     final hint = (quiz!['hint_text'] as String?) ?? '';

//     return Scaffold(
//       appBar: AppBar(title: const Text('사고력 퀴즈')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             // 문제 유형 안내
//             Text(
//               _getQTypeLabel(qtype),
//               style: theme.textTheme.titleMedium?.copyWith(
//                 color: Colors.deepPurple,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),

//             // 문제 본문
//             Text(prompt, style: theme.textTheme.titleLarge),
//             const SizedBox(height: 8),

//             if (hint.isNotEmpty)
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () => setState(() => showHint = !showHint),
//                     icon: const Icon(Icons.lightbulb),
//                     tooltip: '힌트 보기',
//                   ),
//                   Text(showHint ? '힌트: $hint' : '힌트 보기'),
//                 ],
//               ),

//             const SizedBox(height: 16),

//             if (qtype == 'SITUATION_IMAGE')
//               // 이미지 보기 문제
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: options.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 12,
//                   crossAxisSpacing: 12,
//                 ),
//                 itemBuilder: (context, index) {
//                   final o = options[index];
//                   final id = o['id'] as int;
//                   final img = (o['image_url'] as String?) ?? '';
//                   final isSelected = selectedId == id;
//                   return GestureDetector(
//                     onTap: () => setState(() => selectedId = id),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: isSelected ? Colors.black : Colors.grey.shade300,
//                           width: 3,
//                         ),
//                       ),
//                       child: img.isNotEmpty
//                           ? ClipRRect(
//                               borderRadius: BorderRadius.circular(16),
//                               child: Image.network(img, fit: BoxFit.cover),
//                             )
//                           : Center(
//                               child: Text(
//                                 o['text'] ?? '',
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                     ),
//                   );
//                 },
//               )
//             else
//               // 텍스트 보기 문제 (기존 로직 그대로)
//               Column(
//                 children: options.map((o) {
//                   final id = o['id'] as int;
//                   final text = (o['text'] as String?) ?? '';
//                   final img = (o['image_url'] as String?) ?? '';
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: InkWell(
//                       onTap: () => setState(() => selectedId = id),
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             width: 3,
//                             color: selectedId == id
//                                 ? Colors.black
//                                 : Colors.grey.shade300,
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Radio<int>(
//                               value: id,
//                               groupValue: selectedId,
//                               onChanged: (v) => setState(() => selectedId = v),
//                             ),
//                             const SizedBox(width: 8),
//                             if (img.isNotEmpty)
//                               Expanded(
//                                 child: Image.network(
//                                   img,
//                                   height: 80,
//                                   fit: BoxFit.contain,
//                                 ),
//                               )
//                             else
//                               Expanded(
//                                 child: Text(
//                                   text,
//                                   style: theme.textTheme.titleMedium,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),

//             const SizedBox(height: 16),
//             FilledButton(
//               onPressed: selectedId == null ? null : _submit,
//               child: const Text('제출'),
//             ),
//             const SizedBox(height: 12),
//             if (feedback != null)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(feedback!, style: theme.textTheme.titleLarge),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       FilledButton.tonal(
//                         onPressed: _load,
//                         child: const Text('다음 문제'),
//                       ),
//                       const SizedBox(width: 8),
//                       OutlinedButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text('닫기'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/screens/quiz_screen.dart

// lib/screens/quiz_screen.dart
// lib/screens/quiz_screen.dart

// lib/screens/quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:dotori_client/services/quiz_service.dart';
import 'package:dotori_client/services/membership_service.dart';
import 'package:dotori_client/theme/app_theme.dart';
import 'package:dotori_client/widgets/dotori_button.dart';

import 'package:flutter/material.dart';
import 'package:dotori_client/services/quiz_service.dart';
import 'package:dotori_client/services/membership_service.dart';
import 'package:dotori_client/theme/app_theme.dart';
import 'package:dotori_client/widgets/dotori_button.dart';

class QuizScreen extends StatefulWidget {
  final String difficulty;
  const QuizScreen({super.key, this.difficulty = 'EASY'});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map<String, dynamic>? quiz;
  bool loading = false;
  int? selectedId;
  bool showHint = false;

  String? resultText;
  String? rationaleText;

  final Stopwatch sw = Stopwatch();
  final _membership = MembershipService.instance;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      quiz = null;
      selectedId = null;
      resultText = null;
      rationaleText = null;
      showHint = false;
    });

    final q = await QuizService.next(difficulty: widget.difficulty);
    sw..reset()..start();
    setState(() {
      quiz = q;
      loading = false;
    });
  }

  Future<void> _submit() async {
    if (quiz == null || selectedId == null) return;

    sw.stop();

    final result = await QuizService.submit(
      quizId: quiz!['id'],
      optionId: selectedId!,
      timeMs: sw.elapsedMilliseconds,
    );

    final isCorrect = result['correct'] == true;
    final rationale = (result['rationale'] as String?)?.trim() ?? '';

    resultText = isCorrect ? "정답이에요! 🎉" : "아쉬워요. 다시 해볼까요?";
    rationaleText = rationale.isNotEmpty ? rationale : null;

    if (isCorrect) {
      await _membership.rewardAction(
        title: '사고력 퀴즈 정답',
        detail: '퀴즈 ID: ${quiz!['id']}',
      );
    }

    setState(() {});
  }

  Color _difficultyColor() {
    switch (widget.difficulty) {
      case 'EASY':
        return Colors.green;
      case 'MEDIUM':
        return Colors.orange;
      case 'HARD':
        return Colors.red;
      default:
        return DotoriTheme.primary;
    }
  }

  String _difficultyLabel() {
    switch (widget.difficulty) {
      case 'EASY':
        return '쉬움';
      case 'MEDIUM':
        return '보통';
      case 'HARD':
        return '어려움';
      default:
        return widget.difficulty;
    }
  }

  String _getQLabel(String? type) {
    switch (type) {
      case 'SENTENCE_MEANING':
        return '💬 문장 의미 찾기';
      case 'SITUATION_TEXT':
        return '💭 상황 텍스트 선택';
      case 'SITUATION_IMAGE':
        return '🧩 상황 이미지 선택';
      default:
        return '사고력 퀴즈';
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = quiz;

    return Scaffold(
      backgroundColor: DotoriTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "사고력 퀴즈",
          style: TextStyle(
            color: DotoriTheme.brownDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loading || q == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeader(q),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildQuestion(q),
                          const SizedBox(height: 16),
                          _buildOptions(q),
                          const SizedBox(height: 16),
                          _buildResultCard(),
                          const SizedBox(height: 16),
                          _buildSubmitButton(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader(Map<String, dynamic> q) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DotoriTheme.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: DotoriTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DotoriTheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.quiz_outlined, color: DotoriTheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getQLabel(q['qtype']),
                    style: DotoriTheme.subtitle.copyWith(fontSize: 17)),
                const SizedBox(height: 4),
                Text(
                  '문제를 읽고 알맞은 보기를 선택하세요.',
                  style: DotoriTheme.body.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _difficultyColor().withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              _difficultyLabel(),
              style: TextStyle(
                color: _difficultyColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  // ---------------- QUESTION ----------------
  Widget _buildQuestion(Map<String, dynamic> q) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DotoriTheme.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: DotoriTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("문제", style: DotoriTheme.subtitle.copyWith(fontSize: 18)),
          const SizedBox(height: 12),

          // 문제 텍스트
          Text(q['prompt_text'], style: DotoriTheme.titleLarge),
          const SizedBox(height: 16),

          // 문제 이미지가 있을 경우 표시
          if ((q['prompt_img'] ?? '').toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                q['prompt_img'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 16),

          // 힌트
          if ((q['hint_text'] ?? '').isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => showHint = !showHint),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline,
                        color: Colors.amber.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        showHint ? "힌트: ${q['hint_text']}" : "힌트를 보려면 눌러보세요",
                        style: DotoriTheme.body,
                      ),
                    ),
                    Icon(showHint ? Icons.expand_less : Icons.expand_more),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  // ---------------- OPTIONS ----------------
  Widget _buildOptions(Map<String, dynamic> q) {
    final options = (q['options'] as List).cast<Map<String, dynamic>>();
    final bool isImageQuiz = q['qtype'] == 'SITUATION_IMAGE';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DotoriTheme.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: DotoriTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("보기 선택", style: DotoriTheme.subtitle.copyWith(fontSize: 18)),
          const SizedBox(height: 14),

          // 이미지 기반 문제는 2xN Grid
          if (isImageQuiz)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, i) =>
                  _buildOptionItem(options[i], isGrid: true),
            )
          else
            Column(
              children: options
                  .map((o) => _buildOptionItem(o, isGrid: false))
                  .toList(),
            ),
        ],
      ),
    );
  }

  // ---------------- OPTION ITEM ----------------
  Widget _buildOptionItem(Map<String, dynamic> o, {bool isGrid = false}) {
    final id = o['id'];
    final isSelected = selectedId == id;

    final hasImage =
        o['image_url'] != null && o['image_url'].toString().isNotEmpty;

    return GestureDetector(
      onTap: () => setState(() => selectedId = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected ? DotoriTheme.brownLight.withOpacity(0.25) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? DotoriTheme.primary : Colors.grey.shade300,
            width: 3,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    o['image_url'],
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            if (hasImage) const SizedBox(height: 8),

            if ((o['text'] ?? '').toString().isNotEmpty)
              Text(
                o['text'],
                style: DotoriTheme.body.copyWith(fontSize: 15),
              ),

            Align(
              alignment: Alignment.bottomRight,
              child: Radio<int>(
                value: id,
                groupValue: selectedId,
                onChanged: (_) => setState(() => selectedId = id),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- RESULT ----------------
  Widget _buildResultCard() {
    if (resultText == null) return const SizedBox.shrink();

    final bool correct = resultText!.contains("정답");
    final Color bg =
        correct ? const Color(0xFFDFF3E3) : const Color(0xFFF8DFDF);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: DotoriTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(resultText!, style: DotoriTheme.titleLarge.copyWith(fontSize: 18)),
          if (rationaleText != null) ...[
            const SizedBox(height: 12),
            Text("이유: $rationaleText",
                style: DotoriTheme.body.copyWith(fontSize: 15)),
          ],
        ],
      ),
    );
  }

  // ---------------- BUTTONS ----------------
  Widget _buildSubmitButton() {
    return Column(
      children: [
        DotoriButton(
          text: resultText == null ? "제출하기" : "다음 문제",
          onPressed: resultText == null ? _submit : _load,
        ),
        const SizedBox(height: 10),
        DotoriButton(
          text: "닫기",
          outlined: true,
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}

