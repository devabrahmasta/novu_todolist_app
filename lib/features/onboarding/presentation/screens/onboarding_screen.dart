import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/novu_colors_extension.dart';
import '../../../profile/presentation/providers/settings_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.auto_awesome_rounded,
      'title': 'Welcome to Novu',
      'subtitle': 'A serene space to organize your thoughts, tasks, and habits.',
    },
    {
      'icon': Icons.check_circle_outline_rounded,
      'title': 'Tasks Made Simple',
      'subtitle': 'Focus on what matters. Organize your day into morning, afternoon, and evening blocks.',
    },
    {
      'icon': Icons.loop_rounded,
      'title': 'Build Consistency',
      'subtitle': 'Track your habits daily. Measure progress over time with streaks and insights.',
    },
    {
      'icon': Icons.book_outlined,
      'title': 'Reflect Daily',
      'subtitle': 'Capture your mood and thoughts. Look back on your journey with the daily journal.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
    ref.read(settingsNotifierProvider.notifier).completeOnboarding();
    context.goNamed(RouteNames.home);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skip() {
    _finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 24, 0),
                child: TextButton(
                  onPressed: _skip,
                  style: TextButton.styleFrom(
                    foregroundColor: colors.textSecondary,
                  ),
                  child: Text(
                    'Skip',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPageContent(
                    context,
                    _pages[index]['icon'] as IconData,
                    _pages[index]['title'] as String,
                    _pages[index]['subtitle'] as String,
                  );
                },
              ),
            ),

            // Bottom Nav (Indicators + FAB)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot Indicators
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => _buildDotIndicator(index, context),
                    ),
                  ),

                  // Next / Get Started FAB
                  FloatingActionButton(
                    onPressed: _nextPage,
                    elevation: 0,
                    backgroundColor: colors.textPrimary,
                    foregroundColor: colors.bg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _currentPage == _pages.length - 1
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final colors = context.novuColors;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Icon(
              icon,
              size: 40,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: textTheme.bodyLarge?.copyWith(
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(int index, BuildContext context) {
    final colors = context.novuColors;
    final isSelected = _currentPage == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: isSelected ? 24 : 8,
      decoration: BoxDecoration(
        color: isSelected ? colors.textPrimary : colors.border,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
