// ============================================================
// lib/screens/lesson_list_screen.dart
// Little Scholars – Topic/Lesson List per Subject
// ============================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/progress_provider.dart';
import '../data/lesson_data.dart';
import '../models/app_models.dart';
import '../constants/app_constants.dart';
import 'lesson_content_screen.dart';
import 'quiz_difficulty_screen.dart';
import 'quiz_screen.dart';

class LessonListScreen extends StatelessWidget {
  final int classNumber;
  final String subjectId;

  const LessonListScreen({
    super.key,
    required this.classNumber,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final progress = context.watch<ProgressProvider>();
    final isUrdu = lang.isUrdu;

    final subject = kSubjects.firstWhere((s) => s.id == subjectId);
    final lessons = kLessons[subjectId] ?? [];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [subject.color, subject.color.withOpacity(0.6), const Color(0xFF0F172A)],
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
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      subject.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.getName(isUrdu),
                          style: GoogleFonts.nunito(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          isUrdu
                              ? '${lessons.length} اسباق'
                              : '${lessons.length} Lessons',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Lessons List
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F7FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Section title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text(
                              isUrdu ? '📖 اسباق' : '📖 Lessons',
                              style: GoogleFonts.nunito(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1E1B4B),
                              ),
                            ),
                            const Spacer(),
                            // Take Quiz button
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QuizDifficultyScreen(
                                    subjectId: subjectId,
                                    classNumber: classNumber,
                                  ),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 7),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [subject.color, AppColors.pink],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: subject.color.withOpacity(0.4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Text('🧠', style: TextStyle(fontSize: 14)),
                                    const SizedBox(width: 5),
                                    Text(
                                      isUrdu ? 'کوئز' : 'Quiz',
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: lessons.length,
                          itemBuilder: (context, index) {
                            final lesson = lessons[index];
                            final isDone =
                                progress.isLessonCompleted(lesson.id);
                            return _LessonTile(
                              lesson: lesson,
                              index: index,
                              subject: subject,
                              isUrdu: isUrdu,
                              isDone: isDone,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LessonContentScreen(
                                      lesson: lesson,
                                      subject: subject,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final LessonModel lesson;
  final int index;
  final SubjectModel subject;
  final bool isUrdu;
  final bool isDone;
  final VoidCallback onTap;

  const _LessonTile({
    required this.lesson,
    required this.index,
    required this.subject,
    required this.isUrdu,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: subject.color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Number Badge
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isDone ? AppColors.green : subject.lightColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 22)
                    : Text(
                        '${index + 1}',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: subject.color,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.getTitle(isUrdu),
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E1B4B),
                    ),
                  ),
                  if (isDone)
                    Text(
                      isUrdu ? '✅ مکمل' : '✅ Completed',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: AppColors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.play_circle_fill_rounded,
              color: subject.color,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
