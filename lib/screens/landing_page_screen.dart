import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'category_menu_screen.dart';
import 'settings_screen.dart';
import '../widgets/parental_gate_dialog.dart';
import '../services/app_settings.dart';
import '../services/audio_service.dart';

class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  @override
  State<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> with SingleTickerProviderStateMixin {
  final AppSettings _settings = AppSettings();
  final AudioService _audio = AudioService();

  @override
  void initState() {
    super.initState();
    _settings.onSettingsChanged = () {
      if (mounted) setState(() {});
    };

    // Initialize background music
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _audio.initialize();
    });
  }

  void _showParentalGate() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ParentalGateDialog(
        onGSuccess: () {
          // Fixed: Small delay ensures the dialog is fully popped before showing the sheet
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              showModalBottomSheet(
                context: this.context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const SettingsScreen(),
              );
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Premium Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF81D4FA), // Light Sky Blue
                  Color(0xFF0288D1), // Deep Sky Blue
                  Color(0xFF01579B), // Darker Blue for depth
                ],
              ),
            ),
          ),

          // Decorative Sunshine
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.3),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
                gradient: const RadialGradient(
                  colors: [Colors.yellow, Colors.transparent],
                ),
              ),
            ),
          ),

          // Animated Clouds Decorations
          const Positioned(top: 100, left: -20, child: _AnimatedCloud(scale: 1.2)),
          const Positioned(top: 250, right: -30, child: _AnimatedCloud(scale: 0.8)),
          const Positioned(bottom: 200, left: 40, child: _AnimatedCloud(scale: 0.6)),

          // Corner Buttons with premium styling
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CornerButton(
                    icon: Icons.settings_rounded,
                    color: Colors.orangeAccent,
                    onTap: _showParentalGate,
                  ),
                  _CornerButton(
                    icon: _settings.isMusicEnabled ? Icons.music_note_rounded : Icons.music_off_rounded,
                    color: _settings.isMusicEnabled ? Colors.greenAccent : Colors.redAccent,
                    onTap: () {
                      _settings.updateSettings(music: !_settings.isMusicEnabled);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Center Content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  // Character Mascot with bounce and float
                  _HeroMascot(size: size.height * 0.22),
                  const SizedBox(height: 20),
                  
                  // App Title with premium font styling
                  Text(
                    'KidQuest',
                    style: GoogleFonts.bangers(
                      fontSize: 84,
                      color: Colors.white,
                      letterSpacing: 4,
                      shadows: [
                        const Shadow(offset: Offset(4, 4), blurRadius: 10, color: Colors.black26),
                        Shadow(offset: const Offset(-2, -2), blurRadius: 4, color: Colors.blue.shade900),
                      ],
                    ),
                  ),
                  
                  Text(
                    'Adventure in Learning!',
                    style: GoogleFonts.baloo2(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // PLAY BUTTON - The main attraction
                  const _PremiumPlayButton(),
                  
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCloud extends StatefulWidget {
  final double scale;
  const _AnimatedCloud({required this.scale});

  @override
  State<_AnimatedCloud> createState() => _AnimatedCloudState();
}

class _AnimatedCloudState extends State<_AnimatedCloud> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(_animation.value, 0),
        child: Opacity(
          opacity: 0.4,
          child: Transform.scale(
            scale: widget.scale,
            child: const Icon(Icons.cloud_rounded, size: 100, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _HeroMascot extends StatefulWidget {
  final double size;
  const _HeroMascot({required this.size});

  @override
  State<_HeroMascot> createState() => _HeroMascotState();
}

class _HeroMascotState extends State<_HeroMascot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnim,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _floatAnim.value),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 30,
              )
            ],
          ),
          child: Image.asset(
            'assets/images/mascot.png',
            errorBuilder: (c, e, s) => const Icon(Icons.face_retouching_natural, size: 150, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _CornerButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CornerButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }
}

class _PremiumPlayButton extends StatefulWidget {
  const _PremiumPlayButton();

  @override
  State<_PremiumPlayButton> createState() => _PremiumPlayButtonState();
}

class _PremiumPlayButtonState extends State<_PremiumPlayButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const CategoryMenuScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                  ),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      },
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 25),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF5252), Color(0xFFFF1744)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(color: const Color(0xFFFF1744).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10)),
              BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 10, offset: const Offset(-2, -2)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 48),
              const SizedBox(width: 10),
              Text(
                'PLAY',
                style: GoogleFonts.bangers(
                  fontSize: 48,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

