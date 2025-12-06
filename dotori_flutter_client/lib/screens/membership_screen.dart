
// lib/screens/membership_screen.dart
import 'package:flutter/material.dart';
import 'package:dotori_client/theme/app_theme.dart';
import '../services/membership_api_service.dart';
import '../services/membership_service.dart';
import '../widgets/dotori_button.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  final _api = MembershipApiService();
  final _local = MembershipService.instance;

  bool _loading = true;
  bool _submitting = false;
  String? _error;

  List<dynamic> _plans = [];
  String? _currentPlanCode;
  String? _selectedPlanCode;

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
      final plans = await _api.getPlans();
      final my = await _api.getMyMembership();
      final plan = my['plan'] as Map<String, dynamic>?;

      final code = plan?['code'] ?? 'BASIC';

      setState(() {
        _plans = plans;
        _currentPlanCode = code;
        _selectedPlanCode = code;
      });
    } catch (e) {
      setState(() => _error = '로딩 실패: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onSubscribe() async {
    final code = _selectedPlanCode;
    if (code == null) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await _api.subscribe(
        planCode: code,
        paymentMethod: 'CARD',
        pointToUse: 0,
      );

      setState(() => _currentPlanCode = code);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('멤버십이 변경되었습니다.')),
        );
      }
    } catch (e) {
      setState(() => _error = '멤버십 변경 실패: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  // 이미지 관련 문구 자동 제거 함수
    String _cleanDescription(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    var desc = raw;

    // ", 이미지 3회/일" / "· 이미지 생성 불가" 등 제거
    desc = desc.replaceAll(RegExp(r'[,\·]\s*이미지[^,·\n]*'), '');

    // "이미지 ~~" 단독 표현 제거
    desc = desc.replaceAll(RegExp(r'이미지[^,·\n]*'), '');

    // 중복 콤마 / 공백 정리
    desc = desc.replaceAll(RegExp(r'\s+,|\s+,'), ',');
    desc = desc.replaceAll(RegExp(r',\s*,+'), ',');
    desc = desc.replaceAll(RegExp(r'\s{2,}'), ' ');

    return desc.trim();
  }

  Color _planColor(String code) {
    if (code == _currentPlanCode) {
      return DotoriTheme.brownDark;
    }
    return Colors.grey.shade700;
  }

  // 플랜 카드 UI
  Widget _buildPlanTile(Map<String, dynamic> p) {
    final code = p['code'] ?? '';
    final name = p['name'] ?? code;

    // description 이미지 문구 제거
    final rawDesc = (p['description'] ?? '').toString();
    final desc = _cleanDescription(rawDesc);

    final price = p['price_monthly'] ?? 0;

    final isCurrent = code == _currentPlanCode;
    final isSelected = code == _selectedPlanCode;

    final accentColor =
        isSelected ? DotoriTheme.brownDark : Colors.grey.shade300;

    return Card(
      elevation: isSelected ? 4 : 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isSelected ? DotoriTheme.brownDark : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => setState(() => _selectedPlanCode = code),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽 아이콘
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.workspace_premium_outlined,
                  size: 20,
                  color: _planColor(code),
                ),
              ),
              const SizedBox(width: 12),

              // 텍스트 영역
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: DotoriTheme.brownDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),

                        // 현재 이용 중 표시
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              '현재 이용중',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),

                        // 선택됨 표시
                        if (!isCurrent && isSelected) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: DotoriTheme.brownLight.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              '선택됨',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: DotoriTheme.brownDark,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 6),

                    if (desc.isNotEmpty)
                      Text(
                        desc,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          height: 1.35,
                        ),
                      ),

                    const SizedBox(height: 10),

                    Text(
                      price == 0 ? '월 0원 (무료)' : '월 ${price}원',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: DotoriTheme.brownDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

    // 상단 내 멤버십 카드
    Widget _buildHeader(ThemeData theme) {
    final code = _currentPlanCode ?? '-';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: DotoriTheme.brown.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 24,
                color: DotoriTheme.brownDark,
              ),
            ),
            const SizedBox(width: 12),

            // 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내 멤버십',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: DotoriTheme.brown,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    code,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: DotoriTheme.brownDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '필요에 맞는 멤버십을 선택하면\n더 넉넉한 AI 기능을 사용할 수 있어요.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

    // 전체 UI
    @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('멤버십 선택 / 변경')),
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],

                _buildHeader(theme),
                const SizedBox(height: 14),

                // 플랜 리스트
                Expanded(
                  child: _plans.isEmpty
                      ? Center(
                          child: Text(
                            '상품 정보를 불러오지 못했어요.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          itemCount: _plans.length,
                          itemBuilder: (_, i) =>
                              _buildPlanTile(_plans[i] as Map<String, dynamic>),
                        ),
                ),

                const SizedBox(height: 10),

                // 변경 버튼 (DotoriButton 사용)
                SizedBox(
                  width: double.infinity,
                  child: DotoriButton(
                    text: '선택한 멤버십으로 변경',
                    onPressed: _submitting ? null : _onSubscribe,
                    loading: _submitting,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
