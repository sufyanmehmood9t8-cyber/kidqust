// ============================================================
// lib/screens/class_selection_screen.dart
// Little Scholars – Class 1 to 6 Selection Screen
// ============================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../constants/app_constants.dart';
import 'subject_selection_screen.dart';
import 'settings_screen.dart';

class ClassSelectionScreen extends StatefulWidget {
  const ClassSelectionScreen({super.key});
  @override
  State<ClassSelectionScreen> createState() => _ClassSelectionScreenState();
}

class _ClassSelectionScreenState extends State<ClassSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late List<AnimationController> _cardControllers;

  final List<Map<String, dynamic>> _classes = [
    {'emoji': '🎒', 'color': AppColors.classColors[0]},
    {'emoji': '📚', 'color': AppColors.classColors[1]},
    {'emoji': '✏️', 'color': AppColors.classColors[2]},
    {'emoji': '🔬', 'color': AppColors.classColors[3]},
    {'emoji': '🌟', 'color': AppColors.classColors[4]},
    {'emoji': '🎓', 'color': AppColors.classColors[5]},
  ];

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _cardControllers = List.generate(6, (i) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      Future.delayed(Duration(milliseconds: 200 + i * 100), () {
        if (mounted) c.forward();
      });
      return c;
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    for (final c in _cardControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isUrdu = lang.isUrdu;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1B4B), Color(0xFF4C1D95), Color(0xFF6D28D9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('🦉', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 8),
                        Text(
                          'Little Scholars',
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Language Toggle
                        GestureDetector(
                          onTap: () => lang.toggleLanguage(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white30, width: 1),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  isUrdu ? '🇵🇰 اردو' : '🇬🇧 EN',
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SettingsScreen())),
                          icon: const Icon(Icons.settings_rounded,
                              color: Colors.white70, size: 24),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Header
              SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0, -0.5), end: Offset.zero)
                    .animate(CurvedAnimation(
                        parent: _headerController, curve: Curves.easeOut)),
                child: FadeTransition(
                  opacity: _headerController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          AppStrings.get('select_class', isUrdu),
                          style: GoogleFonts.nunito(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isUrdu
                              ? 'اپنی جماعت پر ٹیپ کریں 👇'
                              : 'Tap on your class to start! 👇',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Class Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.05,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final cls = _classes[index];
                      return ScaleTransition(
                        scale: CurvedAnimation(
                          parent: _cardControllers[index],
                          curve: Curves.elasticOut,
                        ),
                        child: _ClassCard(
                          classNumber: index + 1,
                          emoji: cls['emoji'],
                          color: cls['color'],
                          isUrdu: isUrdu,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SubjectSelectionScreen(
                                  classNumber: index + 1,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassCard extends StatefulWidget {
  final int classNumber;
  final String emoji;
  final Color color;
  final bool isUrdu;
  final VoidCallback onTap;

  const _ClassCard({
    required this.classNumber,
    required this.emoji,
    required this.color,
    required this.isUrdu,
    required this.onTap,
  });

  @override
  State<_ClassCard> createState() => _ClassCardState();
}

class _ClassCardState extends State<_ClassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _tapScale;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _tapScale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _tapController.forward(),
      onTapUp: (_) async {
        await _tapController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _tapController.reverse(),
      child: ScaleTransition(
        scale: _tapScale,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color,
                widget.color.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 44)),
              const SizedBox(height: 10),
              Text(
                widget.isUrdu
                    ? '${AppStrings.get('class', true)} ${_toUrduNumeral(widget.classNumber)}'
                    : 'Class ${widget.classNumber}',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.isUrdu ? 'شروع کریں' : 'Start',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _toUrduNumeral(int n) {
    const urduDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    return n.toString().split('').map((d) => urduDigits[int.parse(d)]).join();
  }
}
