// ============================================================
// lib/screens/lesson_content_screen.dart
// Little Scholars – Lesson Content with TTS Audio Narration
// ============================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../providers/language_provider.dart';
import '../providers/progress_provider.dart';
import '../models/app_models.dart';
import '../constants/app_constants.dart';

class LessonContentScreen extends StatefulWidget {
  final LessonModel lesson;
  final SubjectModel subject;

  const LessonContentScreen({
    super.key,
    required this.lesson,
    required this.subject,
  });

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;
  bool _isCompleted = false;
  late AnimationController _completeController;
  late Animation<double> _completeBounce;

  @override
  void initState() {
    super.initState();
    _completeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _completeBounce = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _completeController, curve: Curves.elasticOut),
    );
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  Future<void> _speak(String text, bool isUrdu) async {
    if (_isSpeaking) {
      await _tts.stop();
      setState(() => _isSpeaking = false);
      return;
    }
    await _tts.setLanguage(isUrdu ? 'ur-PK' : 'en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.1);
    setState(() => _isSpeaking = true);
    await _tts.speak(text);
  }

  Future<void> _markComplete(BuildContext context) async {
    final progress = context.read<ProgressProvider>();
    if (!_isCompleted) {
      await progress.markLessonComplete(widget.lesson.id);
      await progress.addStars(3);
      setState(() => _isCompleted = true);
      _completeController.forward();
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _tts.stop();
    _completeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isUrdu = lang.isUrdu;
    final content = widget.lesson.getContent(isUrdu);
    final subject = widget.subject;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8F7FF),
        ),
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [subject.color, subject.color.withOpacity(0.7)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.lesson.getTitle(isUrdu),
                              style: GoogleFonts.nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                              maxLines: 2,
                            ),
                            Text(
                              subject.getName(isUrdu),
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(subject.emoji,
                          style: const TextStyle(fontSize: 32)),
                    ],
                  ),
                ),
              ),
            ),

            // Content Area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Audio Button
                    GestureDetector(
                      onTap: () => _speak(content, isUrdu),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isSpeaking
                                ? [AppColors.orange, AppColors.pink]
                                : [subject.color, AppColors.purple],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: subject.color.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                _isSpeaking
                                    ? Icons.stop_rounded
                                    : Icons.volume_up_rounded,
                                color: Colors.white,
                                key: ValueKey(_isSpeaking),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isSpeaking
                                  ? (isUrdu ? 'رکیں' : 'Stop')
                                  : AppStrings.get('listen', isUrdu),
                              style: GoogleFonts.nunito(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Content Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: subject.color.withOpacity(0.1),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        content,
                        style: GoogleFonts.nunito(
                          fontSize: 17,
                          height: 1.8,
                          color: const Color(0xFF1E1B4B),
                          fontWeight: FontWeight.w500,
                        ),
                        textDirection: isUrdu
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Stars Reward Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.yellowLight,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: AppColors.yellow.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Text('⭐⭐⭐',
                              style: TextStyle(fontSize: 22)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              isUrdu
                                  ? 'یہ سبق مکمل کریں اور 3 ستارے جیتیں!'
                                  : 'Complete this lesson and earn 3 stars!',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF78350F),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Complete Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              child: GestureDetector(
                onTap: () => _markComplete(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [subject.color, AppColors.pink],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: subject.color.withOpacity(0.45),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('✅', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Text(
                        isUrdu ? 'سبق مکمل! آگے بڑھیں' : 'Lesson Done! Earn Stars',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
