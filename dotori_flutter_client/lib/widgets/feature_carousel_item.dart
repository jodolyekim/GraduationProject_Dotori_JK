// lib/widgets/feature_carousel_item.dart

import 'package:flutter/material.dart';

/// 기능 1개 정보
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

/// 메인 캐러셀 (3장 중 가운데 강조 + 좌우 화살표)
class FeatureCarousel extends StatefulWidget {
  final List<FeatureItem> items;

  const FeatureCarousel({super.key, required this.items});

  @override
  State<FeatureCarousel> createState() => _FeatureCarouselState();
}

class _FeatureCarouselState extends State<FeatureCarousel> {
  static const int _initialPage = 1000;
  final double _viewportFraction = 0.72;

  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      viewportFraction: _viewportFraction,
      initialPage: _initialPage,
    );
    super.initState();
  }

  /// 실제 아이템 index
  int _realIndex(int page) {
    return page % widget.items.length;
  }

  /// 오른쪽(다음)
  void _next() {
    final nextPage = _pageController.page!.toInt() + 1;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  /// 왼쪽(이전)
  void _prev() {
    final prevPage = _pageController.page!.toInt() - 1;
    _pageController.animateToPage(
      prevPage,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox();

    return SizedBox(
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          //  캐러셀 카드 
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, pageIndex) {
              final index = _realIndex(pageIndex);

              /// distance → 중앙에서 얼마나 떨어져 있는지
              double distance = 0;
              if (_pageController.hasClients) {
                final currentPage =
                    _pageController.page ?? _initialPage.toDouble();
                distance = (currentPage - pageIndex.toDouble()).abs();
              }
              distance = distance.clamp(0.0, 1.0);

              final scale = 1.0 - (0.1 * distance);
              final opacity = 1.0 - (0.4 * distance);

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: FeatureCarouselItem(
                    icon: widget.items[index].icon,
                    title: widget.items[index].title,
                    subtitle: widget.items[index].subtitle,
                    onTap: widget.items[index].onTap,
                  ),
                ),
              );
            },
          ),

          //  왼쪽 화살표 
          Positioned(
            left: 0,
            child: _arrowButton(
              Icons.arrow_back_ios_rounded,
              onTap: _prev,
            ),
          ),

          //  오른쪽 화살표 
          Positioned(
            right: 0,
            child: _arrowButton(
              Icons.arrow_forward_ios_rounded,
              onTap: _next,
            ),
          ),
        ],
      ),
    );
  }

  Widget _arrowButton(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Icon(icon, size: 18, color: Colors.brown.shade600),
      ),
    );
  }
}

/// 단일 카드
class FeatureCarouselItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const FeatureCarouselItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<FeatureCarouselItem> createState() => _FeatureCarouselItemState();
}

class _FeatureCarouselItemState extends State<FeatureCarouselItem> {
  double _scale = 1.0;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final shadowPower = _hover ? 0.32 : 0.18;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.93),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            width: 180,
            padding: const EdgeInsets.all(20),
            duration: const Duration(milliseconds: 220),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFFBF6), Color(0xFFF7EEDD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(shadowPower),
                  blurRadius: _hover ? 26 : 14,
                  spreadRadius: _hover ? 4 : 1,
                  offset: const Offset(0, 7),
                ),
              ],
              //  항상 보이는 테두리 + 호버 시 더 진하고 두껍게
              border: Border.all(
                color: _hover
                    ? const Color(0xFFB4875C).withOpacity(0.9)
                    : const Color(0xFFB4875C).withOpacity(0.55),
                width: _hover ? 2.2 : 1.6,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 36, color: const Color(0xFF7A4F23)),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    color: Color(0xFF7A4F23),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6F5637),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
