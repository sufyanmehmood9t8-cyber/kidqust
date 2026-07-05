import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/brain_game_data.dart';

class BrainGameScreen extends StatefulWidget {
  const BrainGameScreen({super.key});

  @override
  State<BrainGameScreen> createState() => _BrainGameScreenState();
}

enum GameStage { levelSelection, classSelection, quiz }

class _BrainGameScreenState extends State<BrainGameScreen> {
  GameStage _stage = GameStage.levelSelection;
  String _selectedLevel = 'Low'; // Low, Medium, Fast
  String _selectedClass = 'Class 3';
  
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  int _score = 0;
  List<Question> _activeQuestions = [];

  // Timer logic for Medium/Fast
  Timer? _timer;
  int _timeLeft = 30; // Default
  bool _timerExpired = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_selectedLevel == 'Low') return; // No timer for low level

    setState(() {
      _timeLeft = _selectedLevel == 'Medium' ? 20 : 10;
      _timerExpired = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    if (!_isAnswered) {
      setState(() {
        _isAnswered = true;
        _timerExpired = true;
        // Optionally mark as wrong
      });
    }
  }

  void _selectLevel(String level) {
    setState(() {
      _selectedLevel = level;
      _stage = GameStage.classSelection;
    });
  }

  void _selectClass(String className) {
    setState(() {
      _selectedClass = className;
      _activeQuestions = List.from(brainGameData[className]!);
      _activeQuestions.shuffle();
      _activeQuestions = _activeQuestions.take(20).toList();
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedOptionIndex = null;
      _isAnswered = false;
      _stage = GameStage.quiz;
    });
    _startTimer();
  }

  void _handleOptionTap(int index) {
    if (_isAnswered) return;
    _timer?.cancel();
    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      if (index == _activeQuestions[_currentQuestionIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _activeQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
        _isAnswered = false;
        _timerExpired = false;
      });
      _startTimer();
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF9C27B0),
        title: Text(
          'کھیل ختم!',
          textAlign: TextAlign.center,
          style: GoogleFonts.notoNastaliqUrdu(color: Colors.white, fontSize: 24),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'آپ کا سکور: $_score / ${_activeQuestions.length}',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoNastaliqUrdu(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _stage = GameStage.levelSelection;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF9C27B0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('دوبارہ کھیلیں'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE400),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            if (_stage == GameStage.levelSelection) {
              Navigator.pop(context);
            } else if (_stage == GameStage.classSelection) {
              setState(() => _stage = GameStage.levelSelection);
            } else {
              setState(() => _stage = GameStage.classSelection);
              _timer?.cancel();
            }
          },
        ),
        title: Text(
          'Brain Games',
          style: GoogleFonts.baloo2(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildCurrentStage(),
    );
  }

  Widget _buildCurrentStage() {
    switch (_stage) {
      case GameStage.levelSelection:
        return _buildLevelSelection();
      case GameStage.classSelection:
        return _buildClassSelection();
      case GameStage.quiz:
        return _buildQuizView();
    }
  }

  Widget _buildLevelSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSelectionButton('Low Level', Colors.green, () => _selectLevel('Low')),
          const SizedBox(height: 20),
          _buildSelectionButton('Medium Level', Colors.orange, () => _selectLevel('Medium')),
          const SizedBox(height: 20),
          _buildSelectionButton('Fast Level', Colors.red, () => _selectLevel('Fast')),
        ],
      ),
    );
  }

  Widget _buildClassSelection() {
    final classes = ['Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7'];
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: classes.map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: _buildSelectionButton(c, const Color(0xFF2196F3), () => _selectClass(c)),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSelectionButton(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: color, width: 3),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.baloo2(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizView() {
    final question = _activeQuestions[_currentQuestionIndex];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Info Bar (Class & Timer)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_selectedClass (${_currentQuestionIndex + 1}/20)',
                    style: GoogleFonts.baloo2(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                if (_selectedLevel != 'Low')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: _timeLeft < 5 ? Colors.red : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 5),
                        Text(
                          '$_timeLeft',
                          style: GoogleFonts.baloo2(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Question Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: Text(
              question.question,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoNastaliqUrdu(fontSize: 20, fontWeight: FontWeight.bold, height: 2.0),
            ),
          ),
          if (_timerExpired)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'وقت ختم ہو گیا!', // Time is up!
                style: GoogleFonts.notoNastaliqUrdu(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          const Spacer(),
          // Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(question.options.length, (index) {
                bool isSelected = _selectedOptionIndex == index;
                bool isCorrect = index == question.correctIndex;
                Color optionColor = Colors.white;
                Widget icon = const SizedBox.shrink();

                if (_isAnswered) {
                  if (isCorrect) {
                    optionColor = Colors.green[100]!;
                    icon = const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28);
                  } else if (isSelected) {
                    optionColor = Colors.red[100]!;
                    icon = const Icon(Icons.cancel_rounded, color: Colors.red, size: 28);
                  }
                }

                return GestureDetector(
                  onTap: () => _handleOptionTap(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: optionColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isAnswered && isCorrect
                            ? Colors.green
                            : (_isAnswered && isSelected ? Colors.red : Colors.grey[300]!),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            question.options[index],
                            style: GoogleFonts.notoNastaliqUrdu(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (_isAnswered) icon,
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          // Next Button
          if (_isAnswered)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    'اگلا',
                    style: GoogleFonts.notoNastaliqUrdu(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
