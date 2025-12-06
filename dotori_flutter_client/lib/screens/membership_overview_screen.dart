// lib/screens/membership_overview_screen.dart
import 'package:flutter/material.dart';
import 'package:dotori_client/theme/app_theme.dart';
import '../services/membership_api_service.dart';

class MembershipOverviewScreen extends StatefulWidget {
  const MembershipOverviewScreen({super.key});

  @override
  State<MembershipOverviewScreen> createState() =>
      _MembershipOverviewScreenState();
}

class _MembershipOverviewScreenState extends State<MembershipOverviewScreen> {
  final _api = MembershipApiService();

  bool _loading = true;
  String? _error;

  Map<String, dynamic>? _membership; // /me/
  Map<String, dynamic>? _points; // /points/
  Map<String, dynamic>? _overview; // /stats/overview/

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final membership = await _api.getMyMembership();
      final points = await _api.getMyPoints();
      final overview = await _api.getOverview();

      if (!mounted) return;
      setState(() {
        _membership = membership;
        _points = points;
        _overview = overview;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  int? _intIn(Map<String, dynamic>? map, String key) {
    if (map == null) return null;
    final v = map[key];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('사용량 · 멤버십 분석'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              DotoriTheme.ivory,
              Colors.grey.shade100,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _loadAll,
          child: _buildBody(theme),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_loading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 220),
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 220),
        ],
      );
    }

    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          _ErrorCard(
            message: '데이터를 불러오는 중 문제가 발생했어요.',
            detail: _error!,
            onRetry: _loadAll,
          ),
        ],
      );
    }

    final plan = _membership?['plan'] as Map<String, dynamic>?;

    final summary = _overview?['summary'] as Map<String, dynamic>?;
    final image = _overview?['image'] as Map<String, dynamic>?;
    final detector = _overview?['detector'] as Map<String, dynamic>?;
    final pointsInfo = _overview?['points'] as Map<String, dynamic>?;

    final balance =
        _intIn(_points, 'balance') ?? _intIn(pointsInfo, 'balance') ?? 0;
    final todayEarned = _intIn(pointsInfo, 'today_earned') ?? 0;
    final dailyCap = _intIn(pointsInfo, 'daily_cap') ?? 100;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // 상단 멤버십 요약 카드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _MembershipHeaderCard(
                  planName: plan?['name'] ?? '알 수 없음',
                  planCode: plan?['code'] ?? '-',
                  description: (plan?['description'] as String?) ?? '',
                ),
              ),

              const SizedBox(height: 12),

              // 포인트 요약 카드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _PointsSummaryCard(
                  balance: balance,
                  todayEarned: todayEarned,
                  dailyCap: dailyCap,
                ),
              ),

              const SizedBox(height: 16),

              // 섹션 타이틀
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '오늘의 기능 사용량',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: DotoriTheme.brownDark,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),

        // 기능 카드들
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          sliver: SliverList.list(
            children: [
              _FeatureUsageCard(
                title: '글 요약',
                icon: Icons.summarize_outlined,
                accentColor: const Color(0xFF3366FF),
                data: summary,
              ),
              const SizedBox(height: 10),
              // ⬇️ 이미지 "생성"이 아니라, 그냥 "이미지 기능 사용량" 으로 이름만 유지
              _FeatureUsageCard(
                title: '이미지 기능 사용량',
                icon: Icons.image_outlined,
                accentColor: const Color(0xFFFFA000),
                data: image,
              ),
              const SizedBox(height: 10),
              _FeatureUsageCard(
                title: 'AI 디텍터',
                icon: Icons.search_rounded,
                accentColor: const Color(0xFF00C48C),
                data: detector,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

// 위젯들

class _MembershipHeaderCard extends StatelessWidget {
  final String planName;
  final String planCode;
  final String description;

  const _MembershipHeaderCard({
    required this.planName,
    required this.planCode,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isFree = planCode == 'BASIC';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [DotoriTheme.brownDark, DotoriTheme.brown],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, 8),
            color: Colors.black26,
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '현재 멤버십',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontSize: 12,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        planName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isFree
                            ? Colors.white.withOpacity(0.14)
                            : const Color(0xFFFFD54F),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isFree ? 'BASIC' : 'PREMIUM',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isFree ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '코드: $planCode',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                if (description.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsSummaryCard extends StatelessWidget {
  final int balance;
  final int todayEarned;
  final int dailyCap;

  const _PointsSummaryCard({
    required this.balance,
    required this.todayEarned,
    required this.dailyCap,
  });

  @override
  Widget build(BuildContext context) {
    final ratio =
        dailyCap > 0 ? (todayEarned.clamp(0, dailyCap) / dailyCap) : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: DotoriTheme.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: DotoriTheme.softShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.monetization_on_outlined,
                color: Color(0xFFFFA000),
              ),
              const SizedBox(width: 8),
              const Text(
                '포인트 현황',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: DotoriTheme.brownDark,
                ),
              ),
              const Spacer(),
              _Chip(
                label: '오늘 ${todayEarned}P',
                icon: Icons.bolt,
                background: const Color(0xFFFFF3E0),
                foreground: const Color(0xFFFFA000),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '$balance P',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: DotoriTheme.brownDark,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '보유 중',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '일일 적립 한도: $dailyCap P',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black45,
              ),
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: const Color(0xFFE4E9F2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFFA000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureUsageCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final Map<String, dynamic>? data;

  const _FeatureUsageCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.data,
  });

  int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final limit = _toInt(data?['limit']);
    final used = _toInt(data?['used']) ?? 0;
    final remaining = _toInt(data?['remaining']);

    final isUnlimited = limit == null;
    final limitText = isUnlimited ? '무제한' : '$limit회 / 일';
    final remainText = remaining == null
        ? (isUnlimited ? '무제한' : '-')
        : (remaining < 0 ? '무제한' : '$remaining회');

    final ratio = (!isUnlimited && limit! > 0)
        ? (used.clamp(0, limit) / limit)
        : (isUnlimited ? 0.2 : 0.0);

    return Container(
      decoration: BoxDecoration(
        color: DotoriTheme.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: DotoriTheme.softShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: DotoriTheme.brownDark,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _MetricPill(
                      label: '일일 한도',
                      value: limitText,
                    ),
                    const SizedBox(width: 6),
                    _MetricPill(
                      label: '오늘 사용',
                      value: '$used회',
                    ),
                    const SizedBox(width: 6),
                    _MetricPill(
                      label: '남은 횟수',
                      value: remainText,
                      isHighlight: !isUnlimited && (remaining ?? 0) <= 3,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE4E9F2),
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _MetricPill({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg =
        isHighlight ? const Color(0xFFFFEBEE) : const Color(0xFFF7F9FC);
    final fg =
        isHighlight ? const Color(0xFFD32F2F) : const Color(0xFF8F9BB3);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 11,
              color: fg,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;

  const _Chip({
    required this.label,
    this.icon,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final String detail;
  final VoidCallback onRetry;

  const _ErrorCard({
    required this.message,
    required this.detail,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '불러오기 실패',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFFD32F2F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFB71C1C),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            detail,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFFB71C1C),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('다시 시도'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFD32F2F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
