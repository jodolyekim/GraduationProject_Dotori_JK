// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class DotoriTheme {
  // 도토리 감성 컬러 팔레트
  static const Color brownDark = Color(0xFF7A4F23);
  static const Color brown = Color(0xFF8B6B3F);
  static const Color brownLight = Color(0xFFD7B894);
  static const Color ivory = Color(0xFFFFF8F0);
  static const Color card = Colors.white;

  // 공통 색상
  static const Color primary = brownDark;
  static const Color background = ivory;

  // 부드러운 그림자
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.brown.withOpacity(0.12),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  // 큰 제목
  static TextStyle titleLarge = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: brownDark,
  );

  // 작은 제목
  static TextStyle subtitle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: brown,
  );

  // 본문
  static TextStyle body = const TextStyle(
    fontSize: 14,
    color: Colors.black87,
  );
}
