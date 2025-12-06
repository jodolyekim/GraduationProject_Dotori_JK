
// lib/widgets/result_card.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResultCard extends StatelessWidget {
  final Map<String, dynamic> result;
  final VoidCallback onBack;

  const ResultCard({
    super.key,
    required this.result,
    required this.onBack,
  });

  //  평탄화 
  Map<String, dynamic> _flatten(dynamic src) {
    final out = <String, dynamic>{};

    void walk(dynamic v) {
      if (v is Map) {
        v.forEach((k, val) {
          if (k is String && val != null && !out.containsKey(k)) {
            out[k] = val;
          }
          walk(val);
        });
      } else if (v is List) {
        for (final e in v) walk(e);
      }
    }

    walk(src);
    return out;
  }

  num? _asNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    if (v is String) return num.tryParse(v);
    return null;
  }

  dynamic _pickFirst(Map<String, dynamic> src, List<String> keys) {
    for (final k in keys) {
      if (src.containsKey(k)) return src[k];
    }
    return null;
  }

  String _pctStr(dynamic v) {
    final n = _asNum(v);
    if (n == null) return '-';

    final value = (n <= 1.0) ? (n * 100.0) : n.toDouble();
    return '${value.clamp(0, 100).toStringAsFixed(1)}%';
  }

  double _prob01(dynamic v) {
    final n = _asNum(v);
    if (n == null) return 0;
    return ((n <= 1.0) ? n.toDouble() : n.toDouble() / 100).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final flat = _flatten(result);

    //  AI 확률 
    final scoreRaw = _pickFirst(flat, [
      "score",
      "probability",
      "ai_probability",
      "overall_score",
      "completely_generated_prob",
    ]);

    final scorePct = _pctStr(scoreRaw);
    final gauge = _prob01(scoreRaw);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: DotoriTheme.card,
        borderRadius: BorderRadius.circular(26),
        boxShadow: DotoriTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // 헤더
          
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: DotoriTheme.brownDark.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield, color: DotoriTheme.brownDark, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "AI 생성 가능성",
                      style: TextStyle(
                        color: DotoriTheme.brownDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          
          // 메인 퍼센트
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                scorePct,
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: DotoriTheme.brownDark,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "AI 의심도",
                style: TextStyle(
                  fontSize: 14,
                  color: DotoriTheme.brown,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

        
          // 게이지
        
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: gauge,
              backgroundColor: DotoriTheme.brownLight.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation(DotoriTheme.brownDark),
            ),
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("사람이 작성했을 가능성 ↑",
                  style: TextStyle(fontSize: 11, color: DotoriTheme.brown)),
              Text("AI가 작성했을 가능성 ↑",
                  style: TextStyle(fontSize: 11, color: DotoriTheme.brown)),
            ],
          ),

          const SizedBox(height: 26),

        
          // 버튼
        
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.refresh_rounded,
                  size: 18, color: DotoriTheme.brownDark),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "다시 탐지하기",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: DotoriTheme.brownDark,
                  ),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: DotoriTheme.brownDark, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
