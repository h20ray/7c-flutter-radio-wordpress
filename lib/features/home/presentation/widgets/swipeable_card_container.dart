import 'package:flutter/material.dart';

import '../../../../core/themes/design_tokens.dart';
import 'radio_now_playing_card.dart';
import 'status_game_progress_card.dart';

class SwipeableCardContainer extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  const SwipeableCardContainer({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  State<SwipeableCardContainer> createState() => _SwipeableCardContainerState();
}

class _SwipeableCardContainerState extends State<SwipeableCardContainer> {
  late PageController _pageController;
  bool _isUserSwiping = false;
  static const int _itemCount = 2;
  static const int _initialPage = 1000;

  double get _fixedCardHeight => DesignTokens.cardHeightStandard;

  @override
  void initState() {
    super.initState();
    final initialPage = _initialPage + widget.selectedIndex;
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void didUpdateWidget(SwipeableCardContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex && !_isUserSwiping) {
      if (_pageController.hasClients) {
        final currentPage = _pageController.page?.round() ?? _initialPage;
        final targetPage = _initialPage + widget.selectedIndex;
        final diff = (targetPage - currentPage).abs();

        if (diff > _itemCount) {
          _pageController.jumpToPage(targetPage);
        } else {
          _pageController.animateToPage(
            targetPage,
            duration: DesignTokens.animationDurationMedium,
            curve: DesignTokens.animationCurveSpring,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _getRealIndex(int pageIndex) {
    return pageIndex % _itemCount;
  }

  void _onPageChanged(int index) {
    final realIndex = _getRealIndex(index);

    if (realIndex != widget.selectedIndex) {
      _isUserSwiping = true;
      widget.onIndexChanged(realIndex);
      Future.delayed(DesignTokens.animationDurationMedium, () {
        if (mounted) {
          _isUserSwiping = false;
        }
      });
    }

    if (index < _initialPage - _itemCount ||
        index > _initialPage + _itemCount * 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          final targetPage = _initialPage + realIndex;
          _pageController.jumpToPage(targetPage);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: DesignTokens.spacingM),
      child: SizedBox(
        height: _fixedCardHeight - (DesignTokens.spacingXl * 2),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -DesignTokens.spacingXl * 2,
              left: 0,
              right: 0,
              height: _fixedCardHeight,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final realIndex = _getRealIndex(index);
                  return _CardWrapper(
                    height: _fixedCardHeight,
                    child: realIndex == 0
                        ? const RadioNowPlayingCard(skipWrapper: true)
                        : const StatusGameProgressCard(skipWrapper: true),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardWrapper extends StatelessWidget {
  final double height;
  final Widget child;

  const _CardWrapper({required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: double.infinity, child: child);
  }
}
