// lib/widgets/home_section_title.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomeSectionTitle extends StatelessWidget {
  final String title;

  const HomeSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 24,
          decoration: BoxDecoration(
            color: DotoriTheme.brownDark,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: DotoriTheme.titleLarge.copyWith(fontSize: 20),
        ),
      ],
    );
  }
}
