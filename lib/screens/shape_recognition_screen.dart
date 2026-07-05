import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/tts_service.dart';

class ShapeRecognitionScreen extends StatefulWidget {
  const ShapeRecognitionScreen({super.key});

  @override
  State<ShapeRecognitionScreen> createState() => _ShapeRecognitionScreenState();
}

class _ShapeRecognitionScreenState extends State<ShapeRecognitionScreen> {
  final TtsService _ttsService = TtsService();

  final List<Map<String, dynamic>> _shapes = [
    {'name': 'Circle', 'icon': Icons.circle, 'color': Colors.blue, 'label': 'Blue Circle'},
    {'name': 'Square', 'icon': Icons.square, 'color': Colors.red, 'label': 'Red Square'},
    {'name': 'Triangle', 'icon': Icons.change_history_rounded, 'color': Colors.green, 'label': 'Green Triangle'},
    {'name': 'Star', 'icon': Icons.star_rounded, 'color': Colors.orange, 'label': 'Orange Star'},
  ];

  @override
  void initState() {
    super.initState();
    _ttsService.init();
  }

  void _speak(String text) {
    _ttsService.speak("This is a $text!");
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
          'Shape Pehchan',
          style: GoogleFonts.baloo2(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Tap a shape to hear its name!',
              textAlign: TextAlign.center,
              style: GoogleFonts.baloo2(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: _shapes.length,
                itemBuilder: (context, index) {
                  final shape = _shapes[index];
                  return GestureDetector(
                    onTap: () => _speak(shape['label']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(shape['icon'], size: 80, color: shape['color']),
                          const SizedBox(height: 10),
                          Text(
                            shape['name'],
                            style: GoogleFonts.baloo2(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
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
    );
  }
}
