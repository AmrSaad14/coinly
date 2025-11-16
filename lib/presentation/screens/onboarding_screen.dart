import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: 'assets/images/onboarding_1.svg',
      title: 'كشك معك أينما كنت',
      description: 'تحكم في كامل نشاطك التجاري من هاتفك',
    ),
    OnboardingData(
      image: 'assets/images/onboarding_2.svg',
      title: 'تابع أرباحك بسهولة',
      description: 'شاهد إيراداتك وتدفقك المالي فوراً',
    ),
    OnboardingData(
      image: 'assets/images/onboarding_3.svg',
      title: 'إدارة فريقك من أي مكان',
      description: 'قم بدعوت موظفيك وتحكم فيهم من مكان واحد',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    AppRouter.pushReplacementNamed(context, AppRouter.phoneAuth);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Centered content area
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // PageView
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          itemCount: _pages.length,
                          itemBuilder: (context, index) {
                            return _OnboardingPage(data: _pages[index]);
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) =>
                              _PageIndicator(isActive: index == _currentPage),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom navigation
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip text (on the right in RTL)
                    GestureDetector(
                      onTap: _completeOnboarding,
                      child: const Text(
                        'تخطي',
                        style: TextStyle(
                          color: AppTheme.primaryTeal,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Next button with progress indicator (on the left in RTL)
                    GestureDetector(
                      onTap: _nextPage,
                      child: _CircularProgressButton(
                        progress: (_currentPage + 1) / _pages.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Expanded(
            child: Center(
              child: SizedBox(
                child: SvgPicture.asset(data.image, fit: BoxFit.contain),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Title
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            data.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryTeal
            : AppTheme.primaryTeal.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _CircularProgressButton extends StatelessWidget {
  final double progress;

  const _CircularProgressButton({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress indicator
          SizedBox(
            width: 64,
            height: 64,
            child: CustomPaint(
              painter: _CircularProgressPainter(
                progress: progress,
                color: AppTheme.primaryTeal,
              ),
            ),
          ),
          // Button
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: AppTheme.primaryTeal,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle (light)
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius - 1.5, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2; // Start from top (-90 degrees)
    final sweepAngle = 2 * math.pi * progress; // Progress angle

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 1.5),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}
