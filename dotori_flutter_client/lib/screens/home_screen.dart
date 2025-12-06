<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotori_client/services/auth_service.dart';
=======
// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:dotori_client/services/auth_service.dart';
import 'package:dotori_client/services/membership_api_service.dart';

import '../widgets/feature_carousel_item.dart'; // FeatureCarousel + FeatureItem
import '../widgets/home_section_title.dart';

// 기능 페이지들
import 'detector_home_screen.dart';
import 'quiz_screen.dart';
import 'roleplay_screen.dart';
import 'my_page_screen.dart';
import 'membership_screen.dart';
import 'point_screen.dart';
import 'membership_overview_screen.dart';
import 'analytics/user_analytics_screen.dart';
>>>>>>> clean-summary-2_flutter

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

<<<<<<< HEAD
class _HomeScreenState extends State<HomeScreen> {
  String? _meText;
  String? _error;
  bool _loading = false;

  Future<void> _loadMe() async {
    setState(() {
      _loading = true;
      _error = null;
      _meText = null;
    });
    try {
      final me = await AuthService().me();
      setState(() => _meText = me.toString());
    } catch (e) {
      setState(() => _error = '불러오기 실패: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
=======
class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _membershipApi = MembershipApiService();

  String _displayName = "";
  String _profileImage = "";
  String _membershipName = "";

  int? _remainingSummary;
  int? _remainingDetector;

  bool _loading = true;

  late AnimationController _fadeCtrl;
  late AnimationController _scaleCtrl;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeIn = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _scaleIn = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOutBack),
    );

    _loadAll();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    try {
      final me = await AuthService().me();
      final display = me?["display_name"] ?? me?["username"] ?? "사용자";
      final profileImg = me?["profile_image_url"] ?? "";

      final membership = await _membershipApi.getMyMembership();
      final planName = membership["plan"]?["name"] ?? "무료 회원";

      final usage = await _membershipApi.getOverview();
      print("OVERVIEW API RESPONSE (HomeScreen) = $usage");

      final remainingSummary = usage?["summary"]?["remaining"];
      final remainingDetector = usage?["detector"]?["remaining"];

      setState(() {
        _displayName = display;
        _profileImage = profileImg;
        _membershipName = planName;
        _remainingSummary = remainingSummary;
        _remainingDetector = remainingDetector;
        _loading = false;
      });

      _fadeCtrl.forward();
      _scaleCtrl.forward();
    } catch (e) {
      setState(() => _loading = false);
>>>>>>> clean-summary-2_flutter
    }
  }

  Future<void> _logout() async {
    await AuthService().logout();
<<<<<<< HEAD
    // 자동로그인까지 끄고 싶다면 아래 주석 해제:
    // final sp = await SharedPreferences.getInstance();
    // await sp.setBool('auto_login', false);

=======
>>>>>>> clean-summary-2_flutter
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final dense = const EdgeInsets.symmetric(vertical: 10);
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈 (로그인됨)'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: '로그아웃',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _loadMe,
              child: Padding(
                padding: dense,
                child: _loading
                    ? const SizedBox(
                        width: 22, height: 22, child: CircularProgressIndicator())
                    : const Text('/api/auth/me 호출'),
              ),
            ),
            const SizedBox(height: 16),
            if (_meText != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _meText!,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
=======
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      // AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: FadeTransition(
          opacity: _fadeIn,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/dotori_logo.png', width: 42),
                const SizedBox(width: 10),
                ShaderMask(
                  shaderCallback: (b) => const LinearGradient(
                    colors: [Color(0xFF7A4F23), Color(0xFFB07A4E)],
                  ).createShader(b),
                  child: const Text(
                    '도토리',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Color(0xFF7A4F23)),
              ),
            ],
          ),
        ),
      ),

      //  Body 
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeIn,
              child: ScaleTransition(
                scale: _scaleIn,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _profileCard(),
                      const SizedBox(height: 32),

                      // 주요 기능 캐러셀
                      const HomeSectionTitle('주요 기능'),
                      const SizedBox(height: 16),
                      FeatureCarousel(
                        items: [
                          FeatureItem(
                            icon: Icons.summarize,
                            title: '글 요약',
                            subtitle: '난이도별 요약과\n어려운 단어 설명까지!',
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/summary',
                            ).then((_) {
                              //  글 요약 화면에서 돌아오면 다시 사용량 갱신
                              _loadAll();
                            }),
                          ),
                          FeatureItem(
                            icon: Icons.search_rounded,
                            title: 'AI 디텍터',
                            subtitle: '텍스트·이미지·영상이\nAI인지 분석해요',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DetectorHomeScreen(),
                              ),
                            ).then((_) {
                              //  디텍터에서 돌아오면 다시 사용량 갱신
                              _loadAll();
                            }),
                          ),
                          FeatureItem(
                            icon: Icons.quiz,
                            title: '문해력 퀴즈',
                            subtitle: '문해력과 사고력을\n키워주는 문제들이에요',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const QuizScreen(),
                              ),
                            ).then((_) {
                              // 퀴즈는 지금 카드에 직접 연동되는 건 없지만,
                              // 나중에 포인트/활동 연동을 위해 같이 갱신해둬도 나쁠 건 없음
                              _loadAll();
                            }),
                          ),
                          FeatureItem(
                            icon: Icons.record_voice_over,
                            title: 'AI 역할극',
                            subtitle: '상황별 대처를\nAI와 연습해요',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RoleplayScreen(),
                              ),
                            ).then((_) {
                              _loadAll();
                            }),
                          ),
                          FeatureItem(
                            icon: Icons.star,
                            title: '멤버십',
                            subtitle: '도토리 기능을\n넉넉하게 이용해요',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MembershipScreen(),
                              ),
                            ).then((_) {
                              // 멤버십 변경 후 돌아오면 요금제/한도/남은 횟수 다 바뀔 수 있음
                              _loadAll();
                            }),
                          ),
                          FeatureItem(
                            icon: Icons.person,
                            title: '마이페이지',
                            subtitle: '내 정보를\n한눈에 관리해요',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MyPageScreen(),
                              ),
                            ).then((_) {
                              _loadAll();
                            }),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // 이번 주 활동
                      const HomeSectionTitle('이번 주 활동'),
                      const SizedBox(height: 14),
                      _weeklyActivityCard(),

                      const SizedBox(height: 40),

                      // 추가 기능
                      const HomeSectionTitle('추가 기능'),
                      const SizedBox(height: 14),
                      _extraFeatures(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  //  프로필 카드 
  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFFFDF6EC), Color(0xFFFFFCF7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 38,
                  backgroundImage: _profileImage.isNotEmpty
                      ? NetworkImage(_profileImage)
                      : null,
                  backgroundColor: Colors.brown.shade200,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _displayName,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF7A4F23),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.brown.shade100.withOpacity(0.5),
                    ),
                    child: Text(
                      _membershipName,
                      style: const TextStyle(
                        color: Color(0xFF4F3821),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          _remainingUsageCard(),
        ],
      ),
    );
  }

  Widget _remainingUsageCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF4),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오늘 남은 가능 횟수 🌰',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF7A4F23),
            ),
          ),
          const SizedBox(height: 14),
          _usageRow('글 요약', _remainingSummary),
          const SizedBox(height: 6),
          _usageRow('AI 디텍터', _remainingDetector),
        ],
      ),
    );
  }

  Widget _usageRow(String title, int? count) {
    String rightText;
    if (count == null || count < 0) {
      rightText = '무제한';
    } else {
      rightText = '${count}회 남음';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF7A4F23),
          ),
        ),
        Text(
          rightText,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4F3821),
          ),
        ),
      ],
    );
  }

  //  이번 주 활동 
  Widget _weeklyActivityCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '이번 주 활동 요약 🍂',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF7A4F23),
            ),
          ),
          const SizedBox(height: 18),
          _activityRow(
            Icons.quiz,
            '퀴즈 참여',
            '사고력이 한층 더 성장했어요!',
          ),
          const SizedBox(height: 12),
          _activityRow(
            Icons.record_voice_over,
            'AI 역할극',
            '대화력이 자연스럽게 향상됐어요!',
          ),
        ],
      ),
    );
  }

  Widget _activityRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.brown.shade100.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF7A4F23), size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '$title – $subtitle',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4F3821),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  //  추가 기능 
  Widget _extraFeatures() {
    return Column(
      children: [
        _extraItem(
          Icons.monetization_on_outlined,
          '내 포인트',
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PointScreen()),
          ).then((_) {
            _loadAll();
          }),
        ),
        _extraItem(
          Icons.analytics_outlined,
          '멤버십 사용량 분석',
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MembershipOverviewScreen(),
            ),
          ).then((_) {
            _loadAll();
          }),
        ),
        _extraItem(
          Icons.insights,
          '나의 활동 분석',
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UserAnalyticsScreen(),
            ),
          ).then((_) {
            _loadAll();
          }),
        ),
      ],
    );
  }

  Widget _extraItem(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          splashColor: Colors.brown.withOpacity(0.18),
          child: ListTile(
            leading: Icon(icon, color: const Color(0xFF7A4F23)),
            title: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF4F3821),
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing:
                const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ),
>>>>>>> clean-summary-2_flutter
        ),
      ),
    );
  }
}
