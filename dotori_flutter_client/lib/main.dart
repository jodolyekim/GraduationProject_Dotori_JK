<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

=======
// import 'package:flutter/material.dart';

// import 'screens/landing_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/register_screen.dart';
// import 'screens/home_screen.dart';
// import 'screens/quiz_screen.dart';
// import 'screens/roleplay_screen.dart';

// import 'screens/membership_screen.dart';
// import 'screens/point_screen.dart';

// // 🔽 새로 추가된 "분석 화면"
// import 'screens/analytics/user_analytics_screen.dart';
// import 'screens/analytics/admin_analytics_screen.dart';

// import 'services/auth_service.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const DotoriApp());
// }

// class DotoriApp extends StatefulWidget {
//   const DotoriApp({super.key});

//   @override
//   State<DotoriApp> createState() => _DotoriAppState();
// }

// class _DotoriAppState extends State<DotoriApp> {
//   bool _booting = true;
//   bool _loggedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     _bootstrap();
//   }

//   Future<void> _bootstrap() async {
//     // 자동 로그인
//     final ok = await AuthService().autoLoginIfPossible();
//     _loggedIn = ok;

//     if (mounted) setState(() => _booting = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = ThemeData(
//       colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF795548)),
//       useMaterial3: true,
//     );

//     // 부팅 중
//     if (_booting) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: theme,
//         home: const _BootScreen(),
//       );
//     }

//     // 실제 앱
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: '도토리',
//       theme: theme,
//       home: _loggedIn ? const HomeScreen() : const LandingScreen(),
//       routes: {
//         '/login': (_) => const LoginScreen(),
//         '/register': (_) => const RegisterScreen(),
//         '/home': (_) => const HomeScreen(),

//         // 퀴즈, 역할극
//         '/quiz': (_) => const QuizScreen(difficulty: 'EASY'),
//         '/roleplay': (_) => const RoleplayScreen(),

//         // 멤버십 / 포인트
//         '/membership': (_) => const MembershipScreen(),
//         '/points': (_) => const PointScreen(),

//         //  새로 추가된 분석 라우트
//         '/analytics-user': (_) => const UserAnalyticsScreen(),
//         '/analytics-admin': (_) => const AdminAnalyticsScreen(),
//       },
//     );
//   }
// }

// class _BootScreen extends StatelessWidget {
//   const _BootScreen();

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 12),
//             Text('앱 준비 중...'),
//           ],
//         ),
//       ),
//     );
//   }
// }
// lib/main.dart
// import 'package:flutter/material.dart';

// import 'screens/landing_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/register_screen.dart';
// import 'screens/home_screen.dart';
// import 'screens/quiz_screen.dart';
// import 'screens/roleplay_screen.dart';
// import 'screens/membership_screen.dart';
// import 'screens/point_screen.dart';

// // 🔽 분석 화면
// import 'screens/analytics/user_analytics_screen.dart';
// import 'screens/analytics/admin_analytics_screen.dart';

// import 'services/auth_service.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const DotoriApp());
// }

// class DotoriApp extends StatefulWidget {
//   const DotoriApp({super.key});

//   @override
//   State<DotoriApp> createState() => _DotoriAppState();
// }

// class _DotoriAppState extends State<DotoriApp> {
//   bool _booting = true;
//   bool _loggedIn = false;

//   @override
//   void initState() {
//     super.initState();
//     _bootstrap();
//   }

//   Future<void> _bootstrap() async {
//     // 자동 로그인 시도
//     final ok = await AuthService().autoLoginIfPossible();
//     _loggedIn = ok;

//     if (mounted) {
//       setState(() => _booting = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = ColorScheme.fromSeed(
//       seedColor: const Color(0xFF8B5A2B), // 도토리 느낌 브라운
//       brightness: Brightness.dark,
//     );

//     final theme = ThemeData(
//       useMaterial3: true,
//       colorScheme: colorScheme,
//       scaffoldBackgroundColor: const Color(0xFF050816),
//       appBarTheme: const AppBarTheme(
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         surfaceTintColor: Colors.transparent,
//       ),
//       cardTheme: CardTheme(
//         color: const Color(0xFF0B1020).withOpacity(0.96),
//         elevation: 0,
//         margin: EdgeInsets.zero,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: BorderSide(
//             color: Colors.white.withOpacity(0.04),
//           ),
//         ),
//       ),
//       dialogTheme: DialogTheme(
//         backgroundColor: const Color(0xFF0B1020),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: colorScheme.primary,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(999),
//           ),
//           textStyle: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 15,
//           ),
//         ),
//       ),
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           foregroundColor: Colors.white,
//           side: BorderSide(color: Colors.white.withOpacity(0.3)),
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(999),
//           ),
//           textStyle: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: colorScheme.primary,
//           textStyle: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: const Color(0xFF151A2B),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
//         ),
//         hintStyle: TextStyle(
//           color: Colors.white.withOpacity(0.45),
//           fontSize: 13,
//         ),
//         labelStyle: const TextStyle(
//           color: Colors.white70,
//           fontSize: 13,
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       ),
//       snackBarTheme: SnackBarThemeData(
//         backgroundColor: const Color(0xFF151A2B),
//         contentTextStyle: const TextStyle(color: Colors.white),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//       ),
//       dividerColor: Colors.white.withOpacity(0.08),
//       listTileTheme: ListTileThemeData(
//         iconColor: Colors.white.withOpacity(0.9),
//         textColor: Colors.white,
//       ),
//       textTheme: const TextTheme(
//         displaySmall: TextStyle(
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//         titleLarge: TextStyle(
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//         titleMedium: TextStyle(
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//         bodyMedium: TextStyle(
//           color: Colors.white70,
//           fontSize: 14,
//         ),
//         bodySmall: TextStyle(
//           color: Colors.white60,
//           fontSize: 12,
//         ),
//       ),
//       pageTransitionsTheme: const PageTransitionsTheme(
//         builders: {
//           TargetPlatform.android: CupertinoPageTransitionsBuilder(),
//           TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
//           TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
//           TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
//           TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
//         },
//       ),
//     );

//     if (_booting) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: theme,
//         home: const _BootScreen(),
//       );
//     }

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: '도토리',
//       theme: theme,
//       home: _loggedIn ? const HomeScreen() : const LandingScreen(),
//       routes: {
//         '/login': (_) => const LoginScreen(),
//         '/register': (_) => const RegisterScreen(),
//         '/home': (_) => const HomeScreen(),

//         // 퀴즈, 역할극
//         '/quiz': (_) => const QuizScreen(difficulty: 'EASY'),
//         '/roleplay': (_) => const RoleplayScreen(),

//         // 멤버십 / 포인트
//         '/membership': (_) => const MembershipScreen(),
//         '/points': (_) => const PointScreen(),

//         // 분석 라우트
//         '/analytics-user': (_) => const UserAnalyticsScreen(),
//         '/analytics-admin': (_) => const AdminAnalyticsScreen(),
//       },
//     );
//   }
// }

// class _BootScreen extends StatelessWidget {
//   const _BootScreen();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context).textTheme;

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF050816),
//               Color(0xFF151A2B),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(24),
//                   border: Border.all(
//                     color: Colors.white.withOpacity(0.08),
//                   ),
//                 ),
//                 child: const Icon(
//                   Icons.park,
//                   size: 40,
//                   color: Color(0xFFF5D08A),
//                 ),
//               ),
//               const SizedBox(height: 18),
//               Text(
//                 '도토리 준비 중...',
//                 style: theme.titleMedium,
//               ),
//               const SizedBox(height: 10),
//               const SizedBox(
//                 width: 26,
//                 height: 26,
//                 child: CircularProgressIndicator(strokeWidth: 2.4),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

//  Screens
>>>>>>> clean-summary-2_flutter
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
<<<<<<< HEAD
=======
import 'screens/quiz_screen.dart';
import 'screens/roleplay_screen.dart';
import 'screens/membership_screen.dart';
import 'screens/point_screen.dart';
import 'screens/summary_screen.dart';
import 'screens/analytics/user_analytics_screen.dart';
import 'screens/analytics/admin_analytics_screen.dart';
>>>>>>> clean-summary-2_flutter

import 'services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DotoriApp());
}

class DotoriApp extends StatefulWidget {
  const DotoriApp({super.key});

  @override
  State<DotoriApp> createState() => _DotoriAppState();
}

class _DotoriAppState extends State<DotoriApp> {
  bool _booting = true;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
<<<<<<< HEAD
    // 자동로그인 설정(true) && refresh 토큰 있으면 갱신 시도
    final ok = await AuthService().autoLoginIfPossible();
    _loggedIn = ok;
    if (mounted) setState(() => _booting = false);
=======
    final ok = await AuthService().autoLoginIfPossible();
    _loggedIn = ok;

    if (mounted) {
      setState(() => _booting = false);
    }
>>>>>>> clean-summary-2_flutter
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF795548)),
      useMaterial3: true,
    );

=======
    //  Dotori 라이트 테마 (전체 화면이 보이도록 완전 재구성)
    final theme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      primaryColor: const Color(0xFF4460F1),
      scaffoldBackgroundColor: const Color(0xFFF4F6FA),

      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4460F1),
        brightness: Brightness.light,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),

      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black12,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      iconTheme: const IconThemeData(
        color: Color(0xFF4460F1),
        size: 24,
      ),

      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: Colors.black54,
          fontSize: 12,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4460F1),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF4460F1),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          side: const BorderSide(color: Colors.black26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF4460F1), width: 1.5),
        ),
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.35),
        ),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.black87,
        contentTextStyle: TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),

      dividerColor: Colors.black12,
    );

    //  부팅 화면
>>>>>>> clean-summary-2_flutter
    if (_booting) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const _BootScreen(),
      );
    }

<<<<<<< HEAD
=======
    //  로그인 완료 후 라우팅
>>>>>>> clean-summary-2_flutter
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '도토리',
      theme: theme,
<<<<<<< HEAD
      // ✅ 홈 위젯을 항상 제공해서 null 경로가 없게 함
=======
>>>>>>> clean-summary-2_flutter
      home: _loggedIn ? const HomeScreen() : const LandingScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
<<<<<<< HEAD
=======
        '/quiz': (_) => const QuizScreen(difficulty: 'EASY'),
        '/roleplay': (_) => const RoleplayScreen(),
        '/membership': (_) => const MembershipScreen(),
        '/points': (_) => const PointScreen(),
        '/analytics-user': (_) => const UserAnalyticsScreen(),
        '/analytics-admin': (_) => const AdminAnalyticsScreen(),
        '/summary': (_) => const SummaryScreen(),
>>>>>>> clean-summary-2_flutter
      },
    );
  }
}

<<<<<<< HEAD
=======
///  새롭게 수정된 부트 화면 (라이트 테마에 맞게 단순화)
>>>>>>> clean-summary-2_flutter
class _BootScreen extends StatelessWidget {
  const _BootScreen();

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return const Scaffold(
=======
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
>>>>>>> clean-summary-2_flutter
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
<<<<<<< HEAD
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('앱 준비 중...'),
=======
            const CircularProgressIndicator(color: Color(0xFF4460F1)),
            const SizedBox(height: 16),
            Text("도토리 준비 중...", style: theme.titleMedium),
>>>>>>> clean-summary-2_flutter
          ],
        ),
      ),
    );
  }
}
