// ============================================================
// lib/models/app_models.dart
// Little Scholars – All data models
// ============================================================

import 'package:flutter/material.dart';

// --------------- Class Model ---------------
class ClassModel {
  final int number;
  final Color color;
  final String emoji;

  const ClassModel({
    required this.number,
    required this.color,
    required this.emoji,
  });
}

// --------------- Subject Model ---------------
class SubjectModel {
  final String id;
  final String nameEn;
  final String nameUr;
  final String emoji;
  final Color color;
  final Color lightColor;

  const SubjectModel({
    required this.id,
    required this.nameEn,
    required this.nameUr,
    required this.emoji,
    required this.color,
    required this.lightColor,
  });

  String getName(bool isUrdu) => isUrdu ? nameUr : nameEn;
}

// --------------- Lesson Model ---------------
class LessonModel {
  final String id;
  final String titleEn;
  final String titleUr;
  final String contentEn;
  final String contentUr;
  final String? imageAsset;

  const LessonModel({
    required this.id,
    required this.titleEn,
    required this.titleUr,
    required this.contentEn,
    required this.contentUr,
    this.imageAsset,
  });

  String getTitle(bool isUrdu) => isUrdu ? titleUr : titleEn;
  String getContent(bool isUrdu) => isUrdu ? contentUr : contentEn;
}

// --------------- Quiz Question Model ---------------
class QuizQuestion {
  final String questionEn;
  final String questionUr;
  final List<String> optionsEn;
  final List<String> optionsUr;
  final int correctIndex;
  final String explanationEn;
  final String explanationUr;
  final String difficulty; // 'simple', 'easy', 'hard'

  const QuizQuestion({
    required this.questionEn,
    required this.questionUr,
    required this.optionsEn,
    required this.optionsUr,
    required this.correctIndex,
    this.explanationEn = '',
    this.explanationUr = '',
    this.difficulty = 'simple',
  });

  String getQuestion(bool isUrdu) => isUrdu ? questionUr : questionEn;
  List<String> getOptions(bool isUrdu) => isUrdu ? optionsUr : optionsEn;
}

// --------------- Badge Model ---------------
class BadgeModel {
  final String id;
  final String nameEn;
  final String nameUr;
  final String emoji;
  final String descriptionEn;
  final String descriptionUr;
  final int starsRequired;

  const BadgeModel({
    required this.id,
    required this.nameEn,
    required this.nameUr,
    required this.emoji,
    required this.descriptionEn,
    required this.descriptionUr,
    required this.starsRequired,
  });

  String getName(bool isUrdu) => isUrdu ? nameUr : nameEn;
  String getDescription(bool isUrdu) => isUrdu ? descriptionUr : descriptionEn;
}

// --------------- Progress Model ---------------
class UserProgress {
  int totalStars;
  int currentStreak;
  Set<String> completedLessons;
  Set<String> earnedBadges;
  Map<String, int> subjectStars; // subjectId -> stars

  UserProgress({
    this.totalStars = 0,
    this.currentStreak = 0,
    Set<String>? completedLessons,
    Set<String>? earnedBadges,
    Map<String, int>? subjectStars,
  })  : completedLessons = completedLessons ?? {},
        earnedBadges = earnedBadges ?? {},
        subjectStars = subjectStars ?? {};
}
