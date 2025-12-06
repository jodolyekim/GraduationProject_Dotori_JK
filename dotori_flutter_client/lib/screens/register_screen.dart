<<<<<<< HEAD
=======
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:dotori_client/services/auth_service.dart';
// import 'package:dotori_client/widgets/dotori_button.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _auth = AuthService();

//   // 입력 컨트롤러
//   final _id = TextEditingController();
//   final _email = TextEditingController();
//   final _name = TextEditingController();
//   final _phone = TextEditingController();
//   final _code = TextEditingController();
//   final _pw = TextEditingController();
//   final _pw2 = TextEditingController();

//   // 상태
//   bool _loading = false;

//   // 아이디 중복확인
//   bool _checkingId = false;
//   bool _idChecked = false;
//   bool _idAvailable = false;

//   // 휴대폰 인증
//   bool _verifying = false;
//   bool _phoneVerified = false;
//   String _phoneVerifiedToken = '';
//   int _cooldown = 0;
//   Timer? _timer;

//   // 비번 규칙: 문자+숫자 포함 8자 이상
//   final _pwRule = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _id.dispose();
//     _email.dispose();
//     _name.dispose();
//     _phone.dispose();
//     _code.dispose();
//     _pw.dispose();
//     _pw2.dispose();
//     super.dispose();
//   }

//   Future<void> _checkId() async {
//     final u = _id.text.trim();
//     if (u.isEmpty) return;
//     setState(() {
//       _checkingId = true;
//       _idChecked = true;
//     });
//     try {
//       final ok = await _auth.checkUsernameAvailable(u);
//       setState(() => _idAvailable = ok);
//     } catch (_) {
//       setState(() => _idAvailable = false);
//       _snack('아이디 중복확인 실패');
//     } finally {
//       setState(() => _checkingId = false);
//     }
//   }

//   Future<void> _sendCode() async {
//     final p = _phone.text.trim();
//     if (p.isEmpty) {
//       _snack('전화번호를 입력하세요.');
//       return;
//     }
//     if (_cooldown > 0) return;

//     try {
//       final cd = await _auth.sendPhoneCode(p);
//       setState(() {
//         _cooldown = cd;
//         _phoneVerified = false;
//         _phoneVerifiedToken = '';
//       });
//       _snack('인증번호를 전송했습니다.');
//       _timer?.cancel();
//       _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//         if (!mounted) return;
//         setState(() {
//           _cooldown -= 1;
//           if (_cooldown <= 0) {
//             _cooldown = 0;
//             t.cancel();
//           }
//         });
//       });
//     } catch (_) {
//       _snack('인증번호 전송 실패');
//     }
//   }

//   Future<void> _verifyCode() async {
//     final p = _phone.text.trim();
//     final c = _code.text.trim();
//     if (p.isEmpty || c.isEmpty) {
//       _snack('전화번호와 인증번호를 입력하세요.');
//       return;
//     }
//     setState(() => _verifying = true);
//     try {
//       final token = await _auth.verifyPhoneCode(phone: p, code: c);
//       setState(() {
//         _phoneVerified = true;
//         _phoneVerifiedToken = token;
//       });
//       _snack('휴대폰 인증이 완료되었습니다.');
//     } catch (e) {
//       setState(() {
//         _phoneVerified = false;
//         _phoneVerifiedToken = '';
//       });
//       _snack('인증 실패: ${e.toString()}');
//     } finally {
//       setState(() => _verifying = false);
//     }
//   }

//   Future<void> _register() async {
//     // 클라이언트 측 유효성
//     if (!_idChecked || !_idAvailable) {
//       _snack('아이디 중복확인을 완료하세요.');
//       return;
//     }
//     if (!_pwRule.hasMatch(_pw.text)) {
//       _snack('비밀번호는 문자와 숫자를 포함해 8자 이상이어야 합니다.');
//       return;
//     }
//     if (_pw.text != _pw2.text) {
//       _snack('비밀번호가 일치하지 않습니다.');
//       return;
//     }
//     if (!_phoneVerified || _phoneVerifiedToken.isEmpty) {
//       _snack('휴대폰 인증을 완료하세요.');
//       return;
//     }
//     if (_name.text.trim().isEmpty) {
//       _snack('이름을 입력하세요.');
//       return;
//     }

//     setState(() => _loading = true);
//     final ok = await _auth.register(
//       username: _id.text.trim(),
//       email: _email.text.trim(),
//       password: _pw.text,
//       name: _name.text.trim(),
//       phone: _phone.text.trim(),
//       phoneVerifiedToken: _phoneVerifiedToken,
//     );
//     setState(() => _loading = false);
//     if (!mounted) return;
//     if (ok) {
//       Navigator.pop(context);
//       _snack('가입 완료! 로그인 해주세요.');
//     } else {
//       _snack('회원가입 실패');
//     }
//   }

//   void _snack(String msg) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(msg)));
//   }

//   bool get _canSubmit =>
//       _idChecked &&
//       _idAvailable &&
//       _phoneVerified &&
//       _pwRule.hasMatch(_pw.text) &&
//       _pw.text == _pw2.text &&
//       _name.text.trim().isNotEmpty &&
//       _email.text.trim().isNotEmpty;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('도토리 회원가입')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             // 아이디 + 중복확인
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _id,
//                     decoration: const InputDecoration(labelText: '아이디'),
//                     onChanged: (_) {
//                       if (_idChecked) setState(() => _idChecked = false);
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _checkingId ? null : _checkId,
//                   child: _checkingId
//                       ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(strokeWidth: 2))
//                       : const Text('중복확인'),
//                 ),
//               ],
//             ),
//             if (_idChecked)
//               Padding(
//                 padding: const EdgeInsets.only(top: 4),
//                 child: Text(
//                   _idAvailable ? '사용 가능한 아이디입니다.' : '이미 사용 중인 아이디입니다.',
//                   style: TextStyle(
//                     color: _idAvailable ? Colors.green : Colors.red,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 16),
//             TextField(
//               controller: _email,
//               decoration: const InputDecoration(labelText: '이메일'),
//               keyboardType: TextInputType.emailAddress,
//             ),

//             const SizedBox(height: 16),
//             TextField(
//               controller: _name,
//               decoration: const InputDecoration(labelText: '이름'),
//             ),

//             const SizedBox(height: 16),
//             // 전화번호 + 인증번호 전송/쿨다운
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _phone,
//                     decoration: const InputDecoration(labelText: '전화번호(숫자만)'),
//                     keyboardType: TextInputType.phone,
//                     onChanged: (_) {
//                       // 번호 변경 시 인증상태 초기화
//                       if (_phoneVerified) {
//                         setState(() {
//                           _phoneVerified = false;
//                           _phoneVerifiedToken = '';
//                         });
//                       }
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _cooldown > 0 ? null : _sendCode,
//                   child: Text(_cooldown > 0 ? '재전송($_cooldown)' : '인증번호 전송'),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _code,
//                     decoration: const InputDecoration(labelText: '인증번호(6자리)'),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _verifying ? null : _verifyCode,
//                   child: _verifying
//                       ? const SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(strokeWidth: 2))
//                       : const Text('인증확인'),
//                 ),
//               ],
//             ),
//             if (_phoneVerified)
//               const Padding(
//                 padding: EdgeInsets.only(top: 4),
//                 child: Text('휴대폰 인증 완료', style: TextStyle(color: Colors.green, fontSize: 12)),
//               ),

//             const SizedBox(height: 16),
//             TextField(
//               controller: _pw,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: '비밀번호',
//                 helperText: '문자와 숫자를 포함해 8자 이상',
//                 helperStyle: TextStyle(color: Colors.red, fontSize: 12),
//               ),
//               onChanged: (_) => setState(() {}),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _pw2,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: '비밀번호 확인 (동일하게 입력)'),
//               onChanged: (_) => setState(() {}),
//             ),
//             if (_pw2.text.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 4),
//                 child: Text(
//                   _pw.text == _pw2.text
//                       ? '비밀번호가 일치합니다 '
//                       : '비밀번호가 일치하지 않습니다 ❌',
//                   style: TextStyle(
//                     color: _pw.text == _pw2.text ? Colors.green : Colors.red,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),

//             const SizedBox(height: 24),
//             DotoriButton(
//               text: '회원가입',
//               loading: _loading,
//               onPressed: _canSubmit ? _register : () => _snack('입력값과 인증을 확인하세요.'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
>>>>>>> clean-summary-2_flutter
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dotori_client/services/auth_service.dart';
import 'package:dotori_client/widgets/dotori_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthService();

<<<<<<< HEAD
  // 입력 컨트롤러
=======
>>>>>>> clean-summary-2_flutter
  final _id = TextEditingController();
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _code = TextEditingController();
  final _pw = TextEditingController();
  final _pw2 = TextEditingController();

<<<<<<< HEAD
  // 상태
  bool _loading = false;

  // 아이디 중복확인
=======
  bool _loading = false;

>>>>>>> clean-summary-2_flutter
  bool _checkingId = false;
  bool _idChecked = false;
  bool _idAvailable = false;

<<<<<<< HEAD
  // 휴대폰 인증
=======
>>>>>>> clean-summary-2_flutter
  bool _verifying = false;
  bool _phoneVerified = false;
  String _phoneVerifiedToken = '';
  int _cooldown = 0;
  Timer? _timer;

<<<<<<< HEAD
  // 비번 규칙: 문자+숫자 포함 8자 이상
=======
>>>>>>> clean-summary-2_flutter
  final _pwRule = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

  @override
  void dispose() {
    _timer?.cancel();
    _id.dispose();
    _email.dispose();
    _name.dispose();
    _phone.dispose();
    _code.dispose();
    _pw.dispose();
    _pw2.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  Future<void> _checkId() async {
    final u = _id.text.trim();
    if (u.isEmpty) return;
=======
  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _checkId() async {
    final u = _id.text.trim();
    if (u.isEmpty) return;

>>>>>>> clean-summary-2_flutter
    setState(() {
      _checkingId = true;
      _idChecked = true;
    });
<<<<<<< HEAD
=======

>>>>>>> clean-summary-2_flutter
    try {
      final ok = await _auth.checkUsernameAvailable(u);
      setState(() => _idAvailable = ok);
    } catch (_) {
      setState(() => _idAvailable = false);
      _snack('아이디 중복확인 실패');
    } finally {
      setState(() => _checkingId = false);
    }
  }

  Future<void> _sendCode() async {
    final p = _phone.text.trim();
    if (p.isEmpty) {
      _snack('전화번호를 입력하세요.');
      return;
    }
<<<<<<< HEAD
=======

>>>>>>> clean-summary-2_flutter
    if (_cooldown > 0) return;

    try {
      final cd = await _auth.sendPhoneCode(p);
<<<<<<< HEAD
=======

>>>>>>> clean-summary-2_flutter
      setState(() {
        _cooldown = cd;
        _phoneVerified = false;
        _phoneVerifiedToken = '';
      });
<<<<<<< HEAD
      _snack('인증번호를 전송했습니다.');
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return;
=======

      _snack('인증번호를 전송했습니다.');

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return;

>>>>>>> clean-summary-2_flutter
        setState(() {
          _cooldown -= 1;
          if (_cooldown <= 0) {
            _cooldown = 0;
            t.cancel();
          }
        });
      });
    } catch (_) {
      _snack('인증번호 전송 실패');
    }
  }

  Future<void> _verifyCode() async {
    final p = _phone.text.trim();
    final c = _code.text.trim();
<<<<<<< HEAD
=======

>>>>>>> clean-summary-2_flutter
    if (p.isEmpty || c.isEmpty) {
      _snack('전화번호와 인증번호를 입력하세요.');
      return;
    }
<<<<<<< HEAD
    setState(() => _verifying = true);
    try {
      final token = await _auth.verifyPhoneCode(phone: p, code: c);
=======

    setState(() => _verifying = true);

    try {
      final token = await _auth.verifyPhoneCode(phone: p, code: c);

>>>>>>> clean-summary-2_flutter
      setState(() {
        _phoneVerified = true;
        _phoneVerifiedToken = token;
      });
<<<<<<< HEAD
      _snack('휴대폰 인증이 완료되었습니다.');
    } catch (e) {
=======

      _snack('휴대폰 인증이 완료되었습니다.');
    } catch (_) {
>>>>>>> clean-summary-2_flutter
      setState(() {
        _phoneVerified = false;
        _phoneVerifiedToken = '';
      });
<<<<<<< HEAD
      _snack('인증 실패: ${e.toString()}');
=======
      _snack('인증 실패: 다시 시도하세요.');
>>>>>>> clean-summary-2_flutter
    } finally {
      setState(() => _verifying = false);
    }
  }

  Future<void> _register() async {
<<<<<<< HEAD
    // 클라이언트 측 유효성
    if (!_idChecked || !_idAvailable) {
      _snack('아이디 중복확인을 완료하세요.');
      return;
    }
    if (!_pwRule.hasMatch(_pw.text)) {
      _snack('비밀번호는 문자와 숫자를 포함해 8자 이상이어야 합니다.');
=======
    if (!_idChecked || !_idAvailable) {
      _snack('아이디 중복확인을 먼저 완료하세요.');
      return;
    }
    if (!_pwRule.hasMatch(_pw.text)) {
      _snack('비밀번호는 문자+숫자 포함 8자 이상이어야 합니다.');
>>>>>>> clean-summary-2_flutter
      return;
    }
    if (_pw.text != _pw2.text) {
      _snack('비밀번호가 일치하지 않습니다.');
      return;
    }
    if (!_phoneVerified || _phoneVerifiedToken.isEmpty) {
      _snack('휴대폰 인증을 완료하세요.');
      return;
    }
<<<<<<< HEAD
=======

>>>>>>> clean-summary-2_flutter
    if (_name.text.trim().isEmpty) {
      _snack('이름을 입력하세요.');
      return;
    }

    setState(() => _loading = true);
<<<<<<< HEAD
=======

>>>>>>> clean-summary-2_flutter
    final ok = await _auth.register(
      username: _id.text.trim(),
      email: _email.text.trim(),
      password: _pw.text,
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      phoneVerifiedToken: _phoneVerifiedToken,
    );
<<<<<<< HEAD
    setState(() => _loading = false);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
      _snack('가입 완료! 로그인 해주세요.');
=======

    setState(() => _loading = false);

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context);
      _snack('가입 완료! 로그인해주세요.');
>>>>>>> clean-summary-2_flutter
    } else {
      _snack('회원가입 실패');
    }
  }

<<<<<<< HEAD
  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

=======
>>>>>>> clean-summary-2_flutter
  bool get _canSubmit =>
      _idChecked &&
      _idAvailable &&
      _phoneVerified &&
      _pwRule.hasMatch(_pw.text) &&
      _pw.text == _pw2.text &&
      _name.text.trim().isNotEmpty &&
      _email.text.trim().isNotEmpty;

<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('도토리 회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // 아이디 + 중복확인
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _id,
                    decoration: const InputDecoration(labelText: '아이디'),
                    onChanged: (_) {
                      if (_idChecked) setState(() => _idChecked = false);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _checkingId ? null : _checkId,
                  child: _checkingId
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('중복확인'),
                ),
              ],
            ),
            if (_idChecked)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _idAvailable ? '사용 가능한 아이디입니다.' : '이미 사용 중인 아이디입니다.',
                  style: TextStyle(
                    color: _idAvailable ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),

            const SizedBox(height: 16),
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: '이메일'),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: '이름'),
            ),

            const SizedBox(height: 16),
            // 전화번호 + 인증번호 전송/쿨다운
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _phone,
                    decoration: const InputDecoration(labelText: '전화번호(숫자만)'),
                    keyboardType: TextInputType.phone,
                    onChanged: (_) {
                      // 번호 변경 시 인증상태 초기화
                      if (_phoneVerified) {
                        setState(() {
                          _phoneVerified = false;
                          _phoneVerifiedToken = '';
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _cooldown > 0 ? null : _sendCode,
                  child: Text(_cooldown > 0 ? '재전송($_cooldown)' : '인증번호 전송'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _code,
                    decoration: const InputDecoration(labelText: '인증번호(6자리)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _verifying ? null : _verifyCode,
                  child: _verifying
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('인증확인'),
                ),
              ],
            ),
            if (_phoneVerified)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text('휴대폰 인증 완료', style: TextStyle(color: Colors.green, fontSize: 12)),
              ),

            const SizedBox(height: 16),
            TextField(
              controller: _pw,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                helperText: '문자와 숫자를 포함해 8자 이상',
                helperStyle: TextStyle(color: Colors.red, fontSize: 12),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pw2,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호 확인 (동일하게 입력)'),
              onChanged: (_) => setState(() {}),
            ),
            if (_pw2.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _pw.text == _pw2.text
                      ? '비밀번호가 일치합니다 ✅'
                      : '비밀번호가 일치하지 않습니다 ❌',
                  style: TextStyle(
                    color: _pw.text == _pw2.text ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),

            const SizedBox(height: 24),
            DotoriButton(
              text: '회원가입',
              loading: _loading,
              onPressed: _canSubmit ? _register : () => _snack('입력값과 인증을 확인하세요.'),
            ),
          ],
=======
  InputDecoration _decorate(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFFFFAF4),
      labelStyle: TextStyle(color: Colors.brown.shade600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF7A4F23),
        title: const Text(
          '회원가입',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF7A4F23),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 타이틀
                  Text(
                    '도토리 계정을 만들고\n서비스를 시작해보세요 🌱',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: const Color(0xFF7A4F23),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '역할극, 사고력 퀴즈, 글 요약 기능을 모두 이용할 수 있어요.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.brown.shade600,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 카드
                  Card(
                    elevation: 3,
                    shadowColor: Colors.black12,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. 계정 정보
                          Text(
                            '1. 계정 정보',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7A4F23),
                            ),
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _id,
                                  decoration: _decorate(
                                    '아이디',
                                    hint: '로그인에 사용할 아이디',
                                  ),
                                  onChanged: (_) {
                                    if (_idChecked) {
                                      setState(() => _idChecked = false);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _checkingId ? null : _checkId,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7A4F23),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 14),
                                ),
                                child: _checkingId
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('확인'),
                              ),
                            ],
                          ),
                          if (_idChecked)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _idAvailable
                                    ? '사용 가능한 아이디입니다.'
                                    : '이미 사용 중인 아이디입니다.',
                                style: TextStyle(
                                  color: _idAvailable
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                          const SizedBox(height: 12),

                          TextField(
                            controller: _email,
                            decoration: _decorate(
                              '이메일',
                              hint: '비밀번호 찾기에 사용됩니다.',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 20),

                          // 2. 기본 정보
                          Text(
                            '2. 기본 정보',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7A4F23),
                            ),
                          ),
                          const SizedBox(height: 12),

                          TextField(
                            controller: _name,
                            decoration: _decorate('이름'),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _phone,
                                  decoration: _decorate('전화번호'),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (_) {
                                    if (_phoneVerified) {
                                      setState(() {
                                        _phoneVerified = false;
                                        _phoneVerifiedToken = '';
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _cooldown > 0 ? null : _sendCode,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7A4F23),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  _cooldown > 0
                                      ? '재전송($_cooldown)'
                                      : '전송',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _code,
                                  decoration: _decorate('인증번호'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed:
                                    _verifying ? null : _verifyCode,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF7A4F23),
                                  side: const BorderSide(
                                      color: Color(0xFF7A4F23)),
                                ),
                                child: _verifying
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Color(0xFF7A4F23),
                                        ),
                                      )
                                    : const Text('확인'),
                              ),
                            ],
                          ),

                          if (_phoneVerified)
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(
                                '휴대폰 인증 완료',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                          const SizedBox(height: 20),

                          // 3. 비밀번호
                          Text(
                            '3. 비밀번호 설정',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7A4F23),
                            ),
                          ),
                          const SizedBox(height: 12),

                          TextField(
                            controller: _pw,
                            obscureText: true,
                            decoration: _decorate(
                              '비밀번호',
                              hint: '문자 + 숫자 포함 8자 이상',
                            ).copyWith(
                              helperText: '문자와 숫자를 모두 포함해야 해요.',
                              helperStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 11,
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),

                          const SizedBox(height: 12),

                          TextField(
                            controller: _pw2,
                            obscureText: true,
                            decoration: _decorate(
                              '비밀번호 확인',
                              hint: '비밀번호 재입력',
                            ),
                            onChanged: (_) => setState(() {}),
                          ),

                          if (_pw2.text.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                _pw.text == _pw2.text
                                    ? '비밀번호가 일치합니다. ✔'
                                    : '비밀번호가 일치하지 않습니다. ✖',
                                style: TextStyle(
                                  color: _pw.text == _pw2.text
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 가입 버튼
                  DotoriButton(
                    text: '회원가입 완료하기',
                    loading: _loading,
                    onPressed: _canSubmit
                        ? _register
                        : () => _snack('입력값과 인증을 확인하세요.'),
                  ),
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
