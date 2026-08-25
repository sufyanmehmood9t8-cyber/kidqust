// ============================================================
// lib/constants/app_constants.dart
// Little Scholars – App-wide constants, colors, strings, routes
// ============================================================
import 'package:flutter/material.dart';

class AppRoutes {
  static const splash = '/';
  static const classSelection = '/class-selection';
  static const subjectSelection = '/subject-selection';
  static const lessonList = '/lesson-list';
  static const lessonContent = '/lesson-content';
  static const quiz = '/quiz';
  static const progress = '/progress';
  static const parentDashboard = '/parent-dashboard';
  static const settings = '/settings';
}

class AppColors {
  // Primary Palette
  static const purple = Color(0xFF7C3AED);
  static const purpleLight = Color(0xFFA78BFA);
  static const pink = Color(0xFFEC4899);
  static const pinkLight = Color(0xFFF9A8D4);
  static const orange = Color(0xFFF97316);
  static const orangeLight = Color(0xFFFDBA74);
  static const green = Color(0xFF22C55E);
  static const greenLight = Color(0xFF86EFAC);
  static const blue = Color(0xFF3B82F6);
  static const blueLight = Color(0xFF93C5FD);
  static const yellow = Color(0xFFF59E0B);
  static const yellowLight = Color(0xFFFDE68A);
  static const teal = Color(0xFF14B8A6);

  // Background
  static const bgGradientStart = Color(0xFF1E1B4B);
  static const bgGradientEnd = Color(0xFF4C1D95);

  // Class Card Colors
  static const classColors = [
    Color(0xFFEC4899), // Class 1 – Pink
    Color(0xFFF97316), // Class 2 – Orange
    Color(0xFF22C55E), // Class 3 – Green
    Color(0xFF3B82F6), // Class 4 – Blue
    Color(0xFF7C3AED), // Class 5 – Purple
    Color(0xFFF59E0B), // Class 6 – Yellow
  ];
}

class AppStrings {
  // Bilingual map: key -> {en, ur}
  static const Map<String, Map<String, String>> text = {
    'app_name': {'en': 'Little Scholars', 'ur': 'چھوٹے عالم'},
    'select_class': {'en': 'Select Your Class', 'ur': 'اپنی جماعت چنیں'},
    'select_subject': {'en': 'Choose a Subject', 'ur': 'مضمون چنیں'},
    'class': {'en': 'Class', 'ur': 'جماعت'},
    'start_learning': {'en': 'Start Learning!', 'ur': 'پڑھنا شروع کریں!'},
    'subjects': {'en': 'Subjects', 'ur': 'مضامین'},
    'lessons': {'en': 'Lessons', 'ur': 'سبق'},
    'quiz': {'en': 'Quiz', 'ur': 'امتحان'},
    'progress': {'en': 'My Progress', 'ur': 'میری ترقی'},
    'settings': {'en': 'Settings', 'ur': 'ترتیبات'},
    'parent_dashboard': {'en': 'Parent Dashboard', 'ur': 'والدین کا پینل'},
    'correct': {'en': '🎉 Correct!', 'ur': '🎉 بالکل صحیح!'},
    'wrong': {'en': '😢 Wrong!', 'ur': '😢 غلط جواب!'},
    'next': {'en': 'Next', 'ur': 'آگے'},
    'finish': {'en': 'Finish', 'ur': 'ختم'},
    'stars': {'en': 'Stars', 'ur': 'ستارے'},
    'badges': {'en': 'Badges', 'ur': 'بیجز'},
    'streak': {'en': 'Day Streak', 'ur': 'لگاتار دن'},
    'listen': {'en': '🔊 Listen', 'ur': '🔊 سنیں'},
    'back': {'en': 'Back', 'ur': 'واپس'},
    'enter_pin': {'en': 'Enter PIN', 'ur': 'پن درج کریں'},
    'language': {'en': 'Language', 'ur': 'زبان'},
    'math': {'en': 'Math', 'ur': 'حساب'},
    'english': {'en': 'English', 'ur': 'انگریزی'},
    'urdu': {'en': 'Urdu', 'ur': 'اردو'},
    'science': {'en': 'Science', 'ur': 'سائنس'},
    'islamiyat': {'en': 'Islamiyat', 'ur': 'اسلامیات'},
    'gk': {'en': 'General Knowledge', 'ur': 'عمومی معلومات'},
    'well_done': {'en': '🏆 Well Done!', 'ur': '🏆 شاباش!'},
    'quiz_score': {'en': 'Your Score', 'ur': 'آپ کا اسکور'},
    'play_again': {'en': 'Play Again', 'ur': 'دوبارہ کھیلیں'},
    'go_home': {'en': 'Go Home', 'ur': 'گھر جائیں'},
  };

  static String get(String key, bool isUrdu) {
    return text[key]?[isUrdu ? 'ur' : 'en'] ?? key;
  }
}

class AppEmojis {
  static const classEmojis = ['🎒', '📚', '✏️', '🔬', '🌟', '🎓'];
  static const subjectEmojis = {
    'math': '🔢',
    'english': '📖',
    'urdu': '📝',
    'science': '🔬',
    'islamiyat': '☪️',
    'gk': '🌍',
  };
}
