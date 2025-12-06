import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomeFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool neumorphism;

  const HomeFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.neumorphism = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        decoration: BoxDecoration(
          color: DotoriTheme.background,
          borderRadius: BorderRadius.circular(26),
          boxShadow: neumorphism
              ? [
                  // 위쪽 하이라이트
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    offset: const Offset(-4, -4),
                    blurRadius: 9,
                  ),
                  // 아래쪽 그림자
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.20),
                    offset: const Offset(6, 6),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: DotoriTheme.brownDark),
            const SizedBox(height: 12),
            Text(
              title,
              style: DotoriTheme.titleLarge.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: DotoriTheme.subtitle.copyWith(
                fontSize: 12,
                color: Colors.brown.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
