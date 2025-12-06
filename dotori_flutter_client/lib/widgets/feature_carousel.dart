// lib/widgets/feature_carousel.dart

import 'package:flutter/material.dart';
import 'feature_carousel_item.dart';

/// 홈에서 쓸 기능 아이템 모델
class FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

/// 틴더 느낌의 가로 캐러셀
/// - 항상 가운데 카드가 가장 크고 양 옆은 살짝 작게
/// - 좌우로 플릭하면 카드가 한 장씩 넘어감
/// - 끝까지 가도 다시 처음/중간으로 자연스럽게 이어지는 구조
class FeatureCarousel extends StatefulWidget {
  final List<FeatureItem> items;

  const FeatureCarousel({super.key, required this.items});

  @override
  State<FeatureCarousel> createState() => _FeatureCarouselState();
}

class _FeatureCarouselState extends State<FeatureCarousel> {
  static const int _loopCount = 10000; // 사실상 무한 루프 느낌
  late final PageController _pageController;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();

    if (widget.items.isEmpty) return;

    // 중간쯤에서 시작해서 양쪽으로 계속 넘길 수 있게
    final mid = _loopCount ~/ 2;
    final initialPage = mid - (mid % widget.items.length);

    _pageController = PageController(
      viewportFraction: 0.55, // 한 화면에 3장 정도 보이게
      initialPage: initialPage,
    );

    _currentPage = initialPage.toDouble();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? _currentPage;
      });
    });
  }

  @override
  void dispose() {
    if (widget.items.isNotEmpty) {
      _pageController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 230,
      child: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: _loopCount, // 크게 잡아서 사실상 무한
        itemBuilder: (context, index) {
          final realIndex = index % widget.items.length;
          final item = widget.items[realIndex];

          // 가운데 카드는 크게, 옆으로 갈수록 살짝 작게/옅게
          final diff = (_currentPage - index).abs();
          final scale = (1.0 - diff * 0.2).clamp(0.85, 1.0);
          final opacity = (1.0 - diff * 0.4).clamp(0.55, 1.0);

          return Center(
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: FeatureCarouselItem(
                  icon: item.icon,
                  title: item.title,
                  subtitle: item.subtitle,
                  onTap: item.onTap,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
