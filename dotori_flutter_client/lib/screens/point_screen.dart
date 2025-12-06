// // lib/screens/point_screen.dart
// import 'package:flutter/material.dart';
// import '../services/membership_service.dart';

// class PointScreen extends StatefulWidget {
//   const PointScreen({super.key});

//   @override
//   State<PointScreen> createState() => _PointScreenState();
// }

// class _PointScreenState extends State<PointScreen> {
//   final _svc = MembershipService.instance;

//   bool _loading = true;
//   PointsStatus? _status;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final status = await _svc.getMyPoints();
//     if (!mounted) return;
//     setState(() {
//       _status = status;
//       _loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('내 포인트'),
//       ),
//       body: _loading || _status == null
//           ? const Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//               onRefresh: _load,
//               child: ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   // 상단 포인트 카드
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '보유 포인트',
//                             style: theme.textTheme.titleMedium,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             '${_status!.totalPoints} P',
//                             style: theme.textTheme.headlineMedium!.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             '오늘 적립: ${_status!.todayEarned} / ${_status!.dailyLimit} P',
//                             style: theme.textTheme.bodySmall,
//                           ),
//                           const SizedBox(height: 8),
//                           LinearProgressIndicator(
//                             value: _status!.dailyLimit == 0
//                                 ? 0
//                                 : (_status!.todayEarned /
//                                         _status!.dailyLimit)
//                                     .clamp(0.0, 1.0),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // 포인트 모으러 가기
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '포인트 모으러 가기!',
//                             style: theme.textTheme.titleMedium,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             '사고력 퀴즈를 맞추거나 롤플레잉을 5분 이상 플레이하면 등급에 따라 포인트가 적립됩니다.',
//                             style: theme.textTheme.bodySmall,
//                           ),
//                           const SizedBox(height: 12),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ElevatedButton.icon(
//                                   icon: const Icon(Icons.quiz),
//                                   label: const Text('사고력 퀴즈 바로가기'),
//                                   onPressed: () {
//                                     Navigator.pushNamed(context, '/quiz');
//                                   },
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: OutlinedButton.icon(
//                                   icon: const Icon(Icons.chat_bubble_outline),
//                                   label: const Text('롤플레잉 바로가기'),
//                                   onPressed: () {
//                                     Navigator.pushNamed(context, '/roleplay');
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // 포인트 설명
//                   Text(
//                     '포인트 이용 안내',
//                     style: theme.textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '• 포인트는 1점당 1원으로 계산됩니다.\n'
//                     '• 멤버십 결제 시 마일리지처럼 금액에서 차감하거나 전액 포인트로 결제할 수 있습니다.\n'
//                     '• 하루에 적립 가능한 포인트는 최대 100점입니다.\n'
//                     '• 적립 내역은 아래에서 확인할 수 있습니다.',
//                     style: theme.textTheme.bodySmall,
//                   ),
//                   const SizedBox(height: 16),

//                   // 적립/사용 내역
//                   Text(
//                     '적립 / 사용 내역',
//                     style: theme.textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   if (_status!.histories.isEmpty)
//                     Text(
//                       '아직 적립된 포인트가 없습니다.',
//                       style: theme.textTheme.bodySmall,
//                     )
//                   else
//                     ..._status!.histories.map(
//                       (h) => ListTile(
//                         dense: true,
//                         contentPadding: EdgeInsets.zero,
//                         title: Text(h.title),
//                         subtitle: Text(
//                           '${h.detail}\n${h.timestamp.toLocal().toString().substring(0, 16)}',
//                           style: theme.textTheme.bodySmall,
//                         ),
//                         trailing: Text(
//                           '${h.amount > 0 ? '+' : ''}${h.amount}P',
//                           style: TextStyle(
//                             color: h.amount >= 0
//                                 ? Colors.green
//                                 : theme.colorScheme.error,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// lib/screens/point_screen.dart
// lib/screens/point_screen.dart
// lib/screens/point_screen.dart
import 'package:flutter/material.dart';
import '../services/membership_api_service.dart';
import '../theme/app_theme.dart';

/// 백엔드 기반 포인트 내역 모델
class PointHistory {
  final DateTime timestamp;
  final String title;
  final String detail;
  final int amount;

  PointHistory({
    required this.timestamp,
    required this.title,
    required this.detail,
    required this.amount,
  });
}

/// 백엔드 기반 포인트 상태 모델
class PointsStatus {
  final int totalPoints;      //  DB에 누적된 총 보유 포인트 (balance)
  final int todayEarned;      // 오늘 적립 포인트
  final int dailyLimit;       // 일일 적립 한도 (point_daily_cap)
  final List<PointHistory> histories;

  PointsStatus({
    required this.totalPoints,
    required this.todayEarned,
    required this.dailyLimit,
    required this.histories,
  });
}

class PointScreen extends StatefulWidget {
  const PointScreen({super.key});

  @override
  State<PointScreen> createState() => _PointScreenState();
}

class _PointScreenState extends State<PointScreen> {
  final _api = MembershipApiService();

  bool _loading = true;
  PointsStatus? _status;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);

    //  1) 백엔드에서 지갑 요약 / 내역 / overview 모두 가져오기
    final wallet = await _api.getMyPoints();          // /points/ → { balance, ... }
    final historyJson = await _api.getPointHistory(); // /points/history/ → [ ... ]
    final overview = await _api.getOverview();        // /stats/overview/ → points.daily_cap, today_earned

    // ----- 총액(보유 포인트) -----
    final balanceRaw = wallet['balance'];
    final totalPoints = (balanceRaw is num) ? balanceRaw.toInt() : 0;

    // ----- 일일 한도 & 오늘 적립 -----
    int dailyLimit = 100;
    int todayEarned = 0;

    if (overview != null && overview['points'] is Map<String, dynamic>) {
      final pointsInfo = overview['points'] as Map<String, dynamic>;
      final cap = pointsInfo['daily_cap'];
      final todayRaw = pointsInfo['today_earned'];

      if (cap is num) dailyLimit = cap.toInt();
      if (todayRaw is num) todayEarned = todayRaw.toInt();
    }

    // ----- 포인트 내역 변환 -----
    final histories = <PointHistory>[];
    for (final item in historyJson) {
      if (item is! Map<String, dynamic>) continue;

      final amountRaw = item['amount'];
      final amount = (amountRaw is num) ? amountRaw.toInt() : 0;

      final created = item['created_at'] ?? item['timestamp'];
      DateTime ts;
      if (created is String) {
        ts = DateTime.tryParse(created) ?? DateTime.now();
      } else {
        ts = DateTime.now();
      }

      final title = (item['title'] ??
              item['reason_display'] ??
              item['reason'] ??
              '')
          .toString();
      final detail =
          (item['description'] ?? item['detail'] ?? '').toString();

      histories.add(
        PointHistory(
          timestamp: ts,
          title: title.isNotEmpty ? title : '포인트 내역',
          detail: detail,
          amount: amount,
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      _status = PointsStatus(
        totalPoints: totalPoints,
        todayEarned: todayEarned,
        dailyLimit: dailyLimit,
        histories: histories,
      );
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading || _status == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final status = _status!;
    final progress = status.dailyLimit == 0
        ? 0.0
        : (status.todayEarned / status.dailyLimit)
            .clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 포인트'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [DotoriTheme.background, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _load,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 요약 카드 (도토리 감성)
                _buildSummaryCard(status, progress),

                const SizedBox(height: 20),

                // 포인트 모으러 가기
                _sectionCard(
                  title: '포인트 모으기',
                  caption:
                      '퀴즈 정답 또는 역할극 5분 이상 진행 시 포인트를 받을 수 있어요.',
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.quiz_outlined),
                          label: const Text('사고력 퀴즈'),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/quiz'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('역할극 연습'),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/roleplay'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                            side: BorderSide(
                              color:
                                  DotoriTheme.brown.withOpacity(0.5),
                              width: 1.2,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            foregroundColor: DotoriTheme.brownDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 안내
                Text(
                  '포인트 이용 안내',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: DotoriTheme.brownDark,
                  ),
                ),
                const SizedBox(height: 8),
                _infoBubble(theme),

                const SizedBox(height: 24),

                // 내역
                Text(
                  '적립 / 사용 내역',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: DotoriTheme.brownDark,
                  ),
                ),
                const SizedBox(height: 12),

                if (status.histories.isEmpty)
                  Text(
                    '아직 적립된 포인트가 없습니다.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  )
                else
                  ...status.histories.map(
                    (h) => Container(
                      margin:
                          const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        title: Text(
                          h.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '${h.detail}\n${h.timestamp.toLocal().toString().substring(0, 16)}',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(
                              height: 1.3,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        trailing:
                            _buildAmountPill(h.amount, theme),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────── UI 헬퍼 ────────

  Widget _buildSummaryCard(PointsStatus status, double progress) {
    return Card(
      elevation: 0,
      color: DotoriTheme.brownDark.withOpacity(0.96),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 아이콘 + 타이틀
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '보유 포인트',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '오늘도 한 걸음 성장 중이에요',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            //  총 보유 포인트 (DB balance)
            Text(
              '${status.totalPoints} P',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '오늘 적립 ${status.todayEarned} / ${status.dailyLimit} P',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt,
                          size: 14, color: Color(0xFFFFF176)),
                      SizedBox(width: 4),
                      Text(
                        '하루 최대 100P',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.white.withOpacity(0.18),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(
                  Color(0xFFFFD54F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 공통 섹션 카드
  Widget _sectionCard({
    required String title,
    required String caption,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding:
            const EdgeInsets.fromLTRB(16, 14, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: DotoriTheme.brownDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              caption,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _infoBubble(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 14,
            color: Color(0x14000000),
          ),
        ],
      ),
      padding:
          const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Text(
        '• 포인트는 1점당 1원으로 계산됩니다.\n'
        '• 멤버십 결제 시 차감하거나 포인트로만 결제할 수 있습니다.\n'
        '• 하루 최대 적립 가능 포인트는 100점입니다.\n'
        '• 포인트 적립 내역은 아래에서 확인할 수 있습니다.',
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.grey.shade800,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildAmountPill(int amount, ThemeData theme) {
    final isPlus = amount >= 0;
    final bg = isPlus
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFEBEE);
    final fg =
        isPlus ? const Color(0xFF2E7D32) : theme.colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${isPlus ? '+' : ''}$amount P',
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}
