// ============================================================
// lib/screens/quiz_difficulty_screen.dart
// Little Scholars / KidNova – Three-Tier Quiz Difficulty Selection
// ============================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../data/lesson_data.dart';
import '../data/quiz_data.dart';
import '../models/app_models.dart';
import 'quiz_screen.dart';

class QuizDifficultyScreen extends StatelessWidget {
  final String subjectId;
  final int classNumber;

  const QuizDifficultyScreen({
    super.key,
    required this.subjectId,
    required this.classNumber,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isUrdu = lang.isUrdu;

    final subject = kSubjects.firstWhere(
      (s) => s.id == subjectId,
      orElse: () => const SubjectModel(
        id: 'math',
        nameEn: 'Quiz',
        nameUr: 'کوئز',
        emoji: '💡',
        color: Color(0xFF3B82F6),
        lightColor: Color(0xFFDBEAFE),
      ),
    );

    // Get total count per difficulty
    final simpleCount = getQuestionsForSubject(subjectId, difficulty: 'simple').length;
    final easyCount = getQuestionsForSubject(subjectId, difficulty: 'easy').length;
    final hardCount = getQuestionsForSubject(subjectId, difficulty: 'hard').length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              subject.color,
              subject.color.withOpacity(0.7),
              const Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      subject.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${subject.getName(isUrdu)} ${isUrdu ? 'کوئز' : 'Quiz'}',
                            style: GoogleFonts.nunito(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            isUrdu ? 'درجہ کا انتخاب کریں' : 'Choose Your Difficulty',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Main Content Card Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F7FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      children: [
                        // Header Banner
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                subject.lightColor,
                                Colors.white,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: subject.color.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: subject.color.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '🏆',
                                    style: TextStyle(fontSize: 26),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isUrdu
                                          ? 'اپنی قابلیت کی سطح چنیں!'
                                          : 'Select Quiz Difficulty!',
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF1E1B4B),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isUrdu
                                          ? 'ہر لیول میں ۱۰ نئے سوالات شامل ہیں'
                                          : '10 fun questions per level',
                                      style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 1. ⭐ SIMPLE CARD
                        _DifficultyCard(
                          title: isUrdu ? 'آسان ترین (Simple)' : 'Simple',
                          subtitle: isUrdu
                              ? 'نئے بچوں کے لیے - بنیادی اور آسان سوالات'
                              : 'Perfect for beginners • Basic & fun questions',
                          emoji: '⭐',
                          stars: '⭐',
                          badgeText: '$simpleCount ${isUrdu ? 'سوالات' : 'Questions'}',
                          gradientColors: const [
                            Color(0xFF06B6D4),
                            Color(0xFF3B82F6),
                          ],
                          onTap: () => _startQuiz(context, 'simple'),
                        ),

                        const SizedBox(height: 16),

                        // 2. 🧠 EASY CARD
                        _DifficultyCard(
                          title: isUrdu ? 'درمیانہ (Easy)' : 'Easy',
                          subtitle: isUrdu
                              ? 'معمول کا چیلنج - اہم معلومات کی جانچ'
                              : 'Slightly challenging • Test your understanding',
                          emoji: '🧠',
                          stars: '⭐⭐',
                          badgeText: '$easyCount ${isUrdu ? 'سوالات' : 'Questions'}',
                          gradientColors: const [
                            Color(0xFF8B5CF6),
                            Color(0xFF6366F1),
                          ],
                          onTap: () => _startQuiz(context, 'easy'),
                        ),

                        const SizedBox(height: 16),

                        // 3. 🔥 HARD CARD
                        _DifficultyCard(
                          title: isUrdu ? 'مشکل (Hard)' : 'Hard',
                          subtitle: isUrdu
                              ? 'سپر اسٹارز کے لیے - بہترین ذہانت آزمائیں'
                              : 'Challenging level • Become a Subject Master!',
                          emoji: '🔥',
                          stars: '⭐⭐⭐',
                          badgeText: '$hardCount ${isUrdu ? 'سوالات' : 'Questions'}',
                          gradientColors: const [
                            Color(0xFFF97316),
                            Color(0xFFEF4444),
                          ],
                          onTap: () => _startQuiz(context, 'hard'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startQuiz(BuildContext context, String difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          subjectId: subjectId,
          classNumber: classNumber,
          difficulty: difficulty,
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final String stars;
  final String badgeText;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.stars,
    required this.badgeText,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  State<_DifficultyCard> createState() => _DifficultyCardState();
}

class _DifficultyCardState extends State<_DifficultyCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isHovered ? 1.02 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.first.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Emoji Container
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Text Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.title,
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.stars,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.badgeText,
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Arrow Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
