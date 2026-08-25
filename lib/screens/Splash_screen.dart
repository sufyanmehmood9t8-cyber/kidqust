// ============================================================
// lib/screens/splash_screen.dart
// Little Scholars – Animated Splash Screen with Owl Mascot
// ============================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../constants/app_constants.dart';
import 'class_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _owlController;
  late AnimationController _starsController;
  late AnimationController _textController;
  late AnimationController _scaleController;

  late Animation<double> _owlBounce;
  late Animation<double> _starsOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _bgScale;

  final List<_StarData> _stars = [
    _StarData(left: 0.05, top: 0.10, size: 20, delay: 0.0),
    _StarData(left: 0.85, top: 0.08, size: 16, delay: 0.3),
    _StarData(left: 0.15, top: 0.30, size: 12, delay: 0.5),
    _StarData(left: 0.80, top: 0.25, size: 18, delay: 0.2),
    _StarData(left: 0.05, top: 0.65, size: 14, delay: 0.6),
    _StarData(left: 0.88, top: 0.60, size: 22, delay: 0.1),
    _StarData(left: 0.40, top: 0.05, size: 10, delay: 0.4),
    _StarData(left: 0.60, top: 0.88, size: 15, delay: 0.7),
    _StarData(left: 0.25, top: 0.80, size: 11, delay: 0.8),
    _StarData(left: 0.70, top: 0.75, size: 13, delay: 0.9),
  ];

  @override
  void initState() {
    super.initState();

    _owlController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _starsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _owlBounce = Tween<double>(begin: 0.0, end: -18.0).animate(
      CurvedAnimation(parent: _owlController, curve: Curves.easeInOut),
    );

    _starsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _starsController, curve: Curves.easeIn),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _textSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _bgScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _runAnimations();
  }

  void _runAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _starsController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ClassSelectionScreen(),
          transitionDuration: const Duration(milliseconds: 700),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.08),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _owlController.dispose();
    _starsController.dispose();
    _textController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge(
            [_owlController, _starsController, _textController]),
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E1B4B),
                  Color(0xFF4C1D95),
                  Color(0xFF7C3AED),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Floating Stars
                ..._stars.map((star) => Positioned(
                      left: size.width * star.left,
                      top: size.height * star.top,
                      child: Opacity(
                        opacity: _starsOpacity.value,
                        child: AnimatedBuilder(
                          animation: _owlController,
                          builder: (ctx, _) => Transform.translate(
                            offset: Offset(
                              0,
                              _owlBounce.value * (0.3 + star.delay * 0.5),
                            ),
                            child: Text(
                              '⭐',
                              style: TextStyle(fontSize: star.size.toDouble()),
                            ),
                          ),
                        ),
                      ),
                    )),

                // Center Content
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Owl Mascot
                      AnimatedBuilder(
                        animation: _owlController,
                        builder: (ctx, _) => Transform.translate(
                          offset: Offset(0, _owlBounce.value),
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.purpleLight.withOpacity(0.4),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text('🦉', style: TextStyle(fontSize: 80)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // App Name
                      Opacity(
                        opacity: _textOpacity.value,
                        child: Transform.translate(
                          offset: Offset(0, _textSlide.value),
                          child: Column(
                            children: [
                              Text(
                                'Little Scholars',
                                style: GoogleFonts.nunito(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      color: AppColors.pink.withOpacity(0.6),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'چھوٹے عالم',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.yellowLight,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Class 1 – 6 • Pakistan',
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  color: Colors.white60,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Loading Dots
                      Opacity(
                        opacity: _textOpacity.value,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (i) {
                            return AnimatedBuilder(
                              animation: _owlController,
                              builder: (ctx, _) {
                                final progress = (_owlController.value + i * 0.33) % 1.0;
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.pink.withOpacity(
                                        0.4 + 0.6 * (progress > 0.5 ? 1 - progress : progress) * 2),
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Tag
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: _textOpacity.value,
                    child: Text(
                      '✨ Learn • Play • Grow ✨',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Colors.white38,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StarData {
  final double left, top, delay;
  final int size;
  const _StarData({
    required this.left,
    required this.top,
    required this.size,
    required this.delay,
  });
}
