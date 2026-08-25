// ============================================================
// lib/screens/subject_selection_screen.dart
// Little Scholars – Subject Selection (per Class)
// ============================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../constants/app_constants.dart';
import '../data/lesson_data.dart';
import 'lesson_list_screen.dart';

class SubjectSelectionScreen extends StatefulWidget {
  final int classNumber;
  const SubjectSelectionScreen({super.key, required this.classNumber});

  @override
  State<SubjectSelectionScreen> createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _cardControllers;

  @override
  void initState() {
    super.initState();
    _cardControllers = List.generate(kSubjects.length, (i) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      Future.delayed(Duration(milliseconds: 100 + i * 90), () {
        if (mounted) c.forward();
      });
      return c;
    });
  }

  @override
  void dispose() {
    for (final c in _cardControllers) c.dispose();
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
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF312E81)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUrdu
                              ? 'جماعت ${_toUrduNumeral(widget.classNumber)}'
                              : 'Class ${widget.classNumber}',
                          style: GoogleFonts.nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          AppStrings.get('select_subject', isUrdu),
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => lang.toggleLanguage(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(
                          isUrdu ? '🇬🇧 EN' : '🇵🇰 UR',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: kSubjects.length,
                    itemBuilder: (context, index) {
                      final subject = kSubjects[index];
                      return SlideTransition(
                        position: Tween<Offset>(
                                begin: Offset(index.isEven ? -1 : 1, 0),
                                end: Offset.zero)
                            .animate(CurvedAnimation(
                          parent: _cardControllers[index],
                          curve: Curves.easeOutBack,
                        )),
                        child: FadeTransition(
                          opacity: _cardControllers[index],
                          child: _SubjectCard(
                            subject: subject,
                            isUrdu: isUrdu,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LessonListScreen(
                                    classNumber: widget.classNumber,
                                    subjectId: subject.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
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
    const u = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    return n.toString().split('').map((d) => u[int.parse(d)]).join();
  }
}

class _SubjectCard extends StatefulWidget {
  final dynamic subject;
  final bool isUrdu;
  final VoidCallback onTap;
  const _SubjectCard(
      {required this.subject, required this.isUrdu, required this.onTap});

  @override
  State<_SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<_SubjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _hoverScale;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _hoverScale = Tween<double>(begin: 1.0, end: 0.94).animate(_hoverCtrl);
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;
    return GestureDetector(
      onTapDown: (_) => _hoverCtrl.forward(),
      onTapUp: (_) async {
        await _hoverCtrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _hoverCtrl.reverse(),
      child: ScaleTransition(
        scale: _hoverScale,
        child: Container(
          decoration: BoxDecoration(
            color: subject.lightColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: subject.color.withOpacity(0.3),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: subject.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: subject.color.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(subject.emoji,
                      style: const TextStyle(fontSize: 35)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subject.getName(widget.isUrdu),
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: subject.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
