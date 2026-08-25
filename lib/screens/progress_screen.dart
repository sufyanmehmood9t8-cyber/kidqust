// ============================================================
// lib/screens/progress_screen.dart
// Little Scholars – Progress: Stars, Badges, Streaks
// ============================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/progress_provider.dart';
import '../constants/app_constants.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const List<Map<String, dynamic>> _allBadges = [
    {
      'id': 'star_collector',
      'emoji': '⭐',
      'nameEn': 'Star Collector',
      'nameUr': 'ستارہ اکٹھا کرنے والا',
      'descEn': 'Earn 10 stars',
      'descUr': '10 ستارے جیتیں',
      'starsRequired': 10,
    },
    {
      'id': 'lesson_hero',
      'emoji': '📖',
      'nameEn': 'Lesson Hero',
      'nameUr': 'سبق کا ہیرو',
      'descEn': 'Complete 5 lessons',
      'descUr': '5 اسباق مکمل کریں',
      'starsRequired': 0,
    },
    {
      'id': 'super_scholar',
      'emoji': '🎓',
      'nameEn': 'Super Scholar',
      'nameUr': 'سپر عالم',
      'descEn': 'Earn 50 stars',
      'descUr': '50 ستارے جیتیں',
      'starsRequired': 50,
    },
    {
      'id': 'lesson_master',
      'emoji': '🏆',
      'nameEn': 'Lesson Master',
      'nameUr': 'سبق کا ماہر',
      'descEn': 'Complete 20 lessons',
      'descUr': '20 اسباق مکمل کریں',
      'starsRequired': 0,
    },
    {
      'id': 'champion',
      'emoji': '👑',
      'nameEn': 'Champion',
      'nameUr': 'چیمپئن',
      'descEn': 'Earn 100 stars',
      'descUr': '100 ستارے جیتیں',
      'starsRequired': 100,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final progress = context.watch<ProgressProvider>();
    final isUrdu = lang.isUrdu;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1B4B), Color(0xFF4C1D95), Color(0xFF7C3AED)],
          ),
        ),
        child: SafeArea(
          child: Column(
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
                    Text(
                      AppStrings.get('progress', isUrdu),
                      style: GoogleFonts.nunito(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    const Text('🏅', style: TextStyle(fontSize: 28)),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Stats Row
                      Row(
                        children: [
                          _StatCard(
                            emoji: '⭐',
                            value: '${progress.totalStars}',
                            labelEn: 'Stars',
                            labelUr: 'ستارے',
                            color: AppColors.yellow,
                            isUrdu: isUrdu,
                          ),
                          const SizedBox(width: 12),
                          _StatCard(
                            emoji: '🔥',
                            value: '${progress.currentStreak}',
                            labelEn: 'Day Streak',
                            labelUr: 'لگاتار دن',
                            color: AppColors.orange,
                            isUrdu: isUrdu,
                          ),
                          const SizedBox(width: 12),
                          _StatCard(
                            emoji: '📖',
                            value: '${progress.completedLessons.length}',
                            labelEn: 'Lessons',
                            labelUr: 'اسباق',
                            color: AppColors.green,
                            isUrdu: isUrdu,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Star Progress Bar
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('⭐', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Text(
                                  isUrdu ? 'ستاروں کی ترقی' : 'Star Progress',
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${progress.totalStars} / 100',
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    color: AppColors.yellow,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: (progress.totalStars / 100)
                                    .clamp(0.0, 1.0),
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.yellow),
                                minHeight: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Badges Section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isUrdu ? '🏅 بیجز' : '🏅 Badges',
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _allBadges.length,
                        itemBuilder: (context, index) {
                          final badge = _allBadges[index];
                          final earned =
                              progress.earnedBadges.contains(badge['id']);
                          return _BadgeCard(
                            badge: badge,
                            earned: earned,
                            isUrdu: isUrdu,
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Owl Encouragement
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          children: [
                            const Text('🦉', style: TextStyle(fontSize: 40)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                isUrdu
                                    ? '"پڑھو، کھیلو، بڑھو! تم سب سے اچھے ہو! 🌟"'
                                    : '"Keep learning, keep growing!\nYou\'re doing amazing! 🌟"',
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
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

class _StatCard extends StatelessWidget {
  final String emoji, value, labelEn, labelUr;
  final Color color;
  final bool isUrdu;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.labelEn,
    required this.labelUr,
    required this.color,
    required this.isUrdu,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              isUrdu ? labelUr : labelEn,
              style: GoogleFonts.nunito(
                fontSize: 11,
                color: Colors.white60,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final Map<String, dynamic> badge;
  final bool earned;
  final bool isUrdu;

  const _BadgeCard(
      {required this.badge, required this.earned, required this.isUrdu});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: earned
            ? AppColors.yellow.withOpacity(0.2)
            : Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: earned ? AppColors.yellow.withOpacity(0.6) : Colors.white12,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorFiltered(
            colorFilter: earned
                ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                : const ColorFilter.matrix([
                    0.2, 0.2, 0.2, 0, 0,
                    0.2, 0.2, 0.2, 0, 0,
                    0.2, 0.2, 0.2, 0, 0,
                    0,   0,   0,   1, 0,
                  ]),
            child: Text(
              badge['emoji'],
              style: TextStyle(fontSize: earned ? 32 : 28),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isUrdu ? badge['nameUr'] : badge['nameEn'],
            style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: earned ? AppColors.yellow : Colors.white30,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          if (!earned)
            Text(
              isUrdu ? badge['descUr'] : badge['descEn'],
              style: GoogleFonts.nunito(
                fontSize: 9,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
        ],
      ),
    );
  }
}
