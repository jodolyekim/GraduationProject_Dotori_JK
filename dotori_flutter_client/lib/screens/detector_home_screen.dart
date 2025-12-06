
// lib/screens/detector_home_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/membership_api_service.dart';

import 'detector_text_screen.dart';
import 'detector_image_screen.dart';
import 'detector_video_screen.dart';

class DetectorHomeScreen extends StatefulWidget {
  const DetectorHomeScreen({super.key});

  @override
  State<DetectorHomeScreen> createState() => _DetectorHomeScreenState();
}

class _DetectorHomeScreenState extends State<DetectorHomeScreen> {
  final _membershipApi = MembershipApiService();

  bool _loading = true;
  String? _error;
  int? _limit;
  int? _used;
  int? _remaining;

  @override
  void initState() {
    super.initState();
    _loadDetectorUsage();
  }

  Future<void> _loadDetectorUsage() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final overview = await _membershipApi.getOverview();
      final detector = (overview?['detector'] as Map<String, dynamic>?) ?? {};

      int? toInt(dynamic v) {
        if (v == null) return null;
        if (v is int) return v;
        if (v is num) return v.toInt();
        return null;
      }

      setState(() {
        _limit = toInt(detector['limit']);
        _used = toInt(detector['used']) ?? 0;
        _remaining = toInt(detector['remaining']);
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _statusText() {
    if (_error != null) {
      return '사용량을 불러오지 못했어요.';
    }
    if (_limit == null) return "AI 디텍터 사용량: 무제한";

    final used = _used ?? 0;
    final rem = _remaining ?? (_limit! - used);
    return "남은 횟수: $rem / $_limit (오늘 사용: $used)";
  }

  // 어떤 디텍터 화면에 들어갔다가 돌아오든, 무조건 사용량 다시 로드
  void _open(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) {
      _loadDetectorUsage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DotoriTheme.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("AI 디텍터"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerCard(),
              const SizedBox(height: 16),
              _usageCard(),
              const SizedBox(height: 30),
              Text(
                "탐지할 유형 선택",
                style: DotoriTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              _modeCard(
                title: "텍스트",
                desc: "에세이 · 보고서 등이 AI인지 분석해요.",
                icon: Icons.text_snippet_rounded,
                onTap: () => _open(context, const DetectorTextScreen()),
              ),
              const SizedBox(height: 14),

              _modeCard(
                title: "이미지",
                desc: "AI 생성 이미지 여부를 탐지해요.",
                icon: Icons.image_outlined,
                onTap: () => _open(context, const DetectorImageScreen()),
              ),
              const SizedBox(height: 14),

              _modeCard(
                title: "영상",
                desc: "딥페이크 여부를 분석해요.",
                icon: Icons.movie_creation_outlined,
                onTap: () => _open(context, const DetectorVideoScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  HEADER CARD
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
              Icons.shield_moon_rounded,
              size: 28,
              color: DotoriTheme.brownDark,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "AI 생성물 탐지 허브",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: DotoriTheme.brownDark,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "텍스트 · 이미지 · 영상까지\n한 곳에서 탐지해요.",
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

  //  USAGE CARD
  Widget _usageCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: DotoriTheme.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: DotoriTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: DotoriTheme.brownDark.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.speed_rounded,
              size: 20,
              color: DotoriTheme.brownDark,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _statusText(),
              style: const TextStyle(
                color: DotoriTheme.brownDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: _loading ? null : _loadDetectorUsage,
            icon: const Icon(Icons.refresh_rounded, color: DotoriTheme.brownDark),
          )
        ],
      ),
    );
  }

  //  MODE CARD
  Widget _modeCard({
    required String title,
    required String desc,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: DotoriTheme.card,
          borderRadius: BorderRadius.circular(22),
          boxShadow: DotoriTheme.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: DotoriTheme.brownDark.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: DotoriTheme.brownDark, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: DotoriTheme.brownDark,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.3,
                      color: DotoriTheme.brown,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: DotoriTheme.brown,
            ),
          ],
        ),
      ),
    );
  }
}
