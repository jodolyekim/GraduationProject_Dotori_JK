// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

// import '../../services/analytics_api_service.dart';

// class AdminAnalyticsScreen extends StatefulWidget {
//   const AdminAnalyticsScreen({super.key});

//   @override
//   State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
// }

// class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
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
//       data = await AnalyticsApiService.instance.getAdminAnalytics();
//     } catch (e) {
//       debugPrint("Admin analytics error: $e");
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Scaffold(
//           body: Center(child: CircularProgressIndicator()));
//     }

//     if (data == null) {
//       return const Scaffold(
//         body: Center(child: Text("데이터 없음")),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("관리자 분석 대시보드")),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           buildActiveUsers(),
//           const SizedBox(height: 20),
//           buildFeatureUsage(),
//           const SizedBox(height: 20),
//           buildMembershipStats(),
//         ],
//       ),
//     );
//   }

//   Widget buildActiveUsers() {
//     final a = data!["active_users"];

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("활성 사용자 수",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text("DAU: ${a["dau"]}"),
//             Text("WAU: ${a["wau"]}"),
//             Text("MAU: ${a["mau"]}"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildFeatureUsage() {
//     final u = data!["usage"];

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("기능별 사용량",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text("요약 호출: ${u["summary"]}"),
//             Text("AI 디텍터: ${u["detector"]}"),
//             Text("퀴즈 풀이 수: ${u["quiz"]}"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildMembershipStats() {
//     final m = data!["membership"];

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("멤버십 통계",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text("최근 30일 매출: ${m["revenue_30days"]}원"),
//             const SizedBox(height: 10),

//             const Text("플랜별 가입자 수"),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: (m["plans"] as List).map((e) {
//                 return Text("${e["plan__code"]}: ${e["count"]}명");
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/screens/analytics/admin_analytics_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../services/analytics_api_service.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
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
      data = await AnalyticsApiService.instance.getAdminAnalytics();
    } catch (e) {
      debugPrint("Admin analytics error: $e");
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF222B45),
          foregroundColor: Colors.white,
          title: const Text("관리자 분석 대시보드"),
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (data == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF222B45),
          foregroundColor: Colors.white,
          title: const Text("관리자 분석 대시보드"),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("데이터 없음"),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: load,
                child: const Text("다시 불러오기"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF222B45),
        foregroundColor: Colors.white,
        title: const Text("관리자 분석 대시보드"),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            _buildHeaderSummary(),
            const SizedBox(height: 20),
            _buildActiveUsersCard(),
            const SizedBox(height: 20),
            _buildFeatureUsageCard(),
            const SizedBox(height: 20),
            _buildMembershipStatsCard(),
          ],
        ),
      ),
    );
  }

  // 상단 요약 (DAU / 최근 30일 매출 등 간단 숫자 하이라이트)
  Widget _buildHeaderSummary() {
    final a = data!["active_users"] ?? {};
    final m = data!["membership"] ?? {};

    final dau = a["dau"] ?? 0;
    final wau = a["wau"] ?? 0;
    final mau = a["mau"] ?? 0;
    final revenue = m["revenue_30days"] ?? 0;

    return Row(
      children: [
        Expanded(
          child: _smallStatCard(
            title: "일간 활성 사용자",
            value: "$dau 명",
            subtitle: "DAU",
            icon: Icons.person_outline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _smallStatCard(
            title: "최근 30일 매출",
            value: "${revenue}원",
            subtitle: "멤버십 결제 기준",
            icon: Icons.monetization_on_outlined,
          ),
        ),
      ],
    );
  }

  Widget _smallStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A60E8), Color(0xFF1E3AC9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 14,
            offset: Offset(0, 6),
            color: Color(0x33000000),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
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
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  //  활성 사용자 카드 
  Widget _buildActiveUsersCard() {
    final a = data!["active_users"] ?? {};
    final dau = (a["dau"] ?? 0) as num;
    final wau = (a["wau"] ?? 0) as num;
    final mau = (a["mau"] ?? 0) as num;

    final maxVal = [dau, wau, mau].fold<num>(0, (p, c) => c > p ? c : p);
    final maxY = (maxVal == 0 ? 10 : maxVal * 1.2).toDouble();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "활성 사용자 수",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              "DAU / WAU / MAU 지표로 서비스 활성을 확인해요.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value == maxY) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('DAU', style: TextStyle(fontSize: 11));
                            case 1:
                              return const Text('WAU', style: TextStyle(fontSize: 11));
                            case 2:
                              return const Text('MAU', style: TextStyle(fontSize: 11));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: dau.toDouble(),
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFF4A60E8),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: wau.toDouble(),
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFF00C48C),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: mau.toDouble(),
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFFFFA726),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  기능별 사용량 카드 
  Widget _buildFeatureUsageCard() {
    final u = data!["usage"] ?? {};
    final summary = (u["summary"] ?? 0) as num;
    final detector = (u["detector"] ?? 0) as num;
    final quiz = (u["quiz"] ?? 0) as num;

    final total = summary + detector + quiz;
    final maxVal = [summary, detector, quiz].fold<num>(0, (p, c) => c > p ? c : p);
    final maxY = (maxVal == 0 ? 10 : maxVal * 1.2).toDouble();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "기능별 사용량",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              total == 0
                  ? "아직 사용 데이터가 충분하지 않습니다."
                  : "어떤 기능이 많이 쓰이는지 한눈에 확인해요.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value == maxY) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('요약', style: TextStyle(fontSize: 11));
                            case 1:
                              return const Text('디텍터', style: TextStyle(fontSize: 11));
                            case 2:
                              return const Text('퀴즈', style: TextStyle(fontSize: 11));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: summary.toDouble(),
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFF4A60E8),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: detector.toDouble(),
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFF00C48C),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: quiz.toDouble(),
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xFFFFA726),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  멤버십 통계 카드 
  Widget _buildMembershipStatsCard() {
    final m = data!["membership"] ?? {};
    final revenue = (m["revenue_30days"] ?? 0).toString();
    final plans = (m["plans"] as List?) ?? [];

    // 막대 차트용 데이터
    final planCodes = <String>[];
    final planCounts = <int>[];

    for (final e in plans) {
      final code = (e["plan__code"] ?? '-') as String;
      final count = (e["count"] ?? 0) as int;
      planCodes.add(code);
      planCounts.add(count);
    }

    final maxVal =
        planCounts.fold<int>(0, (prev, c) => c > prev ? c : prev);
    final maxY = (maxVal == 0 ? 5 : (maxVal * 1.3)).toDouble();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "멤버십 통계",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              "최근 30일 매출: ${revenue}원",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "플랜별 가입자 수",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (planCodes.isEmpty)
              Text(
                "플랜 가입 정보가 아직 없습니다.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              )
            else
              SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            if (value == 0 || value == maxY) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= planCodes.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                planCodes[idx],
                                style: const TextStyle(fontSize: 11),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(planCodes.length, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: planCounts[i].toDouble(),
                            width: 16,
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0xFF4A60E8),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
