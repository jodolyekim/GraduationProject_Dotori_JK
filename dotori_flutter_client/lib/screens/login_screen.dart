<<<<<<< HEAD
=======
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dotori_client/services/auth_service.dart';
// import 'package:dotori_client/screens/register_screen.dart';
// import 'package:dotori_client/screens/home_screen.dart';
// import 'package:dotori_client/widgets/dotori_button.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _auth = AuthService();
//   final _id = TextEditingController();
//   final _pw = TextEditingController();

//   bool _loading = false;
//   bool _rememberId = true;
//   bool _autoLogin = true; // 기본 ON 권장 (개발 편의)

//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _restorePrefs();
//   }

//   Future<void> _restorePrefs() async {
//     final sp = await SharedPreferences.getInstance();
//     final saved = sp.getString('saved_username') ?? '';
//     final auto = sp.getBool('auto_login') ?? true;
//     setState(() {
//       _id.text = saved;
//       _rememberId = saved.isNotEmpty;
//       _autoLogin = auto;
//     });
//   }

//   Future<void> _login() async {
//     FocusScope.of(context).unfocus();
//     if (_id.text.trim().isEmpty || _pw.text.isEmpty) {
//       setState(() => _error = '아이디/비밀번호를 입력해주세요.');
//       return;
//     }
//     setState(() {
//       _loading = true;
//       _error = null;
//     });
//     try {
//       final ok = await _auth.login(_id.text.trim(), _pw.text);
//       if (!mounted) return;
//       if (ok) {
//         // 아이디 저장 / 자동로그인 설정 반영
//         final sp = await SharedPreferences.getInstance();
//         if (_rememberId) {
//           await sp.setString('saved_username', _id.text.trim());
//         } else {
//           await sp.remove('saved_username');
//         }
//         await sp.setBool('auto_login', _autoLogin);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('로그인 성공')),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const HomeScreen()),
//         );
//       } else {
//         setState(() => _error = '로그인 실패: 아이디/비밀번호를 확인하세요.');
//       }
//     } catch (e) {
//       setState(() => _error = '로그인 오류: $e');
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dense = const EdgeInsets.symmetric(vertical: 10);
//     return Scaffold(
//       appBar: AppBar(title: const Text('도토리 로그인')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _id,
//               decoration: const InputDecoration(labelText: '아이디'),
//               textInputAction: TextInputAction.next,
//               onSubmitted: (_) => FocusScope.of(context).nextFocus(),
//             ),
//             TextField(
//               controller: _pw,
//               decoration: const InputDecoration(labelText: '비밀번호'),
//               obscureText: true,
//               onSubmitted: (_) => _login(),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: CheckboxListTile(
//                     contentPadding: EdgeInsets.zero,
//                     value: _rememberId,
//                     onChanged: (v) => setState(() => _rememberId = v ?? false),
//                     title: const Text('아이디 저장'),
//                     controlAffinity: ListTileControlAffinity.leading,
//                   ),
//                 ),
//                 Expanded(
//                   child: SwitchListTile(
//                     contentPadding: EdgeInsets.zero,
//                     value: _autoLogin,
//                     onChanged: (v) => setState(() => _autoLogin = v),
//                     title: const Text('자동 로그인'),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             DotoriButton(text: '로그인', loading: _loading, onPressed: _login),
//             TextButton(
//               onPressed: _loading
//                   ? null
//                   : () => Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const RegisterScreen()),
//                       ),
//               child: const Text('회원가입'),
//             ),
//             if (_error != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Text(_error!, style: const TextStyle(color: Colors.red)),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

>>>>>>> clean-summary-2_flutter
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotori_client/services/auth_service.dart';
import 'package:dotori_client/screens/register_screen.dart';
import 'package:dotori_client/screens/home_screen.dart';
import 'package:dotori_client/widgets/dotori_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _id = TextEditingController();
  final _pw = TextEditingController();

  bool _loading = false;
  bool _rememberId = true;
<<<<<<< HEAD
  bool _autoLogin = true; // 기본 ON 권장 (개발 편의)

=======
>>>>>>> clean-summary-2_flutter
  String? _error;

  @override
  void initState() {
    super.initState();
    _restorePrefs();
  }

  Future<void> _restorePrefs() async {
    final sp = await SharedPreferences.getInstance();
<<<<<<< HEAD
    final saved = sp.getString('saved_username') ?? '';
    final auto = sp.getBool('auto_login') ?? true;
    setState(() {
      _id.text = saved;
      _rememberId = saved.isNotEmpty;
      _autoLogin = auto;
=======
    setState(() {
      _id.text = sp.getString('saved_username') ?? '';
      _rememberId = _id.text.isNotEmpty;
>>>>>>> clean-summary-2_flutter
    });
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
<<<<<<< HEAD
=======

>>>>>>> clean-summary-2_flutter
    if (_id.text.trim().isEmpty || _pw.text.isEmpty) {
      setState(() => _error = '아이디/비밀번호를 입력해주세요.');
      return;
    }
<<<<<<< HEAD
=======

>>>>>>> clean-summary-2_flutter
    setState(() {
      _loading = true;
      _error = null;
    });
<<<<<<< HEAD
    try {
      final ok = await _auth.login(_id.text.trim(), _pw.text);
      if (!mounted) return;
      if (ok) {
        // 아이디 저장 / 자동로그인 설정 반영
        final sp = await SharedPreferences.getInstance();
=======

    try {
      final ok = await _auth.login(_id.text.trim(), _pw.text);

      if (!mounted) return;

      if (ok) {
        final sp = await SharedPreferences.getInstance();

        // 아이디 저장
>>>>>>> clean-summary-2_flutter
        if (_rememberId) {
          await sp.setString('saved_username', _id.text.trim());
        } else {
          await sp.remove('saved_username');
        }
<<<<<<< HEAD
        await sp.setBool('auto_login', _autoLogin);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인 성공')),
        );
=======

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('로그인 성공')));

>>>>>>> clean-summary-2_flutter
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        setState(() => _error = '로그인 실패: 아이디/비밀번호를 확인하세요.');
      }
    } catch (e) {
      setState(() => _error = '로그인 오류: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final dense = const EdgeInsets.symmetric(vertical: 10);
    return Scaffold(
      appBar: AppBar(title: const Text('도토리 로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _id,
              decoration: const InputDecoration(labelText: '아이디'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            TextField(
              controller: _pw,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
              onSubmitted: (_) => _login(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _rememberId,
                    onChanged: (v) => setState(() => _rememberId = v ?? false),
                    title: const Text('아이디 저장'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Expanded(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _autoLogin,
                    onChanged: (v) => setState(() => _autoLogin = v),
                    title: const Text('자동 로그인'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DotoriButton(text: '로그인', loading: _loading, onPressed: _login),
            TextButton(
              onPressed: _loading
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      ),
              child: const Text('회원가입'),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
          ],
=======
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF7A4F23),
        title: const Text(
          '로그인',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF7A4F23),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // 로고
                  Image.asset(
                    'assets/dotori_logo.png',
                    width: 100,
                    height: 100,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    '도토리에 오신 걸 환영해요 🍂',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: const Color(0xFF7A4F23),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '당신의 하루를 더 편하게 도와드릴게요.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.brown.shade500,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 로그인 카드
                  Card(
                    elevation: 3,
                    color: Colors.white,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '계정 정보',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7A4F23),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 아이디
                          TextField(
                            controller: _id,
                            decoration: InputDecoration(
                              labelText: '아이디',
                              filled: true,
                              fillColor: const Color(0xFFFFFAF4),
                              labelStyle:
                                  TextStyle(color: Colors.brown.shade600),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 비밀번호
                          TextField(
                            controller: _pw,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: '비밀번호',
                              filled: true,
                              fillColor: const Color(0xFFFFFAF4),
                              labelStyle:
                                  TextStyle(color: Colors.brown.shade600),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (_) => _login(),
                          ),

                          const SizedBox(height: 10),

                          // 아이디 저장만 유지
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberId,
                                activeColor: const Color(0xFF7A4F23),
                                onChanged: (v) {
                                  setState(() => _rememberId = v!);
                                },
                              ),
                              const Text('아이디 저장'),
                            ],
                          ),

                          if (_error != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _error!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 13,
                                ),
                              ),
                            ),

                          const SizedBox(height: 18),

                          // 로그인 버튼
                          DotoriButton(
                            text: '로그인',
                            loading: _loading,
                            onPressed: _login,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '아직 계정이 없나요?',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.brown.shade600),
                      ),
                      const SizedBox(width: 6),
                      TextButton(
                        onPressed: _loading
                            ? null
                            : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterScreen()),
                                ),
                        child: const Text(
                          '회원가입하기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7A4F23),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
>>>>>>> clean-summary-2_flutter
        ),
      ),
    );
  }
}
