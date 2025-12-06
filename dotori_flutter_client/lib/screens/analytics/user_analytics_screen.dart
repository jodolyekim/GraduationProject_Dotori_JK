// // lib/screens/analytics/user_analytics_screen.dart
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../../../services/analytics_api_service.dart';

// class UserAnalyticsScreen extends StatefulWidget {
//   const UserAnalyticsScreen({super.key});

//   @override
//   State<UserAnalyticsScreen> createState() => _UserAnalyticsScreenState();
// }

// class _UserAnalyticsScreenState extends State<UserAnalyticsScreen> {
//   final _api = AnalyticsApiService.instance;

//   bool _loading = true;
//   Map<String, dynamic>? data;

//   @override
//   void initState() {
//     super.initState();
//     load();
//   }

//   Future<void> load() async {
//     setState(() => _loading = true);
//     try {
//       final res = await _api.getUserAnalytics();
//       data = Map<String, dynamic>.from(res as Map);
//     } catch (e) {
//       debugPrint("Error loading analytics: $e");
//       data = null;
//     } finally {
//       if (mounted) {
//         setState(() => _loading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("나의 활동 분석")),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (data == null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("나의 활동 분석")),
//         body: const Center(child: Text("데이터 불러오기 실패")),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("나의 활동 분석")),
//       body: RefreshIndicator(
//         onRefresh: load,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             buildSummaryUsageCard(),   //  새로 추가된 카드
//             const SizedBox(height: 20),
//             buildSummaryCard(),
//             const SizedBox(height: 20),
//             buildQuizCard(),
//             const SizedBox(height: 20),
//             buildPatternCard(),
//             const SizedBox(height: 20),
//             buildReportCard(),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================================================================
//   //  0) 요약 사용 분석 (NEW)
//   // ================================================================
//   Widget buildSummaryUsageCard() {
//     final suAny = data!["summary_usage"];
//     if (suAny is! Map) {
//       return const SizedBox.shrink();
//     }
//     final Map su = suAny;

//     final enabled = su["enabled"] == true;
//     if (!enabled) return const SizedBox.shrink();

//     final Map diff = (su["difficulty_counts"] is Map)
//         ? su["difficulty_counts"] as Map
//         : {};

//     final elem = _asInt(diff["ELEMENTARY"]);
//     final sec = _asInt(diff["SECONDARY"]);
//     final adult = _asInt(diff["ADULT"]);
//     final total = _asInt(su["total"]);

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "요약 사용 분석",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             Text("총 요약 횟수 (최근 30일): $total회"),
//             const SizedBox(height: 10),

//             SizedBox(
//               height: 180,
//               child: BarChart(
//                 BarChartData(
//                   titlesData: FlTitlesData(
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(showTitles: true),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           switch (value.toInt()) {
//                             case 0:
//                               return const Text("초등");
//                             case 1:
//                               return const Text("중고등");
//                             case 2:
//                               return const Text("성인");
//                             default:
//                               return const SizedBox.shrink();
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                   barGroups: [
//                     BarChartGroupData(
//                       x: 0,
//                       barRods: [
//                         BarChartRodData(
//                             toY: elem.toDouble(), color: Colors.blue)
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 1,
//                       barRods: [
//                         BarChartRodData(
//                             toY: sec.toDouble(), color: Colors.green)
//                       ],
//                     ),
//                     BarChartGroupData(
//                       x: 2,
//                       barRods: [
//                         BarChartRodData(
//                             toY: adult.toDouble(), color: Colors.orange)
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 10),
//             Text("초등 난이도: $elem회"),
//             Text("중고등 난이도: $sec회"),
//             Text("성인 난이도: $adult회"),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================================================================
//   // 1) 롤플레잉 분석
//   // ================================================================
//   Widget buildSummaryCard() {
//     final rpAny = data!["roleplay"];
//     final Map rp = (rpAny is Map) ? rpAny : <String, dynamic>{};

//     final totalTurns = _asInt(rp["total_turns"]);
//     final avgLenNum = _asNum(rp["avg_user_utterance_len"]);
//     final avgLen = avgLenNum?.toDouble() ?? 0.0;

//     final List scenarioStats =
//         (rp["scenario_stats"] is List) ? rp["scenario_stats"] as List : const [];

//     final Map favorite =
//         (rp["favorite_scenario"] is Map) ? rp["favorite_scenario"] as Map : {};

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "롤플레잉 분석",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text("총 대화 턴 수: ${totalTurns}턴"),
//             Text("평균 사용자 발화 길이: ${avgLen.toStringAsFixed(1)} 글자"),
//             const SizedBox(height: 12),

//             if (favorite.isNotEmpty) ...[
//               const Text("가장 자주 연습한 시나리오",
//                   style: TextStyle(fontWeight: FontWeight.w600)),
//               const SizedBox(height: 4),
//               Text("${(favorite["title"] ?? "")} (${_asInt(favorite["count"])}회)"),
//               const SizedBox(height: 12),
//             ],

//             if (scenarioStats.isNotEmpty)
//               Column(
//                 children: scenarioStats.map<Widget>((e) {
//                   final Map m = (e is Map) ? e : <String, dynamic>{};
//                   final title = (m["title"] ?? "") as String;
//                   final count = _asInt(m["count"]);
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 2),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(child: Text(title)),
//                         Text("${count}회"),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               )
//             else
//               const Text("아직 롤플레잉 기록이 없습니다."),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================================================================
//   // 2) 퀴즈 분석
//   // ================================================================
//   Widget buildQuizCard() {
//     final qAny = data!["quiz"];
//     final Map q = (qAny is Map) ? qAny : <String, dynamic>{};

//     final total = _asInt(q["total_solved"] ?? q["total"]);
//     final correctTotal = _asInt(q["correct_total"]);
//     final solved7 = _asInt(q["solved_7"]);
//     final correct7 = _asInt(q["correct_7"]);
//     final solved30 = _asInt(q["solved_30"]);
//     final correct30 = _asInt(q["correct_30"]);

//     final List typeAcc =
//         (q["type_accuracy"] is List) ? q["type_accuracy"] as List : const [];

//     final weakest =
//         (q["weakest"] is Map) ? q["weakest"] as Map : <String, dynamic>{};

//     final recent7Rate =
//         solved7 == 0 ? 0.0 : (correct7 / (solved7 == 0 ? 1 : solved7) * 100);
//     final recent30Rate =
//         solved30 == 0 ? 0.0 : (correct30 / (solved30 == 0 ? 1 : solved30) * 100);

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "퀴즈 / 사고력 분석",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text("총 푼 문제 수(최근 30일): $total"),
//             Text("전체 정답 수(최근 30일): $correctTotal"),
//             Text("최근 7일 정답률: ${recent7Rate.toStringAsFixed(1)}%"),
//             Text("최근 30일 정답률: ${recent30Rate.toStringAsFixed(1)}%"),
//             const SizedBox(height: 15),

//             if (typeAcc.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: typeAcc.map<Widget>((e) {
//                   final Map m = (e is Map) ? e : <String, dynamic>{};
//                   final type = (m["quiz_type"] ?? "") as String;
//                   final solved = _asInt(m["solved"]);
//                   final correct = _asInt(m["correct"]);
//                   final rate = solved == 0
//                       ? 0.0
//                       : (correct / (solved == 0 ? 1 : solved) * 100);

//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(type),
//                         Text("${rate.toStringAsFixed(1)}%"),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),

//             const SizedBox(height: 15),
//             Text(
//               "가장 약한 유형: ${weakest["quiz_type"] ?? "없음"}",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================================================================
//   // 3) 접속 패턴 분석
//   // ================================================================
//   Widget buildPatternCard() {
//     final pAny = data!["usage_pattern"];
//     final Map p = (pAny is Map) ? pAny : <String, dynamic>{};

//     final List weekday =
//         (p["weekday"] is List) ? p["weekday"] as List : const [];
//     final List hour = (p["hour"] is List) ? p["hour"] as List : const [];
//     final summaryLine = (p["summary_line"] ?? "") as String? ?? "";

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "이용 패턴 분석",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             if (summaryLine.isNotEmpty) ...[
//               Text(summaryLine),
//               const SizedBox(height: 16),
//             ],

//             const Text("요일별 접속 횟수"),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 150,
//               child: BarChart(
//                 BarChartData(
//                   titlesData: FlTitlesData(show: true),
//                   barGroups: weekday.map<BarChartGroupData>((w) {
//                     final Map m = (w is Map) ? w : <String, dynamic>{};
//                     final x = _asInt(m["weekday"]);
//                     final y = _asNum(m["count"])?.toDouble() ?? 0.0;
//                     return BarChartGroupData(
//                       x: x,
//                       barRods: [
//                         BarChartRodData(
//                           toY: y,
//                           color: Colors.blue,
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             const Text("시간대별 접속 횟수"),
//             SizedBox(
//               height: 150,
//               child: BarChart(
//                 BarChartData(
//                   titlesData: FlTitlesData(show: false),
//                   barGroups: hour.map<BarChartGroupData>((h) {
//                     final Map m = (h is Map) ? h : <String, dynamic>{};
//                     final x = _asInt(m["hour"]);
//                     final y = _asNum(m["count"])?.toDouble() ?? 0.0;
//                     return BarChartGroupData(
//                       x: x,
//                       barRods: [
//                         BarChartRodData(
//                           toY: y,
//                           color: Colors.orange,
//                         ),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================================================================
//   // 4) 리포트 카드
//   // ================================================================
//   Widget buildReportCard() {
//     final rAny = data!["report"];
//     final Map r = (rAny is Map) ? rAny : <String, dynamic>{};

//     final quizInc = _asInt(r["quiz_increase"]);
//     final roleplayInc = _asInt(r["roleplay_increase"]);
//     final streakDays = _asInt(r["streak_days"]);
//     final List cards = (r["cards"] is List) ? r["cards"] as List : const [];

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "칭찬 · 리포트 카드",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             Text("지난달보다 퀴즈 ${quizInc}개 더 풀었어요 👏"),
//             Text("지난달보다 롤플레잉 ${roleplayInc}턴 더 연습했어요 👍"),
//             Text("연속 접속일: ${streakDays}일"),

//             if (cards.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: cards
//                     .map<Widget>((e) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 2),
//                           child: Text("- ${e.toString()}"),
//                         ))
//                     .toList(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================================================================
//   // 헬퍼
//   // ================================================================
//   int _asInt(dynamic v) {
//     if (v is int) return v;
//     if (v is num) return v.toInt();
//     if (v is String) return int.tryParse(v) ?? 0;
//     return 0;
//   }

//   num? _asNum(dynamic v) {
//     if (v is num) return v;
//     if (v is String) return num.tryParse(v);
//     return null;
//   }
// }

// lib/screens/analytics/user_analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dotori_client/theme/app_theme.dart';
import 'package:dotori_client/widgets/dotori_button.dart';
import '../../../services/analytics_api_service.dart';

class UserAnalyticsScreen extends StatefulWidget {
  const UserAnalyticsScreen({super.key});

  @override
  State<UserAnalyticsScreen> createState() => _UserAnalyticsScreenState();
}

class _UserAnalyticsScreenState extends State<UserAnalyticsScreen> {
  final _api = AnalyticsApiService.instance;

  bool _loading = true;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => _loading = true);
    try {
      final res = await _api.getUserAnalytics();
      data = Map<String, dynamic>.from(res as Map);
    } catch (e) {
      debugPrint('Error loading analytics: $e');
      data = null;
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 공통 배경 + AppBar (A 방식)
    return Scaffold(
      backgroundColor: DotoriTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '나의 활동 분석',
          style: TextStyle(
            color: DotoriTheme.brownDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFDF5EC),
              Colors.grey.shade100,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 40,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              const Text(
                '데이터를 불러오는 중 문제가 발생했어요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '네트워크 상태를 확인한 뒤 다시 시도해 주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              DotoriButton(
                text: '다시 불러오기',
                onPressed: load,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _buildTopSummaryRow(),
          const SizedBox(height: 18),
          _buildRoleplayCard(),
          const SizedBox(height: 18),
          _buildQuizCard(),
          const SizedBox(height: 18),
          _buildPatternCard(),
          const SizedBox(height: 18),
          _buildReportCard(),
        ],
      ),
    );
  }

  //  상단 하이라이트 (롤플 / 퀴즈) 

  Widget _buildTopSummaryRow() {
    final rpAny = data!['roleplay'];
    final Map rp = (rpAny is Map) ? rpAny : <String, dynamic>{};
    final totalTurns = _asInt(rp['total_turns']);

    final qAny = data!['quiz'];
    final Map q = (qAny is Map) ? qAny : <String, dynamic>{};
    final totalQuiz = _asInt(q['total_solved'] ?? q['total']);

    return Row(
      children: [
        Expanded(
          child: _smallHighlightCard(
            icon: Icons.chat_bubble_outline,
            title: '롤플레잉 턴 수',
            value: '${totalTurns}턴',
            subtitle: '최근 30일 기준',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _smallHighlightCard(
            icon: Icons.quiz_outlined,
            title: '푼 퀴즈',
            value: '$totalQuiz개',
            subtitle: '최근 30일 기준',
          ),
        ),
      ],
    );
  }

  Widget _smallHighlightCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8CBAA), Color(0xFFB9874A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: DotoriTheme.softShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.95), size: 20),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  1) 롤플레잉 분석 

  Widget _buildRoleplayCard() {
    final rpAny = data!['roleplay'];
    final Map rp = (rpAny is Map) ? rpAny : <String, dynamic>{};

    final totalTurns = _asInt(rp['total_turns']);
    final avgLenNum = _asNum(rp['avg_user_utterance_len']);
    final avgLen = avgLenNum?.toDouble() ?? 0.0;

    final List scenarioStats =
        (rp['scenario_stats'] is List) ? rp['scenario_stats'] as List : const [];

    final Map favorite =
        (rp['favorite_scenario'] is Map) ? rp['favorite_scenario'] as Map : {};

    return Card(
      elevation: 0,
      color: DotoriTheme.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '롤플레잉 분석',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              '상황 역할극을 얼마나, 어떤 상황에서 연습했는지 보여줘요.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _smallStatChip('총 턴 수', '${totalTurns}턴'),
                const SizedBox(width: 8),
                _smallStatChip(
                  '평균 내 발화 길이',
                  '${avgLen.toStringAsFixed(1)}글자',
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (favorite.isNotEmpty) ...[
              const Text(
                '가장 많이 연습한 시나리오',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                '${(favorite['title'] ?? '')} (${_asInt(favorite['count'])}회)',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
            ],
            if (scenarioStats.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: scenarioStats.map<Widget>((e) {
                  final Map m = (e is Map) ? e : <String, dynamic>{};
                  final title = (m['title'] ?? '') as String;
                  final count = _asInt(m['count']);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${count}회',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: DotoriTheme.brownDark,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
            else
              const Text('아직 롤플레잉 기록이 없습니다.'),
          ],
        ),
      ),
    );
  }

  Widget _smallStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: DotoriTheme.brownLight.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontSize: 11, color: DotoriTheme.brownDark),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: DotoriTheme.brownDark,
            ),
          ),
        ],
      ),
    );
  }

  //  2) 퀴즈 / 사고력 분석 

  Widget _buildQuizCard() {
    final qAny = data!['quiz'];
    final Map q = (qAny is Map) ? qAny : <String, dynamic>{};

    final total = _asInt(q['total_solved'] ?? q['total']);
    final correctTotal = _asInt(q['correct_total']);
    final solved7 = _asInt(q['solved_7']);
    final correct7 = _asInt(q['correct_7']);
    final solved30 = _asInt(q['solved_30']);
    final correct30 = _asInt(q['correct_30']);

    final List typeAcc =
        (q['type_accuracy'] is List) ? q['type_accuracy'] as List : const [];

    final weakest =
        (q['weakest'] is Map) ? q['weakest'] as Map : <String, dynamic>{};

    final recent7Rate =
        solved7 == 0 ? 0.0 : (correct7 / (solved7 == 0 ? 1 : solved7) * 100);
    final recent30Rate =
        solved30 == 0 ? 0.0 : (correct30 / (solved30 == 0 ? 1 : solved30) * 100);

    return Card(
      elevation: 0,
      color: DotoriTheme.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '퀴즈 · 사고력 분석',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              '사고력 퀴즈를 통해 얼마나 연습하고 있는지 볼 수 있어요.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _smallStatChip('최근 30일 푼 문제', '$total개'),
                const SizedBox(width: 8),
                _smallStatChip('정답 수', '$correctTotal개'),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '최근 7일 정답률: ${recent7Rate.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 13),
            ),
            Text(
              '최근 30일 정답률: ${recent30Rate.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            if (typeAcc.isNotEmpty) ...[
              const Text(
                '문제 유형별 정답률',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: typeAcc.map<Widget>((e) {
                  final Map m = (e is Map) ? e : <String, dynamic>{};
                  final type = (m['quiz_type'] ?? '') as String;
                  final solved = _asInt(m['solved']);
                  final correct = _asInt(m['correct']);
                  final rate =
                      solved == 0 ? 0.0 : (correct / (solved == 0 ? 1 : solved) * 100);

                  final label = _quizTypeLabel(type);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${rate.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: DotoriTheme.brownDark,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              '가장 약한 유형: ${_quizTypeLabel(weakest['quiz_type'] as String? ?? '없음')}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _quizTypeLabel(String code) {
    switch (code) {
      case 'SENTENCE_MEANING':
        return '문장 의미 찾기';
      case 'SITUATION_TEXT':
        return '상황에 맞는 글 선택';
      case 'SITUATION_IMAGE':
        return '상황에 맞는 그림 선택';
      case '없음':
        return '없음';
      default:
        return code; // 알 수 없는 코드는 그대로 노출
    }
  }

  //  3) 이용 패턴 분석 (그래프 강조) 

  Widget _buildPatternCard() {
    final pAny = data!['usage_pattern'];
    final Map p = (pAny is Map) ? pAny : <String, dynamic>{};

    final List weekday =
        (p['weekday'] is List) ? p['weekday'] as List : const [];
    final List hour = (p['hour'] is List) ? p['hour'] as List : const [];
    final summaryLine = (p['summary_line'] ?? '') as String? ?? '';

    // 요일 차트용 max
    final weekdayCounts =
        weekday.map<num>((w) => _asNum((w is Map ? w['count'] : null)) ?? 0).toList();
    final weekdayMax =
        weekdayCounts.isEmpty ? 5 : weekdayCounts.reduce((a, b) => a > b ? a : b);
    final weekdayMaxY = (weekdayMax == 0 ? 5 : (weekdayMax * 1.3)).toDouble();

    // 시간대 차트용 max
    final hourCounts =
        hour.map<num>((h) => _asNum((h is Map ? h['count'] : null)) ?? 0).toList();
    final hourMax =
        hourCounts.isEmpty ? 5 : hourCounts.reduce((a, b) => a > b ? a : b);
    final hourMaxY = (hourMax == 0 ? 5 : (hourMax * 1.3)).toDouble();

    return Card(
      elevation: 0,
      color: DotoriTheme.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '이용 패턴 분석',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              '어느 요일·시간에 많이 접속하는지 확인해보세요.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            if (summaryLine.isNotEmpty) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: DotoriTheme.brownLight.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  summaryLine,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: DotoriTheme.brownDark,
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
            const Text(
              '요일별 접속 횟수',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 190,
              child: BarChart(
                BarChartData(
                  maxY: weekdayMaxY,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.brown.shade700,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final idx = group.x;
                        const labels = ['월', '화', '수', '목', '금', '토', '일'];
                        final day =
                            (idx >= 1 && idx <= 7) ? labels[idx - 1] : '';
                        return BarTooltipItem(
                          '$day요일\n${rod.toY.toInt()}회',
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: weekdayMaxY <= 5 ? 1 : (weekdayMaxY / 4),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.brown.withOpacity(0.07),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.brown.withOpacity(0.4),
                        width: 1,
                      ),
                      left: BorderSide(
                        color: Colors.brown.withOpacity(0.4),
                        width: 1,
                      ),
                      right: const BorderSide(color: Colors.transparent),
                      top: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (v, meta) {
                          if (v == 0 || v == weekdayMaxY) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            v.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const labels = ['월', '화', '수', '목', '금', '토', '일'];
                          final idx = value.toInt();
                          if (idx < 1 || idx > 7) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              labels[idx - 1],
                              style: const TextStyle(
                                fontSize: 11,
                                color: DotoriTheme.brownDark,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: weekday.map<BarChartGroupData>((w) {
                    final Map m = (w is Map) ? w : <String, dynamic>{};
                    final x = _asInt(m['weekday']);
                    final y = _asNum(m['count'])?.toDouble() ?? 0.0;
                    return BarChartGroupData(
                      x: x,
                      barRods: [
                        BarChartRodData(
                          toY: y,
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFFB6783A),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '시간대별 접속 횟수',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 190,
              child: BarChart(
                BarChartData(
                  maxY: hourMaxY,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.brown.shade700,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final h = group.x;
                        return BarTooltipItem(
                          '$h시\n${rod.toY.toInt()}회',
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: hourMaxY <= 5 ? 1 : (hourMaxY / 4),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.brown.withOpacity(0.07),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.brown.withOpacity(0.4),
                        width: 1,
                      ),
                      left: BorderSide(
                        color: Colors.brown.withOpacity(0.4),
                        width: 1,
                      ),
                      right: const BorderSide(color: Colors.transparent),
                      top: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 20,
                        getTitlesWidget: (value, meta) {
                          final h = value.toInt();
                          if (h % 3 != 0) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '$h시',
                              style: const TextStyle(
                                fontSize: 9,
                                color: DotoriTheme.brownDark,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: hour.map<BarChartGroupData>((h) {
                    final Map m = (h is Map) ? h : <String, dynamic>{};
                    final x = _asInt(m['hour']);
                    final y = _asNum(m['count'])?.toDouble() ?? 0.0;
                    return BarChartGroupData(
                      x: x,
                      barRods: [
                        BarChartRodData(
                          toY: y,
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                          color: const Color(0xFFE0913D),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  4) 칭찬 · 리포트 카드 

  Widget _buildReportCard() {
    final rAny = data!['report'];
    final Map r = (rAny is Map) ? rAny : <String, dynamic>{};

    final quizInc = _asInt(r['quiz_increase']);
    final roleplayInc = _asInt(r['roleplay_increase']);
    final streakDays = _asInt(r['streak_days']);
    final List cards = (r['cards'] is List) ? r['cards'] as List : const [];

    return Card(
      elevation: 0,
      color: DotoriTheme.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '칭찬 · 리포트 카드',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              '최근 한 달간의 성장 포인트를 정리했어요.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            Text('지난달보다 퀴즈 ${quizInc}개 더 풀었어요 👏'),
            Text('지난달보다 롤플레잉 ${roleplayInc}턴 더 연습했어요 👍'),
            Text('연속 접속일: ${streakDays}일'),
            const SizedBox(height: 10),
            if (cards.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cards
                    .map<Widget>(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('• ${e.toString()}'),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  //  헬퍼 

  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  num? _asNum(dynamic v) {
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }
}
