
<<<<<<< HEAD
=======
// import 'package:flutter/material.dart';
// import 'package:dotori_client/services/auth_service.dart';
// import 'package:dotori_client/screens/login_screen.dart';
// import 'package:dotori_client/screens/home_screen.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   final _auth = AuthService();

//   @override
//   void initState() {
//     super.initState();
//     _check();
//   }

//   Future<void> _check() async {
//     final ok = await _auth.isLoggedIn();
//     if (!mounted) return;
//     if (ok) {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
//     } else {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
// lib/screens/splash_screen.dart
>>>>>>> clean-summary-2_flutter
import 'package:flutter/material.dart';
import 'package:dotori_client/services/auth_service.dart';
import 'package:dotori_client/screens/login_screen.dart';
import 'package:dotori_client/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
<<<<<<< HEAD
    final ok = await _auth.isLoggedIn();
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
=======
    // 살짝 딜레이 주면 스플래시가 너무 순삭으로 안 넘어감
    await Future.delayed(const Duration(milliseconds: 700));

    final ok = await _auth.isLoggedIn();
    if (!mounted) return;

    if (ok) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
>>>>>>> clean-summary-2_flutter
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
=======
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF171717),
              Color(0xFF1F2933),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고 원
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6366F1),
                        Color(0xFFEC4899),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shield_moon_outlined,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Dotori Guard',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'AI 생성물·딥페이크를\n한 번에 점검하는 보조 도구',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF818CF8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
>>>>>>> clean-summary-2_flutter
    );
  }
}
