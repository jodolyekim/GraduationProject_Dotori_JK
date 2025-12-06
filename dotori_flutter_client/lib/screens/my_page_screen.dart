// import 'dart:async';
// import 'dart:typed_data';

// import 'package:dotori_client/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class MyPageScreen extends StatefulWidget {
//   const MyPageScreen({super.key});

//   @override
//   State<MyPageScreen> createState() => _MyPageScreenState();
// }

// class _MyPageScreenState extends State<MyPageScreen> {
//   final _auth = AuthService();

//   // 기본 정보
//   final _displayNameCtrl = TextEditingController();
//   final _phoneCtrl = TextEditingController();
//   String _profileImagePath = '';

//   String _initialDisplayName = '';
//   String _initialPhone = '';

//   // 이메일
//   final _emailCtrl = TextEditingController();
//   final _emailCodeCtrl = TextEditingController();
//   String _currentEmail = '';
//   bool _emailCodeSending = false;
//   bool _emailVerifying = false;
//   bool _emailSaving = false;
//   bool _emailVerified = false;
//   String? _emailVerifiedToken;
//   int _emailSecondsLeft = 0;
//   Timer? _emailTimer;

//   // 비밀번호
//   final _oldPwCtrl = TextEditingController();
//   final _newPwCtrl = TextEditingController();
//   final _newPwConfirmCtrl = TextEditingController();
//   final _pwCodeCtrl = TextEditingController();

//   bool _pwCodeSending = false;
//   bool _pwVerifying = false;
//   bool _pwSaving = false;
//   bool _pwVerified = false;
//   String? _phoneVerifiedToken;
//   int _pwSecondsLeft = 0;
//   Timer? _pwTimer;

//   // 섹션별 저장 여부
//   bool _basicSaving = false;
//   bool _basicSaved = false;
//   bool _emailSaved = false;
//   bool _pwSaved = false;

//   bool _loading = false;

//   static const int _codeTtlSeconds = 300; // 5분

//   @override
//   void initState() {
//     super.initState();
//     _loadAll();
//   }

//   Future<void> _loadAll() async {
//     setState(() => _loading = true);
//     try {
//       final me = await _auth.me();
//       final profile = await _auth.fetchProfile();

//       _currentEmail = (me?['email'] ?? '') as String;

//       _displayNameCtrl.text = (profile['display_name'] ?? '') as String;
//       _phoneCtrl.text = _formatPhone((profile['phone'] ?? '') as String);
//       _profileImagePath = (profile['profile_image'] ?? '') as String;

//       _initialDisplayName = _displayNameCtrl.text;
//       _initialPhone = _phoneCtrl.text;

//       _emailCtrl.text = _currentEmail;
//     } catch (e) {
//       _showSnack('마이페이지 정보 불러오기 실패: $e');
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   // 전화번호 010-1234-5678 형식으로 변환
//   String _formatPhone(String value) {
//     final digits = value.replaceAll(RegExp(r'\D'), '');
//     if (digits.isEmpty) return '';
//     if (digits.length <= 3) return digits;
//     if (digits.length <= 7) {
//       return '${digits.substring(0, 3)}-${digits.substring(3)}';
//     }
//     if (digits.length <= 11) {
//       final first = digits.substring(0, 3);
//       final second = digits.substring(3, 7);
//       final third = digits.substring(7);
//       return '$first-$second-$third';
//     }
//     // 11자리 넘어가면 앞에서 11자리만 사용
//     final first = digits.substring(0, 3);
//     final second = digits.substring(3, 7);
//     final third = digits.substring(7, 11);
//     return '$first-$second-$third';
//   }

//   void _onPhoneChanged(String value) {
//     final formatted = _formatPhone(value);
//     if (formatted == value) return;
//     final cursor = formatted.length;
//     _phoneCtrl.value = TextEditingValue(
//       text: formatted,
//       selection: TextSelection.collapsed(offset: cursor),
//     );
//   }

//   void _showSnack(String msg) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   // ----- 타이머 -----

//   void _startEmailTimer() {
//     _emailTimer?.cancel();
//     setState(() => _emailSecondsLeft = _codeTtlSeconds);
//     _emailTimer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (!mounted) {
//         t.cancel();
//         return;
//       }
//       if (_emailSecondsLeft <= 1) {
//         setState(() => _emailSecondsLeft = 0);
//         t.cancel();
//       } else {
//         setState(() => _emailSecondsLeft--);
//       }
//     });
//   }

//   void _startPwTimer() {
//     _pwTimer?.cancel();
//     setState(() => _pwSecondsLeft = _codeTtlSeconds);
//     _pwTimer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (!mounted) {
//         t.cancel();
//         return;
//       }
//       if (_pwSecondsLeft <= 1) {
//         setState(() => _pwSecondsLeft = 0);
//         t.cancel();
//       } else {
//         setState(() => _pwSecondsLeft--);
//       }
//     });
//   }

//   // ----- 기본 정보 저장 -----

//   Future<void> _saveBasic() async {
//     setState(() {
//       _basicSaving = true;
//       _basicSaved = false;
//     });
//     try {
//       await _auth.updateProfile(
//         displayName: _displayNameCtrl.text.trim(),
//         phone: _phoneCtrl.text.trim(),
//       );
//       _initialDisplayName = _displayNameCtrl.text.trim();
//       _initialPhone = _phoneCtrl.text.trim();
//       setState(() => _basicSaved = true);
//       _showSnack('기본 정보가 저장되었습니다.');
//     } catch (e) {
//       _showSnack('기본 정보 저장 실패: $e');
//     } finally {
//       if (mounted) setState(() => _basicSaving = false);
//     }
//   }

//   // ----- 프로필 사진 업로드 -----

//   Future<void> _changePhoto() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked == null) return;

//     final Uint8List bytes = await picked.readAsBytes();
//     try {
//       final path = await _auth.uploadProfilePhoto(bytes);
//       setState(() => _profileImagePath = path);
//       _showSnack('프로필 사진이 변경되었습니다.');
//     } catch (e) {
//       _showSnack('프로필 사진 업로드 실패: $e');
//     }
//   }

//   // ----- 이메일 인증 & 저장 -----

//   Future<void> _sendEmailCode() async {
//     final email = _emailCtrl.text.trim();
//     if (email.isEmpty) {
//       _showSnack('새 이메일을 입력해주세요.');
//       return;
//     }
//     setState(() => _emailCodeSending = true);
//     try {
//       await _auth.sendEmailCode(email);
//       _startEmailTimer();
//       _emailVerified = false;
//       _emailVerifiedToken = null;
//       _emailCodeCtrl.clear();
//       _showSnack('인증번호를 보냈습니다. 이메일을 확인해주세요.');
//     } catch (e) {
//       _showSnack('이메일 인증번호 전송 실패: $e');
//     } finally {
//       if (mounted) setState(() => _emailCodeSending = false);
//     }
//   }

//   Future<void> _verifyEmailCode() async {
//     final email = _emailCtrl.text.trim();
//     final code = _emailCodeCtrl.text.trim();
//     if (email.isEmpty || code.isEmpty) {
//       _showSnack('이메일과 인증번호를 모두 입력해주세요.');
//       return;
//     }
//     setState(() => _emailVerifying = true);
//     try {
//       final token = await _auth.verifyEmailCode(email: email, code: code);
//       setState(() {
//         _emailVerified = true;
//         _emailVerifiedToken = token;
//       });
//       _showSnack('이메일 인증이 완료되었습니다.');
//     } catch (e) {
//       _showSnack('이메일 인증 실패: $e');
//     } finally {
//       if (mounted) setState(() => _emailVerifying = false);
//     }
//   }

//   Future<void> _saveEmail() async {
//     final newEmail = _emailCtrl.text.trim();
//     if (newEmail.isEmpty || newEmail == _currentEmail) {
//       _showSnack('변경할 이메일을 입력해주세요.');
//       return;
//     }
//     if (!_emailVerified || _emailVerifiedToken == null) {
//       _showSnack('이메일 인증을 먼저 완료해주세요.');
//       return;
//     }

//     setState(() {
//       _emailSaving = true;
//       _emailSaved = false;
//     });
//     try {
//       await _auth.changeEmail(
//         newEmail: newEmail,
//         emailVerifiedToken: _emailVerifiedToken!,
//       );
//       _currentEmail = newEmail;
//       setState(() => _emailSaved = true);
//       _showSnack('이메일이 변경되었습니다.');
//     } catch (e) {
//       _showSnack('이메일 저장 실패: $e');
//     } finally {
//       if (mounted) setState(() => _emailSaving = false);
//     }
//   }

//   // ----- 비밀번호 인증 & 저장 -----

//   Future<void> _sendPwCode() async {
//     final phoneDigits = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
//     if (phoneDigits.isEmpty) {
//       _showSnack('등록된 휴대폰 번호가 없습니다. 먼저 기본 정보에서 번호를 저장해주세요.');
//       return;
//     }
//     setState(() => _pwCodeSending = true);
//     try {
//       await _auth.sendPhoneCode(phoneDigits);
//       _startPwTimer();
//       _pwVerified = false;
//       _phoneVerifiedToken = null;
//       _pwCodeCtrl.clear();
//       _showSnack('휴대폰으로 인증번호를 보냈습니다.');
//     } catch (e) {
//       _showSnack('인증번호 전송 실패: $e');
//     } finally {
//       if (mounted) setState(() => _pwCodeSending = false);
//     }
//   }

//   Future<void> _verifyPwCode() async {
//     final phoneDigits = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
//     final code = _pwCodeCtrl.text.trim();
//     if (phoneDigits.isEmpty || code.isEmpty) {
//       _showSnack('휴대폰 번호와 인증번호를 모두 입력해주세요.');
//       return;
//     }
//     setState(() => _pwVerifying = true);
//     try {
//       final token = await _auth.verifyPhoneCode(phone: phoneDigits, code: code);
//       setState(() {
//         _pwVerified = true;
//         _phoneVerifiedToken = token;
//       });
//       _showSnack('휴대폰 인증이 완료되었습니다.');
//     } catch (e) {
//       _showSnack('휴대폰 인증 실패: $e');
//     } finally {
//       if (mounted) setState(() => _pwVerifying = false);
//     }
//   }

//   Future<void> _savePassword() async {
//     final oldPw = _oldPwCtrl.text;
//     final newPw = _newPwCtrl.text;
//     final newPwConfirm = _newPwConfirmCtrl.text;

//     if (oldPw.isEmpty || newPw.isEmpty || newPwConfirm.isEmpty) {
//       _showSnack('비밀번호 입력란을 모두 채워주세요.');
//       return;
//     }
//     if (!_pwVerified || _phoneVerifiedToken == null) {
//       _showSnack('휴대폰 인증을 먼저 완료해주세요.');
//       return;
//     }

//     setState(() {
//       _pwSaving = true;
//       _pwSaved = false;
//     });
//     try {
//       await _auth.changePassword(
//         oldPassword: oldPw,
//         newPassword: newPw,
//         newPasswordConfirm: newPwConfirm,
//         phoneVerifiedToken: _phoneVerifiedToken!,
//       );
//       _oldPwCtrl.clear();
//       _newPwCtrl.clear();
//       _newPwConfirmCtrl.clear();
//       _pwCodeCtrl.clear();
//       setState(() => _pwSaved = true);
//       _showSnack('비밀번호가 변경되었습니다. 다시 로그인해야 할 수 있습니다.');
//     } catch (e) {
//       _showSnack('비밀번호 변경 실패: $e');
//     } finally {
//       if (mounted) setState(() => _pwSaving = false);
//     }
//   }

//   // ----- 전체 저장 -----

//   void _saveAll() {
//     final basicDirty =
//         _displayNameCtrl.text.trim() != _initialDisplayName ||
//         _phoneCtrl.text.trim() != _initialPhone;

//     final newEmail = _emailCtrl.text.trim();
//     final emailDirty = newEmail.isNotEmpty && newEmail != _currentEmail;

//     final passwordDirty = _oldPwCtrl.text.isNotEmpty ||
//         _newPwCtrl.text.isNotEmpty ||
//         _newPwConfirmCtrl.text.isNotEmpty;

//     if ((basicDirty && !_basicSaved) ||
//         (emailDirty && !_emailSaved) ||
//         (passwordDirty && !_pwSaved)) {
//       _showSnack('각 섹션의 [저장] 버튼을 먼저 눌러주세요.');
//       return;
//     }

//     _showSnack('전체 저장이 완료되었습니다.');
//     Navigator.pop(context);
//   }

//   @override
//   void dispose() {
//     _displayNameCtrl.dispose();
//     _phoneCtrl.dispose();
//     _emailCtrl.dispose();
//     _emailCodeCtrl.dispose();
//     _oldPwCtrl.dispose();
//     _newPwCtrl.dispose();
//     _newPwConfirmCtrl.dispose();
//     _pwCodeCtrl.dispose();
//     _emailTimer?.cancel();
//     _pwTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('마이페이지'),
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // ----- 섹션 1: 기본 정보 -----
//                   Text('기본 정보', style: theme.textTheme.titleMedium),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 32,
//                         backgroundImage: _profileImagePath.isNotEmpty
//                             ? NetworkImage(_profileImagePath)
//                             : null,
//                         child: _profileImagePath.isEmpty
//                             ? const Icon(Icons.person, size: 32)
//                             : null,
//                       ),
//                       const SizedBox(width: 12),
//                       TextButton(
//                         onPressed: _changePhoto,
//                         child: const Text('프로필 사진 변경'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _displayNameCtrl,
//                     decoration: const InputDecoration(
//                       labelText: '닉네임',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _phoneCtrl,
//                     keyboardType: TextInputType.phone,
//                     onChanged: _onPhoneChanged,
//                     decoration: const InputDecoration(
//                       labelText: '휴대폰 번호',
//                       hintText: '010-1234-5678',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: ElevatedButton(
//                       onPressed: _basicSaving ? null : _saveBasic,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                         child: _basicSaving
//                             ? const SizedBox(
//                                 height: 16,
//                                 width: 16,
//                                 child: CircularProgressIndicator(strokeWidth: 2),
//                               )
//                             : const Text('기본 정보 저장'),
//                       ),
//                     ),
//                   ),
//                   const Divider(height: 32),

//                   // ----- 섹션 2: 이메일 변경 -----
//                   Text('이메일 변경', style: theme.textTheme.titleMedium),
//                   const SizedBox(height: 4),
//                   Text(
//                     '현재 이메일: $_currentEmail',
//                     style: theme.textTheme.bodySmall,
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _emailCtrl,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(
//                       labelText: '새 이메일',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _emailCodeCtrl,
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             labelText: '이메일 인증번호',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Column(
//                         children: [
//                           ElevatedButton(
//                             onPressed: _emailCodeSending ? null : _sendEmailCode,
//                             child: _emailCodeSending
//                                 ? const SizedBox(
//                                     height: 16,
//                                     width: 16,
//                                     child: CircularProgressIndicator(strokeWidth: 2),
//                                   )
//                                 : const Text('인증번호 보내기'),
//                           ),
//                           const SizedBox(height: 8),
//                           OutlinedButton(
//                             onPressed: _emailVerifying ? null : _verifyEmailCode,
//                             child: _emailVerifying
//                                 ? const SizedBox(
//                                     height: 16,
//                                     width: 16,
//                                     child: CircularProgressIndicator(strokeWidth: 2),
//                                   )
//                                 : const Text('인증 확인'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   if (_emailSecondsLeft > 0)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Text(
//                         '이메일 인증 남은 시간: $_emailSecondsLeft초',
//                         style: theme.textTheme.bodySmall,
//                       ),
//                     ),
//                   if (_emailVerified)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Text(
//                         '이메일 인증 완료',
//                         style: theme.textTheme.bodySmall?.copyWith(color: Colors.green),
//                       ),
//                     ),
//                   const SizedBox(height: 8),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: ElevatedButton(
//                       onPressed: _emailSaving ? null : _saveEmail,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                         child: _emailSaving
//                             ? const SizedBox(
//                                 height: 16,
//                                 width: 16,
//                                 child: CircularProgressIndicator(strokeWidth: 2),
//                               )
//                             : const Text('이메일 저장'),
//                       ),
//                     ),
//                   ),
//                   const Divider(height: 32),

//                   // ----- 섹션 3: 비밀번호 변경 -----
//                   Text('비밀번호 변경', style: theme.textTheme.titleMedium),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _oldPwCtrl,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: '현재 비밀번호',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _newPwCtrl,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: '새 비밀번호',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _newPwConfirmCtrl,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       labelText: '새 비밀번호 확인',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: _pwCodeCtrl,
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             labelText: '휴대폰 인증번호',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Column(
//                         children: [
//                           ElevatedButton(
//                             onPressed: _pwCodeSending ? null : _sendPwCode,
//                             child: _pwCodeSending
//                                 ? const SizedBox(
//                                     height: 16,
//                                     width: 16,
//                                     child: CircularProgressIndicator(strokeWidth: 2),
//                                   )
//                                 : const Text('인증번호 보내기'),
//                           ),
//                           const SizedBox(height: 8),
//                           OutlinedButton(
//                             onPressed: _pwVerifying ? null : _verifyPwCode,
//                             child: _pwVerifying
//                                 ? const SizedBox(
//                                     height: 16,
//                                     width: 16,
//                                     child: CircularProgressIndicator(strokeWidth: 2),
//                                   )
//                                 : const Text('인증 확인'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   if (_pwSecondsLeft > 0)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Text(
//                         '휴대폰 인증 남은 시간: $_pwSecondsLeft초',
//                         style: theme.textTheme.bodySmall,
//                       ),
//                     ),
//                   if (_pwVerified)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 4),
//                       child: Text(
//                         '휴대폰 인증 완료',
//                         style: theme.textTheme.bodySmall?.copyWith(color: Colors.green),
//                       ),
//                     ),
//                   const SizedBox(height: 8),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: ElevatedButton(
//                       onPressed: _pwSaving ? null : _savePassword,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                         child: _pwSaving
//                             ? const SizedBox(
//                                 height: 16,
//                                 width: 16,
//                                 child: CircularProgressIndicator(strokeWidth: 2),
//                               )
//                             : const Text('비밀번호 저장'),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: _saveAll,
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       child: Text('전체 저장하기'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// import 'dart:async';
// import 'dart:typed_data';

// import 'package:dotori_client/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class MyPageScreen extends StatefulWidget {
//   const MyPageScreen({super.key});

//   @override
//   State<MyPageScreen> createState() => _MyPageScreenState();
// }

// class _MyPageScreenState extends State<MyPageScreen> {
//   final _auth = AuthService();

//   // 기본 정보
//   final _displayNameCtrl = TextEditingController();
//   final _phoneCtrl = TextEditingController();
//   String _profileImagePath = '';

//   String _initialDisplayName = '';
//   String _initialPhone = '';

//   // 이메일
//   final _emailCtrl = TextEditingController();
//   final _emailCodeCtrl = TextEditingController();
//   String _currentEmail = '';
//   bool _emailCodeSending = false;
//   bool _emailVerifying = false;
//   bool _emailSaving = false;
//   bool _emailVerified = false;
//   String? _emailVerifiedToken;
//   int _emailSecondsLeft = 0;
//   Timer? _emailTimer;

//   // 비밀번호
//   final _oldPwCtrl = TextEditingController();
//   final _newPwCtrl = TextEditingController();
//   final _newPwConfirmCtrl = TextEditingController();
//   final _pwCodeCtrl = TextEditingController();

//   bool _pwCodeSending = false;
//   bool _pwVerifying = false;
//   bool _pwSaving = false;
//   bool _pwVerified = false;
//   String? _phoneVerifiedToken;
//   int _pwSecondsLeft = 0;
//   Timer? _pwTimer;

//   // 섹션별 저장 여부
//   bool _basicSaving = false;
//   bool _basicSaved = false;
//   bool _emailSaved = false;
//   bool _pwSaved = false;

//   bool _loading = false;

//   static const int _codeTtlSeconds = 300; // 5분

//   @override
//   void initState() {
//     super.initState();
//     _loadAll();
//   }

//   Future<void> _loadAll() async {
//     setState(() => _loading = true);
//     try {
//       final me = await _auth.me();
//       final profile = await _auth.fetchProfile();

//       _currentEmail = (me?['email'] ?? '') as String;

//       _displayNameCtrl.text = (profile['display_name'] ?? '') as String;
//       _phoneCtrl.text = _formatPhone((profile['phone'] ?? '') as String);
//       _profileImagePath = (profile['profile_image'] ?? '') as String;

//       _initialDisplayName = _displayNameCtrl.text;
//       _initialPhone = _phoneCtrl.text;

//       _emailCtrl.text = _currentEmail;
//     } catch (e) {
//       _showSnack('마이페이지 정보 불러오기 실패: $e');
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   // 전화번호 010-1234-5678 형식으로 변환
//   String _formatPhone(String value) {
//     final digits = value.replaceAll(RegExp(r'\D'), '');
//     if (digits.isEmpty) return '';
//     if (digits.length <= 3) return digits;
//     if (digits.length <= 7) {
//       return '${digits.substring(0, 3)}-${digits.substring(3)}';
//     }
//     if (digits.length <= 11) {
//       final first = digits.substring(0, 3);
//       final second = digits.substring(3, 7);
//       final third = digits.substring(7);
//       return '$first-$second-$third';
//     }
//     // 11자리 넘어가면 앞에서 11자리만 사용
//     final first = digits.substring(0, 3);
//     final second = digits.substring(3, 7);
//     final third = digits.substring(7, 11);
//     return '$first-$second-$third';
//   }

//   void _onPhoneChanged(String value) {
//     final formatted = _formatPhone(value);
//     if (formatted == value) return;
//     final cursor = formatted.length;
//     _phoneCtrl.value = TextEditingValue(
//       text: formatted,
//       selection: TextSelection.collapsed(offset: cursor),
//     );
//   }

//   void _showSnack(String msg) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   // ----- 타이머 -----

//   void _startEmailTimer() {
//     _emailTimer?.cancel();
//     setState(() => _emailSecondsLeft = _codeTtlSeconds);
//     _emailTimer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (!mounted) {
//         t.cancel();
//         return;
//       }
//       if (_emailSecondsLeft <= 1) {
//         setState(() => _emailSecondsLeft = 0);
//         t.cancel();
//       } else {
//         setState(() => _emailSecondsLeft--);
//       }
//     });
//   }

//   void _startPwTimer() {
//     _pwTimer?.cancel();
//     setState(() => _pwSecondsLeft = _codeTtlSeconds);
//     _pwTimer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (!mounted) {
//         t.cancel();
//         return;
//       }
//       if (_pwSecondsLeft <= 1) {
//         setState(() => _pwSecondsLeft = 0);
//         t.cancel();
//       } else {
//         setState(() => _pwSecondsLeft--);
//       }
//     });
//   }

//   // ----- 기본 정보 저장 -----

//   Future<void> _saveBasic() async {
//     setState(() {
//       _basicSaving = true;
//       _basicSaved = false;
//     });
//     try {
//       await _auth.updateProfile(
//         displayName: _displayNameCtrl.text.trim(),
//         phone: _phoneCtrl.text.trim(),
//       );
//       _initialDisplayName = _displayNameCtrl.text.trim();
//       _initialPhone = _phoneCtrl.text.trim();
//       setState(() => _basicSaved = true);
//       _showSnack('기본 정보가 저장되었습니다.');
//     } catch (e) {
//       _showSnack('기본 정보 저장 실패: $e');
//     } finally {
//       if (mounted) setState(() => _basicSaving = false);
//     }
//   }

//   // ----- 프로필 사진 업로드 -----

//   Future<void> _changePhoto() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked == null) return;

//     final Uint8List bytes = await picked.readAsBytes();
//     try {
//       final path = await _auth.uploadProfilePhoto(bytes);
//       setState(() => _profileImagePath = path);
//       _showSnack('프로필 사진이 변경되었습니다.');
//     } catch (e) {
//       _showSnack('프로필 사진 업로드 실패: $e');
//     }
//   }

//   // ----- 이메일 인증 & 저장 -----

//   Future<void> _sendEmailCode() async {
//     final email = _emailCtrl.text.trim();
//     if (email.isEmpty) {
//       _showSnack('새 이메일을 입력해주세요.');
//       return;
//     }
//     setState(() => _emailCodeSending = true);
//     try {
//       await _auth.sendEmailCode(email);
//       _startEmailTimer();
//       _emailVerified = false;
//       _emailVerifiedToken = null;
//       _emailCodeCtrl.clear();
//       _showSnack('인증번호를 보냈습니다. 이메일을 확인해주세요.');
//     } catch (e) {
//       _showSnack('이메일 인증번호 전송 실패: $e');
//     } finally {
//       if (mounted) setState(() => _emailCodeSending = false);
//     }
//   }

//   Future<void> _verifyEmailCode() async {
//     final email = _emailCtrl.text.trim();
//     final code = _emailCodeCtrl.text.trim();
//     if (email.isEmpty || code.isEmpty) {
//       _showSnack('이메일과 인증번호를 모두 입력해주세요.');
//       return;
//     }
//     setState(() => _emailVerifying = true);
//     try {
//       final token = await _auth.verifyEmailCode(email: email, code: code);
//       setState(() {
//         _emailVerified = true;
//         _emailVerifiedToken = token;
//       });
//       _showSnack('이메일 인증이 완료되었습니다.');
//     } catch (e) {
//       _showSnack('이메일 인증 실패: $e');
//     } finally {
//       if (mounted) setState(() => _emailVerifying = false);
//     }
//   }

//   Future<void> _saveEmail() async {
//     final newEmail = _emailCtrl.text.trim();
//     if (newEmail.isEmpty || newEmail == _currentEmail) {
//       _showSnack('변경할 이메일을 입력해주세요.');
//       return;
//     }
//     if (!_emailVerified || _emailVerifiedToken == null) {
//       _showSnack('이메일 인증을 먼저 완료해주세요.');
//       return;
//     }

//     setState(() {
//       _emailSaving = true;
//       _emailSaved = false;
//     });
//     try {
//       await _auth.changeEmail(
//         newEmail: newEmail,
//         emailVerifiedToken: _emailVerifiedToken!,
//       );
//       _currentEmail = newEmail;
//       setState(() => _emailSaved = true);
//       _showSnack('이메일이 변경되었습니다.');
//     } catch (e) {
//       _showSnack('이메일 저장 실패: $e');
//     } finally {
//       if (mounted) setState(() => _emailSaving = false);
//     }
//   }

//   // ----- 비밀번호 인증 & 저장 -----

//   Future<void> _sendPwCode() async {
//     final phoneDigits = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
//     if (phoneDigits.isEmpty) {
//       _showSnack('등록된 휴대폰 번호가 없습니다. 먼저 기본 정보에서 번호를 저장해주세요.');
//       return;
//     }
//     setState(() => _pwCodeSending = true);
//     try {
//       await _auth.sendPhoneCode(phoneDigits);
//       _startPwTimer();
//       _pwVerified = false;
//       _phoneVerifiedToken = null;
//       _pwCodeCtrl.clear();
//       _showSnack('휴대폰으로 인증번호를 보냈습니다.');
//     } catch (e) {
//       _showSnack('인증번호 전송 실패: $e');
//     } finally {
//       if (mounted) setState(() => _pwCodeSending = false);
//     }
//   }

//   Future<void> _verifyPwCode() async {
//     final phoneDigits = _phoneCtrl.text.replaceAll(RegExp(r'\D'), '');
//     final code = _pwCodeCtrl.text.trim();
//     if (phoneDigits.isEmpty || code.isEmpty) {
//       _showSnack('휴대폰 번호와 인증번호를 모두 입력해주세요.');
//       return;
//     }
//     setState(() => _pwVerifying = true);
//     try {
//       final token = await _auth.verifyPhoneCode(phone: phoneDigits, code: code);
//       setState(() {
//         _pwVerified = true;
//         _phoneVerifiedToken = token;
//       });
//       _showSnack('휴대폰 인증이 완료되었습니다.');
//     } catch (e) {
//       _showSnack('휴대폰 인증 실패: $e');
//     } finally {
//       if (mounted) setState(() => _pwVerifying = false);
//     }
//   }

//   Future<void> _savePassword() async {
//     final oldPw = _oldPwCtrl.text;
//     final newPw = _newPwCtrl.text;
//     final newPwConfirm = _newPwConfirmCtrl.text;

//     if (oldPw.isEmpty || newPw.isEmpty || newPwConfirm.isEmpty) {
//       _showSnack('비밀번호 입력란을 모두 채워주세요.');
//       return;
//     }
//     if (!_pwVerified || _phoneVerifiedToken == null) {
//       _showSnack('휴대폰 인증을 먼저 완료해주세요.');
//       return;
//     }

//     setState(() {
//       _pwSaving = true;
//       _pwSaved = false;
//     });
//     try {
//       await _auth.changePassword(
//         oldPassword: oldPw,
//         newPassword: newPw,
//         newPasswordConfirm: newPwConfirm,
//         phoneVerifiedToken: _phoneVerifiedToken!,
//       );
//       _oldPwCtrl.clear();
//       _newPwCtrl.clear();
//       _newPwConfirmCtrl.clear();
//       _pwCodeCtrl.clear();
//       setState(() => _pwSaved = true);
//       _showSnack('비밀번호가 변경되었습니다. 다시 로그인해야 할 수 있습니다.');
//     } catch (e) {
//       _showSnack('비밀번호 변경 실패: $e');
//     } finally {
//       if (mounted) setState(() => _pwSaving = false);
//     }
//   }

//   // ----- 전체 저장 -----

//   void _saveAll() {
//     final basicDirty =
//         _displayNameCtrl.text.trim() != _initialDisplayName ||
//         _phoneCtrl.text.trim() != _initialPhone;

//     final newEmail = _emailCtrl.text.trim();
//     final emailDirty = newEmail.isNotEmpty && newEmail != _currentEmail;

//     final passwordDirty = _oldPwCtrl.text.isNotEmpty ||
//         _newPwCtrl.text.isNotEmpty ||
//         _newPwConfirmCtrl.text.isNotEmpty;

//     if ((basicDirty && !_basicSaved) ||
//         (emailDirty && !_emailSaved) ||
//         (passwordDirty && !_pwSaved)) {
//       _showSnack('각 섹션의 [저장] 버튼을 먼저 눌러주세요.');
//       return;
//     }

//     _showSnack('전체 저장이 완료되었습니다.');
//     Navigator.pop(context);
//   }

//   @override
//   void dispose() {
//     _displayNameCtrl.dispose();
//     _phoneCtrl.dispose();
//     _emailCtrl.dispose();
//     _emailCodeCtrl.dispose();
//     _oldPwCtrl.dispose();
//     _newPwCtrl.dispose();
//     _newPwConfirmCtrl.dispose();
//     _pwCodeCtrl.dispose();
//     _emailTimer?.cancel();
//     _pwTimer?.cancel();
//     super.dispose();
//   }

//   // ---------------- UI ----------------
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     if (_loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('마이페이지'),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               const Color(0xFFF5F7FF),
//               Colors.grey.shade100,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _buildProfileHeader(theme),
//                 const SizedBox(height: 12),

//                 // 섹션 1: 기본 정보
//                 _buildSectionCard(
//                   title: '기본 정보',
//                   caption: '닉네임과 휴대폰 번호를 수정할 수 있어요.',
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 32,
//                           backgroundImage: _profileImagePath.isNotEmpty
//                               ? NetworkImage(_profileImagePath)
//                               : null,
//                           child: _profileImagePath.isEmpty
//                               ? const Icon(Icons.person, size: 32)
//                               : null,
//                         ),
//                         const SizedBox(width: 12),
//                         TextButton.icon(
//                           onPressed: _changePhoto,
//                           icon: const Icon(Icons.camera_alt_outlined, size: 18),
//                           label: const Text('프로필 사진 변경'),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: _displayNameCtrl,
//                       decoration: const InputDecoration(
//                         labelText: '닉네임',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: _phoneCtrl,
//                       keyboardType: TextInputType.phone,
//                       onChanged: _onPhoneChanged,
//                       decoration: const InputDecoration(
//                         labelText: '휴대폰 번호',
//                         hintText: '010-1234-5678',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: FilledButton.tonal(
//                         onPressed: _basicSaving ? null : _saveBasic,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 16),
//                           child: _basicSaving
//                               ? const SizedBox(
//                                   height: 16,
//                                   width: 16,
//                                   child:
//                                       CircularProgressIndicator(strokeWidth: 2),
//                                 )
//                               : const Text('기본 정보 저장'),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 // 섹션 2: 이메일 변경
//                 _buildSectionCard(
//                   title: '이메일 변경',
//                   caption: '로그인용 이메일 주소를 바꾸고 싶을 때 사용해요.',
//                   children: [
//                     Text(
//                       '현재 이메일: $_currentEmail',
//                       style: theme.textTheme.bodySmall
//                           ?.copyWith(color: Colors.grey.shade700),
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: _emailCtrl,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: const InputDecoration(
//                         labelText: '새 이메일',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _emailCodeCtrl,
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               labelText: '이메일 인증번호',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Column(
//                           children: [
//                             FilledButton.tonal(
//                               onPressed:
//                                   _emailCodeSending ? null : _sendEmailCode,
//                               child: _emailCodeSending
//                                   ? const SizedBox(
//                                       height: 16,
//                                       width: 16,
//                                       child: CircularProgressIndicator(
//                                           strokeWidth: 2),
//                                     )
//                                   : const Text('인증번호 보내기'),
//                             ),
//                             const SizedBox(height: 8),
//                             OutlinedButton(
//                               onPressed:
//                                   _emailVerifying ? null : _verifyEmailCode,
//                               child: _emailVerifying
//                                   ? const SizedBox(
//                                       height: 16,
//                                       width: 16,
//                                       child: CircularProgressIndicator(
//                                           strokeWidth: 2),
//                                     )
//                                   : const Text('인증 확인'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     if (_emailSecondsLeft > 0)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 6),
//                         child: Text(
//                           '이메일 인증 남은 시간: $_emailSecondsLeft초',
//                           style: theme.textTheme.bodySmall?.copyWith(
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                       ),
//                     if (_emailVerified)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 4),
//                         child: Text(
//                           '이메일 인증 완료',
//                           style: theme.textTheme.bodySmall?.copyWith(
//                             color: Colors.green,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     const SizedBox(height: 12),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: FilledButton.tonal(
//                         onPressed: _emailSaving ? null : _saveEmail,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 16),
//                           child: _emailSaving
//                               ? const SizedBox(
//                                   height: 16,
//                                   width: 16,
//                                   child:
//                                       CircularProgressIndicator(strokeWidth: 2),
//                                 )
//                               : const Text('이메일 저장'),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 // 섹션 3: 비밀번호 변경
//                 _buildSectionCard(
//                   title: '비밀번호 변경',
//                   caption: '계정 보안을 위해 정기적으로 비밀번호를 바꾸는 것을 추천해요.',
//                   children: [
//                     TextField(
//                       controller: _oldPwCtrl,
//                       obscureText: true,
//                       decoration: const InputDecoration(
//                         labelText: '현재 비밀번호',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: _newPwCtrl,
//                       obscureText: true,
//                       decoration: const InputDecoration(
//                         labelText: '새 비밀번호',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     TextField(
//                       controller: _newPwConfirmCtrl,
//                       obscureText: true,
//                       decoration: const InputDecoration(
//                         labelText: '새 비밀번호 확인',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _pwCodeCtrl,
//                             keyboardType: TextInputType.number,
//                             decoration: const InputDecoration(
//                               labelText: '휴대폰 인증번호',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Column(
//                           children: [
//                             FilledButton.tonal(
//                               onPressed: _pwCodeSending ? null : _sendPwCode,
//                               child: _pwCodeSending
//                                   ? const SizedBox(
//                                       height: 16,
//                                       width: 16,
//                                       child: CircularProgressIndicator(
//                                           strokeWidth: 2),
//                                     )
//                                   : const Text('인증번호 보내기'),
//                             ),
//                             const SizedBox(height: 8),
//                             OutlinedButton(
//                               onPressed:
//                                   _pwVerifying ? null : _verifyPwCode,
//                               child: _pwVerifying
//                                   ? const SizedBox(
//                                       height: 16,
//                                       width: 16,
//                                       child: CircularProgressIndicator(
//                                           strokeWidth: 2),
//                                     )
//                                   : const Text('인증 확인'),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     if (_pwSecondsLeft > 0)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 6),
//                         child: Text(
//                           '휴대폰 인증 남은 시간: $_pwSecondsLeft초',
//                           style: theme.textTheme.bodySmall?.copyWith(
//                             color: Colors.grey.shade700,
//                           ),
//                         ),
//                       ),
//                     if (_pwVerified)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 4),
//                         child: Text(
//                           '휴대폰 인증 완료',
//                           style: theme.textTheme.bodySmall?.copyWith(
//                             color: Colors.green,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     const SizedBox(height: 12),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: FilledButton.tonal(
//                         onPressed: _pwSaving ? null : _savePassword,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8, horizontal: 16),
//                           child: _pwSaving
//                               ? const SizedBox(
//                                   height: 16,
//                                   width: 16,
//                                   child:
//                                       CircularProgressIndicator(strokeWidth: 2),
//                                 )
//                               : const Text('비밀번호 저장'),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 24),

//                 // 전체 저장 버튼
//                 SizedBox(
//                   width: double.infinity,
//                   child: FilledButton(
//                     onPressed: _saveAll,
//                     style: FilledButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       textStyle: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     child: const Text('전체 저장하기'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // 공통 섹션 카드
//   Widget _buildSectionCard({
//     required String title,
//     String? caption,
//     required List<Widget> children,
//   }) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style:
//                   const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//             ),
//             if (caption != null) ...[
//               const SizedBox(height: 4),
//               Text(
//                 caption,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey.shade600,
//                   height: 1.4,
//                 ),
//               ),
//             ],
//             const SizedBox(height: 12),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileHeader(ThemeData theme) {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.indigo.withOpacity(0.08),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: const Icon(Icons.person_outline, size: 24),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '내 정보 관리',
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '프로필, 이메일, 비밀번호를 한 곳에서 관리해요.',
//                     style: theme.textTheme.bodySmall?.copyWith(
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/screens/my_page_screen.dart

// lib/screens/my_page_screen.dart

// import 'dart:async';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:dotori_client/services/auth_service.dart';
// import 'package:dotori_client/theme/app_theme.dart';
// import 'package:dotori_client/widgets/dotori_button.dart';

// class MyPageScreen extends StatefulWidget {
//   const MyPageScreen({super.key});

//   @override
//   State<MyPageScreen> createState() => _MyPageScreenState();
// }

// class _MyPageScreenState extends State<MyPageScreen> {
//   final _auth = AuthService();

//   // --
//   // BASIC INFO
//   // --
//   final _displayNameCtrl = TextEditingController();
//   final _phoneCtrl = TextEditingController();
//   String _profileImagePath = '';
//   String _initialDisplayName = '';
//   String _initialPhone = '';

//   // --
//   // EMAIL
//   // --
//   final _emailCtrl = TextEditingController();
//   final _emailCodeCtrl = TextEditingController();
//   String _currentEmail = '';
//   bool _emailSending = false;
//   bool _emailVerifying = false;
//   bool _emailSaving = false;
//   bool _emailVerified = false;
//   String? _emailToken;
//   int _emailSeconds = 0;
//   Timer? _emailTimer;

//   // --
//   // PASSWORD
//   // --
//   final _pwPhoneCtrl = TextEditingController();       // ★ 새로 추가됨
//   final _oldPwCtrl = TextEditingController();
//   final _newPwCtrl = TextEditingController();
//   final _newPwConfirmCtrl = TextEditingController();
//   final _pwCodeCtrl = TextEditingController();
//   bool _pwSending = false;
//   bool _pwVerifying = false;
//   bool _pwSaving = false;
//   bool _pwVerified = false;
//   String? _pwToken;
//   int _pwSeconds = 0;
//   Timer? _pwTimer;

//   bool _savingBasic = false;
//   bool _loading = false;

//   static const int _ttl = 300;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   // --
//   // LOAD USER PROFILE
//   // --
//   Future<void> _load() async {
//     setState(() => _loading = true);

//     try {
//       final me = await _auth.me();
//       final profile = await _auth.fetchProfile();

//       _currentEmail = me?['email'] ?? '';
//       _profileImagePath = profile['profile_image'] ?? '';
//       _displayNameCtrl.text = profile['display_name'] ?? '';
//       _phoneCtrl.text = _fmtPhone(profile['phone'] ?? '');

//       _initialDisplayName = _displayNameCtrl.text;
//       _initialPhone = _phoneCtrl.text;

//       _emailCtrl.text = _currentEmail;

//       // 비밀번호 변경용 전화번호는 기본값으로 현재 번호를 넣어 둠
//       _pwPhoneCtrl.text = _phoneCtrl.text;

//     } catch (e) {
//       _showSnack("마이페이지 정보를 불러오지 못했습니다: $e");
//     }

//     setState(() => _loading = false);
//   }

//   // --
//   // PHONE FORMAT
//   // --
//   String _fmtPhone(String v) {
//     final d = v.replaceAll(RegExp(r'\D'), '');
//     if (d.length <= 3) return d;
//     if (d.length <= 7) return '${d.substring(0, 3)}-${d.substring(3)}';
//     if (d.length <= 11) {
//       return '${d.substring(0, 3)}-${d.substring(3, 7)}-${d.substring(7)}';
//     }
//     return '${d.substring(0, 3)}-${d.substring(3, 7)}-${d.substring(7, 11)}';
//   }

//   void _onPhoneChanged(String v) {
//     final f = _fmtPhone(v);
//     if (f == v) return;
//     _phoneCtrl.value = TextEditingValue(
//       text: f,
//       selection: TextSelection.collapsed(offset: f.length),
//     );
//   }

//   void _onPwPhoneChanged(String v) {
//     final f = _fmtPhone(v);
//     if (f == v) return;
//     _pwPhoneCtrl.value = TextEditingValue(
//       text: f,
//       selection: TextSelection.collapsed(offset: f.length),
//     );
//   }

//   void _showSnack(String msg) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   // --
//   // TIMERS
//   // --
//   void _startEmailTimer() {
//     _emailTimer?.cancel();
//     _emailSeconds = _ttl;
//     _emailTimer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (!mounted) return;
//       setState(() => _emailSeconds--);
//       if (_emailSeconds <= 0) t.cancel();
//     });
//   }

//   void _startPwTimer() {
//     _pwTimer?.cancel();
//     _pwSeconds = _ttl;
//     _pwTimer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (!mounted) return;
//       setState(() => _pwSeconds--);
//       if (_pwSeconds <= 0) t.cancel();
//     });
//   }

//   // --
//   // SAVE BASIC
//   // --
//   Future<void> _saveBasic() async {
//     setState(() => _savingBasic = true);

//     try {
//       await _auth.updateProfile(
//         displayName: _displayNameCtrl.text.trim(),
//         phone: _phoneCtrl.text.trim(),
//       );

//       _initialDisplayName = _displayNameCtrl.text.trim();
//       _initialPhone = _phoneCtrl.text.trim();
//       _showSnack("기본 정보가 저장되었습니다.");
//     } catch (e) {
//       _showSnack("기본 정보 저장 실패: $e");
//     }

//     setState(() => _savingBasic = false);
//   }

//   // --
//   // CHANGE PHOTO
//   // --
//   Future<void> _changePhoto() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked == null) return;

//     try {
//       final bytes = await picked.readAsBytes();
//       final path = await _auth.uploadProfilePhoto(bytes);
//       setState(() => _profileImagePath = path);
//       _showSnack("프로필 사진이 변경되었습니다.");
//     } catch (e) {
//       _showSnack("사진 업로드 실패: $e");
//     }
//   }

//   // --
//   // EMAIL — SEND / VERIFY / SAVE
//   // --
//   Future<void> _sendEmailCode() async {
//     final email = _emailCtrl.text.trim();
//     if (email.isEmpty) return _showSnack("새 이메일을 입력해주세요.");

//     setState(() => _emailSending = true);

//     try {
//       await _auth.sendEmailCode(email);
//       _emailVerified = false;
//       _emailToken = null;
//       _emailCodeCtrl.clear();
//       _startEmailTimer();
//       _showSnack("인증번호가 이메일로 전송되었습니다.");
//     } catch (e) {
//       _showSnack("전송 실패: $e");
//     }

//     setState(() => _emailSending = false);
//   }

//   Future<void> _verifyEmailCode() async {
//     final email = _emailCtrl.text.trim();
//     final code = _emailCodeCtrl.text.trim();

//     if (email.isEmpty || code.isEmpty) {
//       return _showSnack("이메일과 인증번호를 입력해주세요.");
//     }

//     setState(() => _emailVerifying = true);

//     try {
//       final token = await _auth.verifyEmailCode(email: email, code: code);
//       _emailVerified = true;
//       _emailToken = token;
//       _showSnack("이메일 인증 완료!");
//     } catch (e) {
//       _showSnack("인증 실패: $e");
//     }

//     setState(() => _emailVerifying = false);
//   }

//   Future<void> _saveEmail() async {
//     if (!_emailVerified || _emailToken == null) {
//       return _showSnack("이메일 인증을 먼저 완료해주세요.");
//     }

//     final newEmail = _emailCtrl.text.trim();
//     if (newEmail.isEmpty || newEmail == _currentEmail) {
//       return _showSnack("변경할 이메일을 입력해주세요.");
//     }

//     setState(() => _emailSaving = true);

//     try {
//       await _auth.changeEmail(
//         newEmail: newEmail,
//         emailVerifiedToken: _emailToken!,
//       );
//       _currentEmail = newEmail;
//       _showSnack("이메일이 변경되었습니다.");
//     } catch (e) {
//       _showSnack("변경 실패: $e");
//     }

//     setState(() => _emailSaving = false);
//   }

//   // --
//   // PASSWORD — SEND / VERIFY / SAVE
//   // --
//   Future<void> _sendPwCode() async {
//     final phone = _pwPhoneCtrl.text.replaceAll(RegExp(r'\D'), '');
//     if (phone.isEmpty) {
//       return _showSnack("휴대폰 번호를 입력해주세요.");
//     }

//     setState(() => _pwSending = true);

//     try {
//       await _auth.sendPhoneCode(phone);
//       _pwVerified = false;
//       _pwToken = null;
//       _pwCodeCtrl.clear();
//       _startPwTimer();
//       _showSnack("휴대폰 인증번호가 전송되었습니다.");
//     } catch (e) {
//       _showSnack("전송 실패: $e");
//     }

//     setState(() => _pwSending = false);
//   }

//   Future<void> _verifyPwCode() async {
//     final phone = _pwPhoneCtrl.text.replaceAll(RegExp(r'\D'), '');
//     final code = _pwCodeCtrl.text.trim();
//     if (phone.isEmpty || code.isEmpty) {
//       return _showSnack("휴대폰 번호와 인증번호를 입력해주세요.");
//     }

//     setState(() => _pwVerifying = true);

//     try {
//       final token = await _auth.verifyPhoneCode(phone: phone, code: code);
//       _pwVerified = true;
//       _pwToken = token;
//       _showSnack("휴대폰 인증 완료!");
//     } catch (e) {
//       _showSnack("인증 실패: $e");
//     }

//     setState(() => _pwVerifying = false);
//   }

//   Future<void> _savePassword() async {
//     if (!_pwVerified || _pwToken == null) {
//       return _showSnack("휴대폰 인증을 먼저 완료해주세요.");
//     }

//     final oldPw = _oldPwCtrl.text.trim();
//     final newPw = _newPwCtrl.text.trim();
//     final confirm = _newPwConfirmCtrl.text.trim();

//     if (oldPw.isEmpty || newPw.isEmpty || confirm.isEmpty) {
//       return _showSnack("모든 비밀번호 입력란을 채워주세요.");
//     }

//     setState(() => _pwSaving = true);

//     try {
//       await _auth.changePassword(
//         oldPassword: oldPw,
//         newPassword: newPw,
//         newPasswordConfirm: confirm,
//         phoneVerifiedToken: _pwToken!,
//       );

//       _oldPwCtrl.clear();
//       _newPwCtrl.clear();
//       _newPwConfirmCtrl.clear();
//       _pwCodeCtrl.clear();

//       _showSnack("비밀번호가 변경되었습니다.");
//     } catch (e) {
//       _showSnack("변경 실패: $e");
//     }

//     setState(() => _pwSaving = false);
//   }

//   // --
//   // SAVE ALL
//   // --
//   void _saveAll() {
//     final basicDirty =
//         _displayNameCtrl.text.trim() != _initialDisplayName ||
//             _phoneCtrl.text.trim() != _initialPhone;

//     final emailDirty =
//         _emailCtrl.text.trim().isNotEmpty &&
//             _emailCtrl.text.trim() != _currentEmail;

//     final pwDirty =
//         _oldPwCtrl.text.isNotEmpty ||
//             _newPwCtrl.text.isNotEmpty ||
//             _newPwConfirmCtrl.text.isNotEmpty;

//     if (basicDirty || emailDirty || pwDirty) {
//       return _showSnack("각 섹션의 개별 저장을 먼저 완료해주세요.");
//     }

//     _showSnack("전체 저장이 완료되었습니다.");
//     Navigator.pop(context);
//   }

//   // --
//   // BUILD UI
//   // --
//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       backgroundColor: DotoriTheme.background,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "마이페이지",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: DotoriTheme.brownDark,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
//         child: Column(
//           children: [
//             _buildProfileHeader(),
//             const SizedBox(height: 18),
//             _buildBasicSection(),
//             const SizedBox(height: 18),
//             _buildEmailSection(),
//             const SizedBox(height: 18),
//             _buildPasswordSection(),
//             const SizedBox(height: 26),
//             DotoriButton(
//               text: "전체 저장하기",
//               onPressed: _saveAll,
//               icon: Icons.check_circle_outline,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --
//   // PROFILE HEADER
//   // --
//   Widget _buildProfileHeader() {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: DotoriTheme.card,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: DotoriTheme.softShadow,
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: DotoriTheme.primary.withOpacity(0.12),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: const Icon(Icons.person_outline, color: DotoriTheme.primary),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("내 정보 관리",
//                     style: DotoriTheme.subtitle.copyWith(fontSize: 18)),
//                 const SizedBox(height: 4),
//                 Text(
//                   "프로필, 이메일, 비밀번호를 관리할 수 있어요.",
//                   style: DotoriTheme.body.copyWith(color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --
//   // BASIC SECTION
//   // --
//   Widget _buildBasicSection() {
//     return _sectionCard(
//       title: "기본 정보",
//       caption: "닉네임 / 휴대폰 번호 / 프로필 사진 변경",
//       children: [
//         Row(
//           children: [
//             CircleAvatar(
//               radius: 32,
//               backgroundImage: _profileImagePath.isNotEmpty
//                   ? NetworkImage(_profileImagePath)
//                   : null,
//               child:
//                   _profileImagePath.isEmpty ? const Icon(Icons.person, size: 32) : null,
//             ),
//             const SizedBox(width: 12),
//             DotoriButton(
//               text: "사진 변경",
//               icon: Icons.camera_alt_outlined,
//               outlined: true,
//               onPressed: _changePhoto,
//             ),
//           ],
//         ),
//         const SizedBox(height: 14),

//         TextField(
//           controller: _displayNameCtrl,
//           decoration: const InputDecoration(
//             labelText: "닉네임",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 10),

//         TextField(
//           controller: _phoneCtrl,
//           keyboardType: TextInputType.phone,
//           onChanged: _onPhoneChanged,
//           decoration: const InputDecoration(
//             labelText: "휴대폰 번호",
//             hintText: "010-1234-5678",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 14),

//         DotoriButton(
//           text: "기본 정보 저장",
//           onPressed: _savingBasic ? null : _saveBasic,
//           loading: _savingBasic,
//         ),
//       ],
//     );
//   }

//   // --
//   // EMAIL SECTION
//   // --
//   Widget _buildEmailSection() {
//     return _sectionCard(
//       title: "이메일 변경",
//       caption: "로그인용 이메일을 변경할 수 있어요.",
//       children: [
//         Text("현재 이메일: $_currentEmail",
//             style: DotoriTheme.body.copyWith(color: Colors.black87)),
//         const SizedBox(height: 14),

//         TextField(
//           controller: _emailCtrl,
//           keyboardType: TextInputType.emailAddress,
//           decoration: const InputDecoration(
//             labelText: "새 이메일",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 14),

//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _emailCodeCtrl,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: "인증번호",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Column(
//               children: [
//                 DotoriButton(
//                   text: "보내기",
//                   onPressed: _emailSending ? null : _sendEmailCode,
//                   loading: _emailSending,
//                 ),
//                 const SizedBox(height: 6),
//                 DotoriButton(
//                   text: "확인",
//                   outlined: true,
//                   onPressed: _emailVerifying ? null : _verifyEmailCode,
//                   loading: _emailVerifying,
//                 ),
//               ],
//             )
//           ],
//         ),

//         if (_emailSeconds > 0) ...[
//           const SizedBox(height: 8),
//           Text("남은 시간: $_emailSeconds초",
//               style: DotoriTheme.body.copyWith(color: Colors.black87)),
//         ],

//         if (_emailVerified) ...[
//           const SizedBox(height: 6),
//           Text("이메일 인증 완료!",
//               style: DotoriTheme.subtitle.copyWith(color: Colors.green)),
//         ],

//         const SizedBox(height: 14),
//         DotoriButton(
//           text: "이메일 저장",
//           onPressed: _emailSaving ? null : _saveEmail,
//           loading: _emailSaving,
//         ),
//       ],
//     );
//   }

//   // --
//   // PASSWORD SECTION (변경됨)
//   // --
//   Widget _buildPasswordSection() {
//     return _sectionCard(
//       title: "비밀번호 변경",
//       caption: "휴대폰 인증 후 비밀번호를 변경할 수 있어요.",
//       children: [
//         // ★ 휴대전화 번호 입력칸 (CoolSMS 전송용)
//         TextField(
//           controller: _pwPhoneCtrl,
//           keyboardType: TextInputType.phone,
//           onChanged: _onPwPhoneChanged,
//           decoration: const InputDecoration(
//             labelText: "휴대폰 번호 (인증번호 받을 번호)",
//             hintText: "010-1234-5678",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 10),

//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 controller: _pwCodeCtrl,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: "휴대폰 인증번호",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Column(
//               children: [
//                 DotoriButton(
//                   text: "보내기",
//                   onPressed: _pwSending ? null : _sendPwCode,
//                   loading: _pwSending,
//                 ),
//                 const SizedBox(height: 6),
//                 DotoriButton(
//                   text: "확인",
//                   outlined: true,
//                   onPressed: _pwVerifying ? null : _verifyPwCode,
//                   loading: _pwVerifying,
//                 ),
//               ],
//             ),
//           ],
//         ),

//         if (_pwSeconds > 0) ...[
//           const SizedBox(height: 8),
//           Text("남은 시간: $_pwSeconds초",
//               style: DotoriTheme.body.copyWith(color: Colors.black87)),
//         ],

//         if (_pwVerified) ...[
//           const SizedBox(height: 6),
//           Text(
//             "휴대폰 인증 완료!",
//             style: DotoriTheme.subtitle.copyWith(color: Colors.green),
//           ),
//         ],

//         const SizedBox(height: 14),

//         TextField(
//           controller: _oldPwCtrl,
//           obscureText: true,
//           decoration: const InputDecoration(
//             labelText: "현재 비밀번호",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 10),

//         TextField(
//           controller: _newPwCtrl,
//           obscureText: true,
//           decoration: const InputDecoration(
//             labelText: "새 비밀번호",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 10),

//         TextField(
//           controller: _newPwConfirmCtrl,
//           obscureText: true,
//           decoration: const InputDecoration(
//             labelText: "새 비밀번호 확인",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 14),

//         DotoriButton(
//           text: "비밀번호 저장",
//           onPressed: _pwSaving ? null : _savePassword,
//           loading: _pwSaving,
//         ),
//       ],
//     );
//   }

//   // --
//   // TEMPLATE UI
//   // --
//   Widget _sectionCard({
//     required String title,
//     String? caption,
//     required List<Widget> children,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: DotoriTheme.card,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: DotoriTheme.softShadow,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: DotoriTheme.subtitle.copyWith(fontSize: 17)),
//           if (caption != null) ...[
//             const SizedBox(height: 4),
//             Text(caption,
//                 style: DotoriTheme.body.copyWith(color: Colors.black54)),
//           ],
//           const SizedBox(height: 14),
//           ...children,
//         ],
//       ),
//     );
//   }

//   // --
//   // DISPOSE
//   // --
//   @override
//   void dispose() {
//     _displayNameCtrl.dispose();
//     _phoneCtrl.dispose();
//     _emailCtrl.dispose();
//     _emailCodeCtrl.dispose();
//     _oldPwCtrl.dispose();
//     _newPwCtrl.dispose();
//     _newPwConfirmCtrl.dispose();
//     _pwPhoneCtrl.dispose();
//     _pwCodeCtrl.dispose();

//     _emailTimer?.cancel();
//     _pwTimer?.cancel();
//     super.dispose();
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotori_client/services/auth_service.dart';
import 'package:dotori_client/theme/app_theme.dart';
import 'package:dotori_client/widgets/dotori_button.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final _auth = AuthService();

  // --
  // BASIC INFO
  // --
  final _displayNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _profileImagePath = '';
  String _initialDisplayName = '';
  String _initialPhone = '';

  // --
  // EMAIL
  // --
  final _emailCtrl = TextEditingController();
  final _emailCodeCtrl = TextEditingController();
  String _currentEmail = '';
  bool _emailSending = false;
  bool _emailVerifying = false;
  bool _emailSaving = false;
  bool _emailVerified = false;
  String? _emailToken;
  int _emailSeconds = 0;
  Timer? _emailTimer;

  // --
  // PASSWORD
  // --
  final _pwPhoneCtrl = TextEditingController();
  final _oldPwCtrl = TextEditingController();
  final _newPwCtrl = TextEditingController();
  final _newPwConfirmCtrl = TextEditingController();
  final _pwCodeCtrl = TextEditingController();

  bool _pwSending = false;
  bool _pwVerifying = false;
  bool _pwSaving = false;

  bool _pwVerified = false;
  String? _pwToken;
  int _pwSeconds = 0;
  Timer? _pwTimer;

  // Lock 변수 (중복 클릭 방지)
  bool _pwSendLocked = false;

  bool _savingBasic = false;
  bool _loading = false;

  static const int _ttl = 300; // 5분

  @override
  void initState() {
    super.initState();
    _load();
  }

  // --
  // LOAD PROFILE
  // --
  Future<void> _load() async {
    setState(() => _loading = true);

    try {
      final me = await _auth.me();
      final profile = await _auth.fetchProfile();

      _currentEmail = me?['email'] ?? '';
      _profileImagePath = profile['profile_image'] ?? '';
      _displayNameCtrl.text = profile['display_name'] ?? '';
      _phoneCtrl.text = _fmtPhone(profile['phone'] ?? '');

      _initialDisplayName = _displayNameCtrl.text;
      _initialPhone = _phoneCtrl.text;

      _emailCtrl.text = _currentEmail;

      // 비밀번호 변경용 기본 전화번호 세팅
      _pwPhoneCtrl.text = _phoneCtrl.text;

    } catch (e) {
      _showSnack("마이페이지 정보를 불러오는 중 오류 발생: $e");
    }

    setState(() => _loading = false);
  }

  // --
  // FORMATTERS
  // --
  String _fmtPhone(String v) {
    final d = v.replaceAll(RegExp(r'\D'), '');
    if (d.length <= 3) return d;
    if (d.length <= 7) return "${d.substring(0, 3)}-${d.substring(3)}";
    if (d.length <= 11) {
      return "${d.substring(0, 3)}-${d.substring(3, 7)}-${d.substring(7)}";
    }
    return "${d.substring(0, 3)}-${d.substring(3, 7)}-${d.substring(7, 11)}";
  }

  void _onPhoneChanged(String v) {
    final f = _fmtPhone(v);
    if (v == f) return;
    _phoneCtrl.value = TextEditingValue(
      text: f,
      selection: TextSelection.collapsed(offset: f.length),
    );
  }

  void _onPwPhoneChanged(String v) {
    final f = _fmtPhone(v);
    if (v == f) return;
    _pwPhoneCtrl.value = TextEditingValue(
      text: f,
      selection: TextSelection.collapsed(offset: f.length),
    );

    // 번호가 바뀌면 인증 상태 초기화
    if (_pwVerified) {
      setState(() {
        _pwVerified = false;
        _pwToken = null;
      });
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // --
  // TIMERS
  // --
  void _startEmailTimer() {
    _emailTimer?.cancel();
    _emailSeconds = _ttl;
    _emailTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _emailSeconds--);
      if (_emailSeconds <= 0) t.cancel();
    });
  }

  void _startPwTimer() {
    _pwTimer?.cancel();
    _pwSeconds = _ttl;
    _pwTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _pwSeconds--);
      if (_pwSeconds <= 0) t.cancel();
    });
  }

  // --
  // CHANGE PHOTO
  // --
  Future<void> _changePhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    try {
      final bytes = await picked.readAsBytes();
      final url = await _auth.uploadProfilePhoto(bytes);
      setState(() => _profileImagePath = url);
      _showSnack("프로필 사진이 변경되었습니다.");
    } catch (e) {
      _showSnack("사진 업로드 실패: $e");
    }
  }
  // --
  // SAVE BASIC INFO
  // --
  Future<void> _saveBasic() async {
    setState(() => _savingBasic = true);

    try {
      await _auth.updateProfile(
        displayName: _displayNameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
      );

      _initialDisplayName = _displayNameCtrl.text.trim();
      _initialPhone = _phoneCtrl.text.trim();
      _showSnack("기본 정보가 저장되었습니다.");
    } catch (e) {
      _showSnack("기본 정보 저장 실패: $e");
    }

    setState(() => _savingBasic = false);
  }

  // --
  // EMAIL — SEND / VERIFY / SAVE
  // --
  Future<void> _sendEmailCode() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return _showSnack("새 이메일을 입력해주세요.");

    setState(() => _emailSending = true);

    try {
      await _auth.sendEmailCode(email);
      _emailVerified = false;
      _emailToken = null;
      _emailCodeCtrl.clear();
      _startEmailTimer();
      _showSnack("인증번호가 이메일로 전송되었습니다.");
    } catch (e) {
      _showSnack("전송 실패: $e");
    }

    setState(() => _emailSending = false);
  }

  Future<void> _verifyEmailCode() async {
    final email = _emailCtrl.text.trim();
    final code = _emailCodeCtrl.text.trim();

    if (email.isEmpty || code.isEmpty) {
      return _showSnack("이메일과 인증번호를 입력해주세요.");
    }

    setState(() => _emailVerifying = true);

    try {
      final token = await _auth.verifyEmailCode(email: email, code: code);
      _emailVerified = true;
      _emailToken = token;
      _showSnack("이메일 인증 완료!");
    } catch (e) {
      _showSnack("인증 실패: $e");
    }

    setState(() => _emailVerifying = false);
  }

  Future<void> _saveEmail() async {
    if (!_emailVerified || _emailToken == null) {
      return _showSnack("이메일 인증을 먼저 완료해주세요.");
    }

    final newEmail = _emailCtrl.text.trim();
    if (newEmail.isEmpty || newEmail == _currentEmail) {
      return _showSnack("변경할 이메일을 입력해주세요.");
    }

    setState(() => _emailSaving = true);

    try {
      await _auth.changeEmail(
        newEmail: newEmail,
        emailVerifiedToken: _emailToken!,
      );
      _currentEmail = newEmail;
      _showSnack("이메일이 변경되었습니다.");
    } catch (e) {
      _showSnack("변경 실패: $e");
    }

    setState(() => _emailSaving = false);
  }

  // --
  // PASSWORD — SEND / VERIFY / SAVE
  // --
  Future<void> _sendPwCode() async {
    if (_pwSendLocked) return; // 🔐 3초 Lock

    final phone = _pwPhoneCtrl.text.replaceAll(RegExp(r'\D'), '');
    if (phone.isEmpty) return _showSnack("휴대폰 번호를 입력해주세요.");

    setState(() {
      _pwSending = true;
      _pwSendLocked = true;
    });

    // 3초 후 버튼 풀림
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _pwSendLocked = false);
    });

    try {
      await _auth.sendPhoneCode(phone);
      _pwVerified = false;
      _pwToken = null;
      _pwCodeCtrl.clear();
      _startPwTimer();
      _showSnack("휴대폰 인증번호가 전송되었습니다.");
    } catch (e) {
      _showSnack("전송 실패: $e");
    }

    setState(() => _pwSending = false);
  }

  Future<void> _verifyPwCode() async {
    final phone = _pwPhoneCtrl.text.replaceAll(RegExp(r'\D'), '');
    final code = _pwCodeCtrl.text.trim();

    if (phone.isEmpty || code.isEmpty) {
      return _showSnack("휴대폰 번호와 인증번호를 입력해주세요.");
    }

    setState(() => _pwVerifying = true);

    try {
      final token = await _auth.verifyPhoneCode(phone: phone, code: code);
      _pwVerified = true;
      _pwToken = token;
      _showSnack("휴대폰 인증 완료!");
    } catch (e) {
      _showSnack("인증 실패: $e");
    }

    setState(() => _pwVerifying = false);
  }

  Future<void> _savePassword() async {
    if (!_pwVerified || _pwToken == null) {
      return _showSnack("휴대폰 인증을 먼저 완료해주세요.");
    }

    final oldPw = _oldPwCtrl.text.trim();
    final newPw = _newPwCtrl.text.trim();
    final confirm = _newPwConfirmCtrl.text.trim();

    if (oldPw.isEmpty || newPw.isEmpty || confirm.isEmpty) {
      return _showSnack("모든 비밀번호 입력란을 채워주세요.");
    }

    setState(() => _pwSaving = true);

    try {
      await _auth.changePassword(
        oldPassword: oldPw,
        newPassword: newPw,
        newPasswordConfirm: confirm,
        phoneVerifiedToken: _pwToken!,
      );

      _oldPwCtrl.clear();
      _newPwCtrl.clear();
      _newPwConfirmCtrl.clear();
      _pwCodeCtrl.clear();

      _showSnack("비밀번호가 변경되었습니다.");
    } catch (e) {
      _showSnack("변경 실패: $e");
    }

    setState(() => _pwSaving = false);
  }

  // --
  // SAVE ALL
  // --
  void _saveAll() {
    final basicDirty =
        _displayNameCtrl.text.trim() != _initialDisplayName ||
            _phoneCtrl.text.trim() != _initialPhone;

    final emailDirty =
        _emailCtrl.text.trim().isNotEmpty &&
            _emailCtrl.text.trim() != _currentEmail;

    final pwDirty =
        _oldPwCtrl.text.isNotEmpty ||
            _newPwCtrl.text.isNotEmpty ||
            _newPwConfirmCtrl.text.isNotEmpty;

    if (basicDirty || emailDirty || pwDirty) {
      return _showSnack("각 섹션의 개별 저장을 먼저 완료해주세요.");
    }

    _showSnack("전체 저장이 완료되었습니다.");
    Navigator.pop(context);
  }
  // --
  // UI BUILD
  // --
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: DotoriTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "마이페이지",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: DotoriTheme.brownDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 18),
            _buildBasicSection(),
            const SizedBox(height: 18),
            _buildEmailSection(),
            const SizedBox(height: 18),
            _buildPasswordSection(),
            const SizedBox(height: 26),
            DotoriButton(
              text: "전체 저장하기",
              onPressed: _saveAll,
              icon: Icons.check_circle_outline,
            ),
          ],
        ),
      ),
    );
  }

  // --
  // PROFILE HEADER
  // --
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DotoriTheme.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: DotoriTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DotoriTheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person_outline,
              color: DotoriTheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("내 정보 관리",
                    style: DotoriTheme.subtitle.copyWith(fontSize: 18)),
                const SizedBox(height: 4),
                Text(
                  "프로필, 이메일, 비밀번호를 관리할 수 있어요.",
                  style: DotoriTheme.body.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --
  // BASIC INFO SECTION
  // --
  Widget _buildBasicSection() {
    return _sectionCard(
      title: "기본 정보",
      caption: "닉네임 / 휴대폰 번호 / 프로필 사진 변경",
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage:
                  _profileImagePath.isNotEmpty ? NetworkImage(_profileImagePath) : null,
              child: _profileImagePath.isEmpty
                  ? const Icon(Icons.person, size: 32)
                  : null,
            ),
            const SizedBox(width: 12),
            DotoriButton(
              text: "사진 변경",
              icon: Icons.camera_alt_outlined,
              outlined: true,
              onPressed: _changePhoto,
            ),
          ],
        ),
        const SizedBox(height: 14),

        TextField(
          controller: _displayNameCtrl,
          decoration: const InputDecoration(
            labelText: "닉네임",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

        TextField(
          controller: _phoneCtrl,
          keyboardType: TextInputType.phone,
          onChanged: _onPhoneChanged,
          decoration: const InputDecoration(
            labelText: "휴대폰 번호",
            hintText: "010-1234-5678",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),

        DotoriButton(
          text: "기본 정보 저장",
          onPressed: _savingBasic ? null : _saveBasic,
          loading: _savingBasic,
        ),
      ],
    );
  }

  // --
  // EMAIL SECTION
  // --
  Widget _buildEmailSection() {
    return _sectionCard(
      title: "이메일 변경",
      caption: "로그인용 이메일을 변경할 수 있어요.",
      children: [
        Text(
          "현재 이메일: $_currentEmail",
          style: DotoriTheme.body.copyWith(color: Colors.black87),
        ),
        const SizedBox(height: 14),

        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: "새 이메일",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _emailCodeCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "인증번호",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                DotoriButton(
                  text: "보내기",
                  onPressed: _emailSending ? null : _sendEmailCode,
                  loading: _emailSending,
                ),
                const SizedBox(height: 6),
                DotoriButton(
                  text: "확인",
                  outlined: true,
                  onPressed: _emailVerifying ? null : _verifyEmailCode,
                  loading: _emailVerifying,
                ),
              ],
            ),
          ],
        ),

        if (_emailSeconds > 0) ...[
          const SizedBox(height: 8),
          Text(
            "남은 시간: $_emailSeconds초",
            style: DotoriTheme.body.copyWith(color: Colors.black87),
          ),
        ],

        if (_emailVerified) ...[
          const SizedBox(height: 6),
          Text(
            "이메일 인증 완료!",
            style: DotoriTheme.subtitle.copyWith(color: Colors.green),
          ),
        ],

        const SizedBox(height: 14),

        DotoriButton(
          text: "이메일 저장",
          onPressed: _emailSaving ? null : _saveEmail,
          loading: _emailSaving,
        ),
      ],
    );
  }

  // --
  // PASSWORD SECTION — includes phone verification
  // --
  Widget _buildPasswordSection() {
    return _sectionCard(
      title: "비밀번호 변경",
      caption: "휴대폰 인증 후 비밀번호 변경을 진행할 수 있어요.",
      children: [
        // Phone input (NEW)
        TextField(
          controller: _pwPhoneCtrl,
          keyboardType: TextInputType.phone,
          onChanged: _onPwPhoneChanged,
          decoration: const InputDecoration(
            labelText: "휴대폰 번호 (인증번호 받을 번호)",
            hintText: "010-1234-5678",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

        // 인증번호 입력 + 보내기/확인 버튼
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _pwCodeCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "휴대폰 인증번호",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),

            Column(
              children: [
                DotoriButton(
                  text: "보내기",
                  onPressed: (_pwSending || _pwSendLocked) ? null : _sendPwCode,
                  loading: _pwSending,
                ),
                const SizedBox(height: 6),
                DotoriButton(
                  text: "확인",
                  outlined: true,
                  onPressed: _pwVerifying ? null : _verifyPwCode,
                  loading: _pwVerifying,
                ),
              ],
            ),
          ],
        ),

        if (_pwSeconds > 0) ...[
          const SizedBox(height: 8),
          Text(
            "남은 시간: $_pwSeconds초",
            style: DotoriTheme.body.copyWith(color: Colors.black87),
          ),
        ],

        if (_pwVerified) ...[
          const SizedBox(height: 6),
          Text(
            "휴대폰 인증 완료!",
            style: DotoriTheme.subtitle.copyWith(color: Colors.green),
          ),
        ],

        const SizedBox(height: 14),

        TextField(
          controller: _oldPwCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "현재 비밀번호",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

        TextField(
          controller: _newPwCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "새 비밀번호",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),

        TextField(
          controller: _newPwConfirmCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "새 비밀번호 확인",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),

        DotoriButton(
          text: "비밀번호 저장",
          onPressed: _pwSaving ? null : _savePassword,
          loading: _pwSaving,
        ),
      ],
    );
  }

  // --
  // SECTION CARD TEMPLATE
  // --
  Widget _sectionCard({
    required String title,
    String? caption,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DotoriTheme.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: DotoriTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: DotoriTheme.subtitle.copyWith(fontSize: 17)),
          if (caption != null) ...[
            const SizedBox(height: 4),
            Text(
              caption,
              style: DotoriTheme.body.copyWith(color: Colors.black54),
            ),
          ],
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  // --
  // DISPOSE
  // --
  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _emailCodeCtrl.dispose();
    _pwPhoneCtrl.dispose();
    _pwCodeCtrl.dispose();
    _oldPwCtrl.dispose();
    _newPwCtrl.dispose();
    _newPwConfirmCtrl.dispose();
    _emailTimer?.cancel();
    _pwTimer?.cancel();
    super.dispose();
  }
}
