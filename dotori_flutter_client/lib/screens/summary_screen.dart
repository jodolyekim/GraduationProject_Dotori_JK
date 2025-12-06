
<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:dotori_client/services/summary_service.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});
=======
// lib/screens/summary_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/summary_service.dart';
import '../services/membership_api_service.dart';
import '../theme/app_theme.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

>>>>>>> clean-summary-2_flutter
  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _svc = SummaryService();
<<<<<<< HEAD
  final _text = TextEditingController();
  bool _loading = false;
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    items = await _svc.listMySummaries();
    if (mounted) setState(() {});
  }

  Future<void> _create() async {
    setState(() => _loading = true);
    final ok = await _svc.createSummary(_text.text);
    await _load();
    setState(() => _loading = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? '요약 요청 완료' : '요약 요청 실패')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('요약 만들기')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _text,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '원문 텍스트',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _create,
                child: _loading ? const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2)) : const Text('요약 생성'),
              ),
            ),
            const Divider(height: 32),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,
                child: ListView.separated(
                  itemBuilder: (_, i) {
                    final it = items[i];
                    return ListTile(
                      title: Text(it['result'] ?? '(처리 중)'),
                      subtitle: Text(it['source_text'] ?? ''),
                      trailing: Text(it['status'] ?? ''),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemCount: items.length,
                ),
              ),
            ),
=======
  final _textCtrl = TextEditingController();
  final _hintCtrl = TextEditingController();
  final _membershipApi = MembershipApiService();

  String _difficulty = "ADULT";

  SummaryResult? _result;
  bool _loadingSummary = false;
  String? _wordLoadingKey;

  @override
  void dispose() {
    _textCtrl.dispose();
    _hintCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: DotoriTheme.brownDark,
      ),
    );
  }

  Future<bool> _consumeFeature(String feature) async {
    try {
      final res = await _membershipApi.consumeFeature(featureType: feature);
      if (res["remaining"] is int) {
        _snack("오늘 남은 $feature: ${res['remaining']}회");
      }
      return true;
    } catch (e) {
      _snack("기능 사용 불가: $e");
      return false;
    }
  }

  //  텍스트 요약 
  Future<void> _onSummarizeText() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) {
      _snack("텍스트를 입력하세요.");
      return;
    }

    if (!await _consumeFeature("SUMMARY")) return;

    setState(() {
      _loadingSummary = true;
      _result = null;
    });

    try {
      final r = await _svc.summarizeFromText(
        text,
        difficulty: _difficulty,
        docHint: _hintCtrl.text.trim(),
      );
      setState(() => _result = r);
    } catch (e) {
      _snack("요약 실패: $e");
    } finally {
      setState(() => _loadingSummary = false);
    }
  }

  //  이미지 요약 
  Future<void> _onSummarizeImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;

    if (!await _consumeFeature("SUMMARY")) return;

    setState(() {
      _loadingSummary = true;
      _result = null;
    });

    try {
      // Web & Mobile 모두 지원되는 bytes 기반 처리
      final bytes = await img.readAsBytes();

      final r = await _svc.summarizeFromImageBytes(
        bytes,
        difficulty: _difficulty,
        docHint: _hintCtrl.text.trim(),
      );

      setState(() => _result = r);
    } catch (e) {
      _snack("요약 실패: $e");
    } finally {
      setState(() => _loadingSummary = false);
    }
  }

  //  Vocabulary 
  Widget _buildVocabulary() {
    if (_result == null || _result!.vocabulary.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Text(
          "어려운 단어 풀이 🍂",
          style: DotoriTheme.titleLarge.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 12),

        ..._result!.vocabulary.map((w) {
          final word = (w["word"] ?? "").toString();
          final meaning = (w["easy_meaning"] ?? w["meaning"] ?? "").toString();
          final example = w["example"]?.toString();
          final loadingThis = (_wordLoadingKey == word);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: DotoriTheme.softShadow,
              border: Border.all(color: Colors.brown.withOpacity(0.15)),
            ),
            child: InkWell(
              onTap: loadingThis ? null : () => _onTapWord(w),
              borderRadius: BorderRadius.circular(18),
              child: Row(
                children: [
                  const Icon(Icons.bookmark_rounded,
                      color: DotoriTheme.brownDark, size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(word,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(meaning, style: const TextStyle(color: Colors.black87)),
                        if (example != null && example.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text("예: $example",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12)),
                        ]
                      ],
                    ),
                  ),
                  if (loadingThis)
                    const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: DotoriTheme.brownDark))
                  else
                    const Icon(Icons.info_outline_rounded,
                        color: DotoriTheme.brownDark),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Future<void> _onTapWord(Map<String, dynamic> vocab) async {
    final word = vocab["word"]?.toString() ?? "";
    if (word.isEmpty) return;

    setState(() => _wordLoadingKey = word);

    try {
      final detail =
          await _svc.explainWord(word: word, difficulty: _difficulty);

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: DotoriTheme.ivory,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Text(word,
              style: DotoriTheme.titleLarge.copyWith(fontSize: 20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(detail.meaning),
              if (detail.example != null && detail.example!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text("예문: ${detail.example!}",
                    style: const TextStyle(color: Colors.black87)),
              ]
            ],
          ),
          actions: [
            TextButton(
              child: const Text("닫기",
                  style: TextStyle(color: DotoriTheme.brownDark)),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    } catch (_) {
      _snack("단어 설명을 가져오지 못했습니다.");
    } finally {
      setState(() => _wordLoadingKey = null);
    }
  }

  //  난이도 선택 
  Widget _difficultySelector() {
    return Row(
      children: [
        _difficultyChip("ELEMENTARY", "초등"),
        const SizedBox(width: 8),
        _difficultyChip("SECONDARY", "중고등"),
        const SizedBox(width: 8),
        _difficultyChip("ADULT", "성인"),
      ],
    );
  }

  Widget _difficultyChip(String key, String label) {
    final selected = (_difficulty == key);

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? DotoriTheme.brownDark : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border:
              Border.all(color: selected ? DotoriTheme.brownDark : Colors.brown),
          boxShadow: selected ? DotoriTheme.softShadow : [],
        ),
        child: InkWell(
          onTap: () => setState(() => _difficulty = key),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : DotoriTheme.brownDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //  UI 
  @override
  Widget build(BuildContext context) {
    final loading = _loadingSummary;

    return Scaffold(
      backgroundColor: DotoriTheme.ivory,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [DotoriTheme.brownDark, DotoriTheme.brownLight],
          ).createShader(bounds),
          child: const Text(
            "글 요약",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 50),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),

            //  Header 
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFDF6EC), Color(0xFFFFFCF7)],
                ),
                borderRadius: BorderRadius.circular(26),
                boxShadow: DotoriTheme.softShadow,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: DotoriTheme.brownDark.withOpacity(0.12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(Icons.summarize_rounded,
                        color: DotoriTheme.brownDark, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "긴 글도 한눈에 요약해드려요.\n난이도에 따라 길이도 자동 조절!",
                      style: DotoriTheme.subtitle.copyWith(
                        fontSize: 14,
                        color: DotoriTheme.brownDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            //  Input Card 
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: DotoriTheme.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("난이도 선택", style: DotoriTheme.titleLarge.copyWith(fontSize: 18)),
                  const SizedBox(height: 10),
                  _difficultySelector(),

                  const SizedBox(height: 22),

                  Text("요약할 글", style: DotoriTheme.titleLarge.copyWith(fontSize: 18)),
                  const SizedBox(height: 8),
                  _buildInputField(_textCtrl,
                      maxLines: 6, hint: "여기에 텍스트를 붙여넣으세요."),

                  const SizedBox(height: 16),

                  Text("글 종류 (선택)",
                      style: DotoriTheme.subtitle.copyWith(fontSize: 13)),
                  const SizedBox(height: 6),
                  _buildInputField(_hintCtrl,
                      hint: "예: 뉴스, 강의노트, 회의록, 안내문 등",
                      radius: 999,
                      paddingV: 12),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: loading ? null : _onSummarizeText,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DotoriTheme.brownDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: loading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                              : const Text("텍스트 요약",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: loading ? null : _onSummarizeImage,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: DotoriTheme.brownDark, width: 1.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "이미지 업로드",
                            style: TextStyle(
                              color: DotoriTheme.brownDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            //  Result Card 
            if (_result != null) ...[
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: DotoriTheme.softShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("요약 결과 🍂",
                        style: DotoriTheme.titleLarge.copyWith(fontSize: 18)),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: DotoriTheme.ivory,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.brown.withOpacity(0.2)),
                      ),
                      child: Text(
                        _result!.summary,
                        style: DotoriTheme.body.copyWith(height: 1.5),
                      ),
                    ),

                    _buildVocabulary(),
                  ],
                ),
              ),
            ]
>>>>>>> clean-summary-2_flutter
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  //  Input Field 
  Widget _buildInputField(
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
    double radius = 16,
    double paddingV = 14,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: DotoriTheme.ivory,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.brown.withOpacity(0.6)),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16, vertical: paddingV),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: Colors.brown.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: Colors.brown.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide:
              const BorderSide(color: DotoriTheme.brownDark, width: 1.4),
        ),
      ),
    );
  }
>>>>>>> clean-summary-2_flutter
}
