// ============================================================
// lib/screens/quiz_screen.dart
// Little Scholars – MCQ Quiz with Stars, Animations & Scoring
// ============================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../providers/language_provider.dart';
import '../providers/progress_provider.dart';
import '../data/quiz_data.dart';
import '../data/lesson_data.dart';
import '../constants/app_constants.dart';
import 'progress_screen.dart';

class QuizScreen extends StatefulWidget {
  final String subjectId;
  final int classNumber;
  final String? difficulty;

  const QuizScreen({
    super.key,
    required this.subjectId,
    required this.classNumber,
    this.difficulty,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOption;
  bool _answered = false;
  bool _quizFinished = false;

  late AnimationController _feedbackController;
  late AnimationController _cardController;
  late Animation<double> _feedbackScale;
  late Animation<double> _cardSlide;

  List<QuizQuestion> get _questions =>
      getQuestionsForSubject(widget.subjectId, difficulty: widget.difficulty);

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    _feedbackScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut),
    );
    _cardSlide = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  void _selectAnswer(int optionIndex) {
    if (_answered) return;
    final q = _questions[_currentIndex];
    final isCorrect = optionIndex == q.correctIndex;

    setState(() {
      _selectedOption = optionIndex;
      _answered = true;
      if (isCorrect) _score++;
    });

    _feedbackController.forward(from: 0);

    if (isCorrect) {
      context.read<ProgressProvider>().addStars(1);
    }
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
      _cardController.reset();
      _cardController.forward();
    } else {
      setState(() => _quizFinished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isUrdu = lang.isUrdu;
    final subject = kSubjects.firstWhere((s) => s.id == widget.subjectId);

    if (_quizFinished) {
      return _buildResultScreen(context, isUrdu, subject);
    }

    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            isUrdu ? 'اس مضمون میں ابھی کوئی سوال نہیں' : 'No quiz questions yet!',
            style: GoogleFonts.nunito(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    final q = _questions[_currentIndex];
    final options = q.getOptions(isUrdu);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [subject.color, AppColors.purple],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
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
                        child: const Icon(Icons.close_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${subject.emoji} ${subject.getName(isUrdu)}',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                isUrdu
                                    ? 'سوال ${_toUrduNumeral(_currentIndex + 1)} / ${_toUrduNumeral(_questions.length)}'
                                    : 'Question ${_currentIndex + 1} / ${_questions.length}',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                              if (widget.difficulty != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    widget.difficulty!.toUpperCase(),
                                    style: GoogleFonts.nunito(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Score
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Text('⭐', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 4),
                          Text(
                            '$_score',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _questions.length,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Question Card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(4),
                  child: AnimatedBuilder(
                    animation: _cardController,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(0, _cardSlide.value),
                      child: Opacity(opacity: _cardController.value, child: child),
                    ),
                    child: Column(
                      children: [
                        // Question
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            q.getQuestion(isUrdu),
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E1B4B),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                            textDirection: isUrdu
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Options
                        Expanded(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: options.length,
                            itemBuilder: (ctx, i) {
                              Color bgColor = Colors.white;
                              Color borderColor = Colors.transparent;
                              Color textColor = const Color(0xFF1E1B4B);
                              Widget? trailingIcon;

                              if (_answered) {
                                if (i == q.correctIndex) {
                                  bgColor = AppColors.greenLight;
                                  borderColor = AppColors.green;
                                  trailingIcon = const Icon(Icons.check_circle_rounded,
                                      color: AppColors.green, size: 24);
                                } else if (i == _selectedOption) {
                                  bgColor = const Color(0xFFFFE4E4);
                                  borderColor = Colors.red;
                                  trailingIcon = const Icon(Icons.cancel_rounded,
                                      color: Colors.red, size: 24);
                                }
                              }

                              return GestureDetector(
                                onTap: () => _selectAnswer(i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color: borderColor, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: subject.lightColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            ['A', 'B', 'C', 'D'][i],
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w900,
                                              color: subject.color,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          options[i],
                                          style: GoogleFonts.nunito(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: textColor,
                                          ),
                                          textDirection: isUrdu
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                        ),
                                      ),
                                      if (trailingIcon != null) trailingIcon,
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Feedback + Next
              if (_answered) ...[
                AnimatedBuilder(
                  animation: _feedbackScale,
                  builder: (_, child) => Transform.scale(
                    scale: _feedbackScale.value,
                    child: child,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _selectedOption == _questions[_currentIndex].correctIndex
                          ? AppColors.greenLight
                          : const Color(0xFFFFE4E4),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _selectedOption == _questions[_currentIndex].correctIndex
                              ? '🎉'
                              : '😢',
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedOption == _questions[_currentIndex].correctIndex
                                ? AppStrings.get('correct', isUrdu)
                                : AppStrings.get('wrong', isUrdu),
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: _selectedOption ==
                                      _questions[_currentIndex].correctIndex
                                  ? AppColors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: GestureDetector(
                    onTap: _nextQuestion,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentIndex < _questions.length - 1
                            ? AppStrings.get('next', isUrdu)
                            : AppStrings.get('finish', isUrdu),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: subject.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ] else
                const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(
      BuildContext context, bool isUrdu, dynamic subject) {
    final percent = _questions.isEmpty
        ? 0
        : (_score / _questions.length * 100).round();
    final emoji = percent >= 80 ? '🏆' : percent >= 50 ? '🌟' : '💪';
    final msg = percent >= 80
        ? (isUrdu ? 'بہت شاندار!' : 'Excellent!')
        : percent >= 50
            ? (isUrdu ? 'بہت اچھا!' : 'Well Done!')
            : (isUrdu ? 'پھر کوشش کریں!' : 'Keep Trying!');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [subject.color, AppColors.purple],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 80)),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.get('well_done', isUrdu),
                    style: GoogleFonts.nunito(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    msg,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppStrings.get('quiz_score', isUrdu),
                          style: GoogleFonts.nunito(
                              fontSize: 16, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_score / ${_questions.length}',
                          style: GoogleFonts.nunito(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: subject.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '⭐ $_score ${AppStrings.get('stars', isUrdu)} ${isUrdu ? 'جیتے' : 'Earned'}',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            color: AppColors.yellow,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ResultButton(
                        label: AppStrings.get('play_again', isUrdu),
                        icon: '🔄',
                        color: Colors.white,
                        textColor: subject.color,
                        onTap: () {
                          setState(() {
                            _currentIndex = 0;
                            _score = 0;
                            _selectedOption = null;
                            _answered = false;
                            _quizFinished = false;
                          });
                        },
                      ),
                      const SizedBox(width: 14),
                      _ResultButton(
                        label: AppStrings.get('go_home', isUrdu),
                        icon: '🏠',
                        color: Colors.white.withOpacity(0.2),
                        textColor: Colors.white,
                        onTap: () => Navigator.popUntil(
                            context, (route) => route.isFirst),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ProgressScreen())),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white38),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🏅', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(
                              AppStrings.get('progress', isUrdu),
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
                  ),
                ],
              ),
            ),
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

class _ResultButton extends StatelessWidget {
  final String label, icon;
  final Color color, textColor;
  final VoidCallback onTap;

  const _ResultButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          '$icon $label',
          style: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
