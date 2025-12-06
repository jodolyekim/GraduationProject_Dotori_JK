<<<<<<< HEAD
=======
// import 'package:flutter/material.dart';

// class LandingScreen extends StatelessWidget {
//   const LandingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context).textTheme;
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.park, size: 80),
//                 const SizedBox(height: 12),
//                 Text('도토리',
//                     style: theme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 40),
//                 SizedBox(
//                   width: 280,
//                   child: FilledButton(
//                     onPressed: () => Navigator.pushNamed(context, '/login'),
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 14),
//                       child: Text('로그인하기'),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 SizedBox(
//                   width: 280,
//                   child: OutlinedButton(
//                     onPressed: () => Navigator.pushNamed(context, '/register'),
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 14),
//                       child: Text('회원가입하기'),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Opacity(opacity: 0.6, child: Text('간편로그인은 곧 지원됩니다')),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

>>>>>>> clean-summary-2_flutter
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.park, size: 80),
                const SizedBox(height: 12),
                Text('도토리',
                    style: theme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                SizedBox(
                  width: 280,
                  child: FilledButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('로그인하기'),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 280,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('회원가입하기'),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Opacity(opacity: 0.6, child: Text('간편로그인은 곧 지원됩니다')),
              ],
            ),
          ),
=======
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // 도토리 느낌 아이보리 배경
      body: SafeArea(
        child: Stack(
          children: [
            // 배경 장식 - 도토리 브라운 계열 부드러운 원
            Positioned(
              top: -140,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFD6A56D), // 연브라운
                      Color(0xFFA8763E), // 중간 브라운
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -150,
              right: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFF0C08A),
                      Color(0xFFD89A5B),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),

            // 실제 내용
            Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //  도토리 로고 이미지
                    Container(
                      width: 120,
                      height: 120,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                            color: Colors.brown.withOpacity(0.15),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/dotori_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // 앱 타이틀
                    Text(
                      '도토리',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                            color: const Color(0xFF7A4F23), // 진한 브라운
                          ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      '인생의 동반자, 도토리와 함께하세요.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.brown.shade600,
                            fontSize: 15,
                          ),
                    ),

                    const SizedBox(height: 48),

                    //  로그인 버튼
                    SizedBox(
                      width: 280,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7A4F23), // 진한 도토리색
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: const Text(
                          '로그인하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    //  회원가입 버튼
                    SizedBox(
                      width: 280,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color(0xFF7A4F23),
                            width: 1.4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                        child: const Text(
                          '회원가입하기',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF7A4F23),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Opacity(
                      opacity: 0.55,
                      child: Text(
                        '간편로그인은 곧 지원됩니다',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.brown.shade500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
>>>>>>> clean-summary-2_flutter
        ),
      ),
    );
  }
}
<<<<<<< HEAD
=======

>>>>>>> clean-summary-2_flutter
