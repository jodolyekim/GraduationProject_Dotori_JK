// // lib/screens/roleplay_screen.dart
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:dotori_client/services/api_client.dart';
// import 'package:dotori_client/services/membership_service.dart'; //  포인트 적립

// class RoleplayScreen extends StatefulWidget {
//   const RoleplayScreen({super.key});

//   @override
//   State<RoleplayScreen> createState() => _RoleplayScreenState();
// }

// class _RoleplayScreenState extends State<RoleplayScreen> {
//   /// 현재 선택된 시나리오 코드 (백엔드 scenarios.py 의 code 와 맞춤)
//   String _scenarioCode = 'friend_fell';

//   /// 시나리오 목록 (프론트 하드코딩 버전)
//   final Map<String, String> _scenarioLabels = const {
//     'friend_fell': '친구가 넘어졌을 때',
//     'comfort_sad_friend': '속상한 친구 위로하기',
//     'ask_staff_convenience_store': '편의점에서 물건 위치 물어보기',
//   };

//   // 세션 상태(서버 세션 X, 프론트에서만 관리)
//   bool _starting = false;
//   bool _sending = false;

//   // 텍스트 컨트롤러
//   final _topicCtrl = TextEditingController(); // 상황 설명/주제
//   final _inputCtrl = TextEditingController(); // 대화 입력

//   // 대화 로그 (화면에 보여줄 것)
//   final List<_ChatMessage> _messages = [];

//   // 백엔드에 넘길 message 히스토리 (role/user, assistant)
//   final List<Map<String, String>> _historyForApi = [];

//   //  롤플 포인트용 타이머/상태
//   DateTime? _sessionStart;
//   bool _rewardedThisSession = false;
//   final _membershipSvc = MembershipService.instance;

//   @override
//   void dispose() {
//     _topicCtrl.dispose();
//     _inputCtrl.dispose();
//     super.dispose();
//   }

//   void _snack(String msg) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg)),
//     );
//   }

//   //  5분 이상 플레이 시 포인트 적립 (세션당 1회)
//   Future<void> _checkRoleplayReward() async {
//     if (_sessionStart == null || _rewardedThisSession) return;
//     final diff = DateTime.now().difference(_sessionStart!);
//     if (diff.inMinutes < 5) return;

//     _rewardedThisSession = true;

//     await _membershipSvc.rewardAction(
//       title: '역할극 참여',
//       detail: '5분 이상 역할극 진행',
//     );

//     final plan = _membershipSvc.currentPlan;
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             '역할극을 5분 이상 진행했어요!\n${plan.name} 등급 기준으로 포인트 ${plan.pointPerAction}점이 적립되었어요. (하루 최대 100점)',
//           ),
//         ),
//       );
//     }
//   }

//   // ---------------- 역할극 "시작" (초기 멘트 요청) ----------------
//   Future<void> _startSession() async {
//     final topic = _topicCtrl.text.trim();

//     setState(() {
//       _starting = true;
//       _messages.clear();
//       _historyForApi.clear();
//       _sessionStart = DateTime.now(); //  새 세션 시작 시간
//       _rewardedThisSession = false;
//     });

//     // 첫 번째 user 메시지(상황 설명)
//     final firstUserMessage = topic.isNotEmpty
//         ? '이런 상황을 연습하고 싶어: $topic. 먼저 상황을 짧게 설명하고, 상대방이 나에게 먼저 말을 걸어주는 역할극을 시작해줘.'
//         : '이 시나리오("${_scenarioLabels[_scenarioCode]}")로 역할극을 시작해줘. 상황을 설명하고, 상대방이 먼저 말을 걸어줘.';

//     _historyForApi.add({
//       'role': 'user',
//       'content': firstUserMessage,
//     });

//     try {
//       //  JWT 토큰을 붙여서 인증된 유저로 호출
//       final res = await ApiClient.postJson(
//         '/api/roleplay/chat/',
//         {
//           'scenario_code': _scenarioCode,
//           'messages': _historyForApi,
//         },
//         auth: true,
//       );

//       if (res.statusCode != 200) {
//         throw Exception('status=${res.statusCode} body=${res.body}');
//       }

//       final data = jsonDecode(res.body) as Map<String, dynamic>;

//       final assistantReply =
//           (data['assistant_reply'] ?? data['assistant_message'] ?? '') as String;
//       final coachComment = (data['coach_comment'] ?? '') as String;
//       final suggestedNext =
//           (data['suggested_next_action'] ?? '') as String;

//       // history 에 assistant 답변 추가
//       _historyForApi.add({
//         'role': 'assistant',
//         'content': assistantReply,
//       });

//       setState(() {
//         // 역할극 상대방 답변
//         _messages.add(
//           _ChatMessage(
//             isUser: false,
//             isCoach: false,
//             text: assistantReply,
//             createdAt: DateTime.now(),
//           ),
//         );

//         // 코치 코멘트(있으면)
//         if (coachComment.trim().isNotEmpty) {
//           _messages.add(
//             _ChatMessage(
//               isUser: false,
//               isCoach: true,
//               text: coachComment,
//               createdAt: DateTime.now(),
//             ),
//           );
//         }

//         // 다음 행동 추천(있으면)
//         if (suggestedNext.trim().isNotEmpty) {
//           _messages.add(
//             _ChatMessage(
//               isUser: false,
//               isCoach: true,
//               text: '다음 행동 추천: $suggestedNext',
//               createdAt: DateTime.now(),
//             ),
//           );
//         }
//       });
//     } catch (e) {
//       _snack('역할극 시작 실패: $e');
//     } finally {
//       if (mounted) {
//         setState(() => _starting = false);
//       }
//     }
//   }

//   // ---------------- 대화 전송 ----------------
//   Future<void> _sendMessage() async {
//     if (_historyForApi.isEmpty) {
//       _snack('먼저 역할극을 시작해주세요.');
//       return;
//     }

//     final text = _inputCtrl.text.trim();
//     if (text.isEmpty) return;

//     final now = DateTime.now();

//     // 내 메시지 UI 에 먼저 표시
//     setState(() {
//       _messages.add(
//         _ChatMessage(
//           isUser: true,
//           isCoach: false,
//           text: text,
//           createdAt: now,
//         ),
//       );
//       _inputCtrl.clear();
//       _sending = true;
//     });

//     // history 에도 추가
//     _historyForApi.add({
//       'role': 'user',
//       'content': text,
//     });

//     try {
//       //  여기서도 마찬가지로 인증 붙여서 호출
//       final res = await ApiClient.postJson(
//         '/api/roleplay/chat/',
//         {
//           'scenario_code': _scenarioCode,
//           'messages': _historyForApi,
//         },
//         auth: true,
//       );

//       if (res.statusCode != 200) {
//         throw Exception('status=${res.statusCode} body=${res.body}');
//       }

//       final data = jsonDecode(res.body) as Map<String, dynamic>;

//       final assistantReply =
//           (data['assistant_reply'] ?? data['assistant_message'] ?? '') as String;
//       final coachComment = (data['coach_comment'] ?? '') as String;
//       final suggestedNext =
//           (data['suggested_next_action'] ?? '') as String;

//       // history 에 assistant 답변 추가
//       _historyForApi.add({
//         'role': 'assistant',
//         'content': assistantReply,
//       });

//       setState(() {
//         // 역할극 상대방 답변
//         _messages.add(
//           _ChatMessage(
//             isUser: false,
//             isCoach: false,
//             text: assistantReply,
//             createdAt: DateTime.now(),
//           ),
//         );

//         // 코치 코멘트(있으면)
//         if (coachComment.trim().isNotEmpty) {
//           _messages.add(
//             _ChatMessage(
//               isUser: false,
//               isCoach: true,
//               text: coachComment,
//               createdAt: DateTime.now(),
//             ),
//           );
//         }

//         if (suggestedNext.trim().isNotEmpty) {
//           _messages.add(
//             _ChatMessage(
//               isUser: false,
//               isCoach: true,
//               text: '다음 행동 추천: $suggestedNext',
//               createdAt: DateTime.now(),
//             ),
//           );
//         }
//       });

//       //  매 메시지 전송 후 5분 조건 만족하면 포인트 적립
//       await _checkRoleplayReward();
//     } catch (e) {
//       _snack('메시지 전송 실패: $e');
//     } finally {
//       if (mounted) {
//         setState(() => _sending = false);
//       }
//     }
//   }

//   // ---------------- UI ----------------
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('역할극 연습'),
//       ),
//       body: Column(
//         children: [
//           // 설정 카드
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: _buildConfigCard(theme),
//           ),
//           const Divider(height: 1),
//           // 대화 영역
//           Expanded(
//             child: Container(
//               color: Colors.grey.shade100,
//               child: _messages.isEmpty
//                   ? const Center(
//                       child: Text(
//                         '역할극을 시작하면 여기서 대화가 진행됩니다.',
//                         style: TextStyle(color: Colors.black54),
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: const EdgeInsets.all(8),
//                       itemCount: _messages.length,
//                       itemBuilder: (context, index) {
//                         final msg = _messages[index];
//                         return _buildMessageBubble(msg);
//                       },
//                     ),
//             ),
//           ),
//           // 입력창
//           SafeArea(
//             top: false,
//             child: _buildInputBar(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildConfigCard(ThemeData theme) {
//     final hasStarted = _historyForApi.isNotEmpty;

//     return Card(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('시나리오 설정', style: theme.textTheme.titleMedium),
//             const SizedBox(height: 8),
//             // 시나리오 선택
//             DropdownButtonFormField<String>(
//               value: _scenarioCode,
//               decoration: const InputDecoration(
//                 labelText: '상황',
//                 border: OutlineInputBorder(),
//               ),
//               items: _scenarioLabels.entries
//                   .map(
//                     (e) => DropdownMenuItem(
//                       value: e.key,
//                       child: Text(e.value),
//                     ),
//                   )
//                   .toList(),
//               onChanged: hasStarted
//                   ? null
//                   : (v) {
//                       if (v == null) return;
//                       setState(() => _scenarioCode = v);
//                     },
//             ),
//             const SizedBox(height: 8),
//             // 주제/세부 상황 입력
//             TextField(
//               controller: _topicCtrl,
//               enabled: !hasStarted,
//               decoration: const InputDecoration(
//                 labelText: '연습하고 싶은 상황을 구체적으로 적어주세요 (선택)',
//                 hintText: '예) 친구가 넘어져서 울고 있을 때 뭐라고 말해야 할지 모르겠을 때',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 2,
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 icon: _starting
//                     ? const SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : const Icon(Icons.play_arrow),
//                 label: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   child: Text(
//                     hasStarted ? '다시 시작하기' : '역할극 시작하기',
//                   ),
//                 ),
//                 onPressed: _starting
//                     ? null
//                     : () {
//                         _startSession();
//                       },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageBubble(_ChatMessage msg) {
//     final align = msg.isUser ? Alignment.centerRight : Alignment.centerLeft;

//     Color? bubbleColor;
//     TextStyle textStyle = const TextStyle(color: Colors.black87);

//     if (msg.isUser) {
//       bubbleColor = Colors.blue[200];
//     } else if (msg.isCoach) {
//       bubbleColor = Colors.green[100];
//       textStyle = const TextStyle(
//         color: Colors.black87,
//         fontStyle: FontStyle.italic,
//       );
//     } else {
//       bubbleColor = Colors.white;
//     }

//     final crossAlign =
//         msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

//     return Align(
//       alignment: align,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         child: Column(
//           crossAxisAlignment: crossAlign,
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//               constraints: const BoxConstraints(maxWidth: 280),
//               decoration: BoxDecoration(
//                 color: bubbleColor,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 msg.text,
//                 style: textStyle,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInputBar() {
//     final canSend = !_sending && _historyForApi.isNotEmpty;

//     return Container(
//       padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           top: BorderSide(color: Colors.grey.shade300),
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _inputCtrl,
//               minLines: 1,
//               maxLines: 4,
//               enabled: _historyForApi.isNotEmpty,
//               decoration: InputDecoration(
//                 hintText: _historyForApi.isEmpty
//                     ? '먼저 역할극을 시작해주세요.'
//                     : '여기에 답변을 입력하세요',
//                 border: const OutlineInputBorder(),
//                 isDense: true,
//               ),
//               onSubmitted: (_) {
//                 if (canSend) _sendMessage();
//               },
//             ),
//           ),
//           const SizedBox(width: 8),
//           IconButton(
//             icon: _sending
//                 ? const SizedBox(
//                     width: 18,
//                     height: 18,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : const Icon(Icons.send),
//             onPressed: canSend ? _sendMessage : null,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ---------------- 내부 모델 ----------------
// class _ChatMessage {
//   final bool isUser;
//   final bool isCoach; // 코치 코멘트 여부
//   final String text;
//   final DateTime createdAt;

//   _ChatMessage({
//     required this.isUser,
//     required this.isCoach,
//     required this.text,
//     required this.createdAt,
//   });
// }

// lib/screens/roleplay_screen.dart
// lib/screens/roleplay_screen.dart
// lib/screens/roleplay_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dotori_client/services/api_client.dart';
import 'package:dotori_client/services/membership_service.dart';
import 'package:dotori_client/theme/app_theme.dart';
import 'package:dotori_client/widgets/dotori_button.dart';

class RoleplayScreen extends StatefulWidget {
  const RoleplayScreen({super.key});

  @override
  State<RoleplayScreen> createState() => _RoleplayScreenState();
}

class _RoleplayScreenState extends State<RoleplayScreen> {
  // ------
  // 시나리오 목록
  // ------
  final List<Map<String, String>> _scenarios = [
    {
      'code': 'friend_fell',
      'title': '친구가 넘어졌을 때',
    },
    {
      'code': 'comfort_sad_friend',
      'title': '속상한 친구 위로하기',
    },
    {
      'code': 'ask_staff_convenience_store',
      'title': '편의점에서 물건 물어보기',
    },
    {
      'code': 'school_group_presentation',
      'title': '조별과제 회의에서 의견 말하기',
    },
    {
      'code': 'ask_teacher_question',
      'title': '수업 중 모르는 내용 질문하기',
    },
    {
      'code': 'subway_seat',
      'title': '지하철에서 자리 양보하기',
    },
    {
      'code': 'noisy_neighbor',
      'title': '시끄러운 이웃에게 말하기',
    },
    {
      'code': 'parttime_rude_customer',
      'title': '알바 중 불친절 손님 응대하기',
    },
    {
      'code': 'family_talk_stress',
      'title': '부모님께 힘들다고 말하기',
    },
    {
      'code': 'groupchat_misunderstanding',
      'title': '단체 채팅방 오해 풀기',
    },
  ];

  int _scenarioIndex = 0;
  String get _scenarioCode => _scenarios[_scenarioIndex]['code']!;
  String get _scenarioTitle => _scenarios[_scenarioIndex]['title']!;

  // ------
  // 세션 상태
  // ------
  bool _starting = false;
  bool _sending = false;

  final _topicCtrl = TextEditingController();
  final _inputCtrl = TextEditingController();

  final List<_ChatMessage> _messages = [];
  final List<Map<String, String>> _historyForApi = [];

  DateTime? _sessionStart;
  bool _rewardedThisSession = false;
  final _membershipSvc = MembershipService.instance;

  @override
  void dispose() {
    _topicCtrl.dispose();
    _inputCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  bool get _hasSession => _sessionStart != null;

  // ------
  // 좌우 화살표 이동
  // ------
  void _nextScenario() {
    setState(() {
      _scenarioIndex = (_scenarioIndex + 1) % _scenarios.length;
    });
  }

  void _prevScenario() {
    setState(() {
      _scenarioIndex =
          (_scenarioIndex - 1 + _scenarios.length) % _scenarios.length;
    });
  }

  // ------
  // 포인트 보상 체크
  // ------
  Future<void> _checkRoleplayReward() async {
    if (_sessionStart == null || _rewardedThisSession) return;
    final diff = DateTime.now().difference(_sessionStart!);
    if (diff.inMinutes < 5) return;

    _rewardedThisSession = true;

    await _membershipSvc.rewardAction(
      title: '역할극 참여',
      detail: '5분 이상 역할극 진행',
    );

    final plan = _membershipSvc.currentPlan;

    if (mounted) {
      _snack(
          '역할극을 5분 이상 진행했어요!\n${plan.name} 기준 포인트 ${plan.pointPerAction}점 적립!');
    }
  }

  // ------
  // 역할극 시작 (GPT가 먼저 말 안 함)
  // ------
  Future<void> _startSession() async {
    final topic = _topicCtrl.text.trim();

    setState(() {
      _starting = true;
      _messages.clear();
      _historyForApi.clear();
      _sessionStart = DateTime.now();
      _rewardedThisSession = false;
    });

    final guide = StringBuffer()
      ..writeln('지금부터 "${_scenarioTitle}" 상황을 연습해볼게요.')
      ..writeln('먼저 당신이 상대에게 말해보세요.');

    if (topic.isNotEmpty) {
      guide.writeln('세부 상황: "$topic"');
    }

    // guide.writeln('\n예:처럼 시작해보세요.');

    setState(() {
      _messages.add(
        _ChatMessage(
          isUser: false,
          isCoach: true,
          text: guide.toString(),
          createdAt: DateTime.now(),
        ),
      );
    });

    setState(() => _starting = false);
  }

  // ------
  // 메시지 전송
  // ------
  Future<void> _sendMessage() async {
    if (!_hasSession) {
      _snack('먼저 역할극을 시작해주세요.');
      return;
    }

    final text = _inputCtrl.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();

    // UI 표시
    setState(() {
      _messages.add(
        _ChatMessage(
          isUser: true,
          isCoach: false,
          text: text,
          createdAt: now,
        ),
      );
      _inputCtrl.clear();
      _sending = true;
    });

    // 히스토리 추가
    _historyForApi.add({'role': 'user', 'content': text});

    try {
      final res = await ApiClient.postJson(
        '/api/roleplay/chat/',
        {
          'scenario_code': _scenarioCode,
          'messages': _historyForApi,
        },
        auth: true,
      );

      if (res.statusCode != 200) {
        throw Exception(res.body);
      }

      final data = jsonDecode(res.body);

      final assistantReply = (data['assistant_reply'] ?? '').toString();
      final coach = (data['coach_comment'] ?? '').toString();
      final next = (data['suggested_next_action'] ?? '').toString();

      // assistant 메시지 history 추가
      _historyForApi.add({'role': 'assistant', 'content': assistantReply});

      setState(() {
        _messages.add(
          _ChatMessage(
            isUser: false,
            isCoach: false,
            text: assistantReply,
            createdAt: DateTime.now(),
          ),
        );

        if (coach.isNotEmpty) {
          _messages.add(
            _ChatMessage(
              isUser: false,
              isCoach: true,
              text: coach,
              createdAt: DateTime.now(),
            ),
          );
        }

        if (next.isNotEmpty) {
          _messages.add(
            _ChatMessage(
              isUser: false,
              isCoach: true,
              text: '이렇게 말해보는 건 어때요?\n$next',
              createdAt: DateTime.now(),
            ),
          );
        }
      });

      await _checkRoleplayReward();
    } catch (e) {
      _snack('전송 오류: $e');
    } finally {
      setState(() => _sending = false);
    }
  }

  // ------
  // UI 시작
  // ------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DotoriTheme.ivory,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: DotoriTheme.ivory,
        title: const Text(
          '역할극 연습',
          style: TextStyle(color: DotoriTheme.brownDark),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 6),
          _buildScenarioSelector(),
          _buildTopicInput(),
          const SizedBox(height: 8),
          Expanded(child: _buildChatArea()),
          SafeArea(child: _buildInputBar()),
        ],
      ),
    );
  }

  // ------
  // 시나리오 선택 (좌/우 화살표)
  // ------
  Widget _buildScenarioSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: DotoriTheme.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: DotoriTheme.softShadow,
      ),
      child: Row(
        children: [
          _arrowBtn(Icons.arrow_back_ios_rounded, _prevScenario),
          Expanded(
            child: Center(
              child: Text(
                _scenarioTitle,
                style: const TextStyle(
                  color: DotoriTheme.brownDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          _arrowBtn(Icons.arrow_forward_ios_rounded, _nextScenario),
        ],
      ),
    );
  }

  Widget _arrowBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0x22A1887F),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: DotoriTheme.brownDark),
      ),
    );
  }

  // ------
  // 세부 상황 입력
  // ------
  Widget _buildTopicInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextField(
        controller: _topicCtrl,
        decoration: InputDecoration(
          hintText: '연습하고 싶은 세부 상황을 적어도 좋아요 (선택)',
          filled: true,
          fillColor: DotoriTheme.card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          isDense: true,
        ),
        maxLines: 2,
      ),
    );
  }

  // ------
  // 채팅 영역
  // ------
  Widget _buildChatArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: DotoriTheme.softShadow,
      ),
      child: Column(
        children: [
          const SizedBox(height: 6),
          DotoriButton(
            text: _hasSession ? '다시 시작하기' : '역할극 시작하기',
            icon: Icons.play_arrow_rounded,
            loading: _starting,
            onPressed: _starting ? null : _startSession,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      '역할극을 시작하면 대화가 여기에 표시돼요.',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) => _buildMessage(_messages[i]),
                  ),
          ),
        ],
      ),
    );
  }

  // ------
  // 말풍선
  // ------
  Widget _buildMessage(_ChatMessage m) {
    final isUser = m.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser
              ? DotoriTheme.brownDark
              : (m.isCoach ? const Color(0xFFE8F5E9) : const Color(0xFFF7F2EC)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          m.text,
          style: TextStyle(
            color: isUser
                ? Colors.white
                : (m.isCoach ? const Color(0xFF2E7D32) : Colors.black87),
            fontStyle: m.isCoach ? FontStyle.italic : FontStyle.normal,
            height: 1.35,
          ),
        ),
      ),
    );
  }

  // ------
  // 입력창
  // ------
  Widget _buildInputBar() {
    final canSend = !_sending && _hasSession;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4EF),
        borderRadius: BorderRadius.circular(999),
      ),
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputCtrl,
              enabled: _hasSession,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: '상대에게 어떤 말을 해볼까요?',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: canSend ? _sendMessage : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color:
                    canSend ? DotoriTheme.brownDark : Colors.brown.shade300,
                borderRadius: BorderRadius.circular(999),
              ),
              child: _sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send_rounded,
                      size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ------
// 내부 모델
// ------
class _ChatMessage {
  final bool isUser;
  final bool isCoach;
  final String text;
  final DateTime createdAt;

  _ChatMessage({
    required this.isUser,
    required this.isCoach,
    required this.text,
    required this.createdAt,
  });
}
