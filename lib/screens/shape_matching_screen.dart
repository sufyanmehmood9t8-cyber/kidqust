import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/tts_service.dart';

class ShapeMatchingScreen extends StatefulWidget {
  const ShapeMatchingScreen({super.key});

  @override
  State<ShapeMatchingScreen> createState() => _ShapeMatchingScreenState();
}

class _ShapeMatchingScreenState extends State<ShapeMatchingScreen> {
  final TtsService _ttsService = TtsService();

  final List<Map<String, dynamic>> _allShapes = [
    {'name': 'Circle', 'icon': Icons.circle, 'color': Colors.blue},
    {'name': 'Square', 'icon': Icons.square, 'color': Colors.red},
    {'name': 'Triangle', 'icon': Icons.change_history_rounded, 'color': Colors.green},
    {'name': 'Star', 'icon': Icons.star_rounded, 'color': Colors.orange},
  ];

  late List<Map<String, dynamic>> _shapes;
  late List<Map<String, dynamic>> _shadows;
  final Map<String, bool> _score = {};

  @override
  void initState() {
    super.initState();
    _resetGame();
    _ttsService.init();
  }

  void _resetGame() {
    setState(() {
      _shapes = List.from(_allShapes)..shuffle();
      _shadows = List.from(_allShapes)..shuffle();
      _score.clear();
    });
  }

  void _onSuccess() {
    _ttsService.speak("Ting! Perfect!");
    if (_score.length == _allShapes.length) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 100, color: Colors.orange),
            Text(
              'Amazing!',
              style: GoogleFonts.baloo2(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            Text(
              'You matched them all!',
              style: GoogleFonts.baloo2(fontSize: 20, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Play Again'),
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Jora Milanaa',
          style: GoogleFonts.baloo2(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Drag the shape to its shadow!',
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // Shadows (Targets)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _shadows.map((shadow) {
              return DragTarget<String>(
                onAcceptWithDetails: (details) {
                  if (details.data == shadow['name']) {
                    setState(() {
                      _score[shadow['name']] = true;
                    });
                    _onSuccess();
                  }
                },
                builder: (context, candidateData, rejectedData) {
                  bool isMatched = _score[shadow['name']] == true;
                  return Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isMatched ? shadow['color'].withOpacity(0.5) : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 3, style: BorderStyle.solid),
                    ),
                    child: Icon(
                      shadow['icon'],
                      size: 50,
                      color: isMatched ? Colors.white : Colors.black.withOpacity(0.2),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          // Shapes (Draggables)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _shapes.map((shape) {
              bool isMatched = _score[shape['name']] == true;
              return isMatched
                  ? const SizedBox(width: 80, height: 80)
                  : Draggable<String>(
                      data: shape['name'],
                      feedback: Icon(shape['icon'], size: 70, color: shape['color'].withOpacity(0.7)),
                      childWhenDragging: Icon(shape['icon'], size: 60, color: Colors.grey.withOpacity(0.3)),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5),
                          ],
                        ),
                        child: Icon(shape['icon'], size: 50, color: shape['color']),
                      ),
                    );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
