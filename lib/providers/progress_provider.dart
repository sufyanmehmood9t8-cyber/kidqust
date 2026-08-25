// ============================================================
// lib/providers/progress_provider.dart
// Manages stars, badges, streaks, completed lessons
// ============================================================
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressProvider extends ChangeNotifier {
  int _totalStars = 0;
  int _currentStreak = 0;
  Set<String> _completedLessons = {};
  Set<String> _earnedBadges = {};

  int get totalStars => _totalStars;
  int get currentStreak => _currentStreak;
  Set<String> get completedLessons => _completedLessons;
  Set<String> get earnedBadges => _earnedBadges;

  ProgressProvider() {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _totalStars = prefs.getInt('total_stars') ?? 0;
    _currentStreak = prefs.getInt('current_streak') ?? 0;
    _completedLessons = (prefs.getStringList('completed_lessons') ?? []).toSet();
    _earnedBadges = (prefs.getStringList('earned_badges') ?? []).toSet();
    notifyListeners();
  }

  Future<void> addStars(int count) async {
    _totalStars += count;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_stars', _totalStars);
    _checkBadges();
    notifyListeners();
  }

  Future<void> markLessonComplete(String lessonId) async {
    _completedLessons.add(lessonId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completed_lessons', _completedLessons.toList());
    notifyListeners();
  }

  Future<void> incrementStreak() async {
    _currentStreak++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_streak', _currentStreak);
    notifyListeners();
  }

  Future<void> earnBadge(String badgeId) async {
    if (!_earnedBadges.contains(badgeId)) {
      _earnedBadges.add(badgeId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('earned_badges', _earnedBadges.toList());
      notifyListeners();
    }
  }

  void _checkBadges() {
    // Auto-award badges based on star count
    if (_totalStars >= 10) earnBadge('star_collector');
    if (_totalStars >= 50) earnBadge('super_scholar');
    if (_totalStars >= 100) earnBadge('champion');
    if (_completedLessons.length >= 5) earnBadge('lesson_hero');
    if (_completedLessons.length >= 20) earnBadge('lesson_master');
  }

  bool isLessonCompleted(String lessonId) => _completedLessons.contains(lessonId);
}
