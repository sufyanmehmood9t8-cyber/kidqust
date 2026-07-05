import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/tts_service.dart';

class ColorItem {
  final String id;
  final String colorName;
  final Color color;
  final IconData icon;

  ColorItem({required this.id, required this.colorName, required this.color, required this.icon});
}

class ColorSortingScreen extends StatefulWidget {
  const ColorSortingScreen({super.key});

  @override
  State<ColorSortingScreen> createState() => _ColorSortingScreenState();
}

class _ColorSortingScreenState extends State<ColorSortingScreen> {
  final TtsService _ttsService = TtsService();
  final Random _random = Random();

  final List<ColorItem> _possibleItems = [
    ColorItem(id: '1', colorName: 'Red', color: Colors.red, icon: Icons.apple_rounded),
    ColorItem(id: '2', colorName: 'Yellow', color: Colors.yellow, icon: Icons.wb_sunny_rounded),
    ColorItem(id: '3', colorName: 'Red', color: Colors.red, icon: Icons.sports_baseball_rounded),
    ColorItem(id: '4', colorName: 'Yellow', color: Colors.yellow, icon: Icons.emoji_emotions_rounded),
  ];

  List<ColorItem> _activeItems = [];
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _generateItems();
    _ttsService.init();
  }

  void _generateItems() {
    setState(() {
      _activeItems = List.generate(5, (index) {
        final item = _possibleItems[_random.nextInt(_possibleItems.length)];
        return ColorItem(
          id: DateTime.now().millisecondsSinceEpoch.toString() + index.toString(),
          colorName: item.colorName,
          color: item.color,
          icon: item.icon,
        );
      });
    });
  }

  void _onSorted(ColorItem item) {
    setState(() {
      _activeItems.removeWhere((i) => i.id == item.id);
      _score++;
    });
    _ttsService.speak("${item.colorName}! Correct!");
    
    if (_activeItems.isEmpty) {
      _generateItems(); // Refill
    }
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
          'Color Sorting',
          style: GoogleFonts.baloo2(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Info Bar
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Text(
                'Score: $_score',
                style: GoogleFonts.baloo2(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            ),
          ),
          
          // Falling Items (Draggables)
          Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: _activeItems.map((item) {
                return Draggable<ColorItem>(
                  data: item,
                  feedback: Icon(item.icon, size: 80, color: item.color.withOpacity(0.7)),
                  childWhenDragging: Icon(item.icon, size: 60, color: Colors.grey.withOpacity(0.3)),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
                    padding: const EdgeInsets.all(15),
                    child: Icon(item.icon, size: 60, color: item.color),
                  ),
                );
              }).toList(),
            ),
          ),

          // Baskets (Targets)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBasket('Red', Colors.red),
                _buildBasket('Yellow', Colors.yellow),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasket(String colorName, Color color) {
    return DragTarget<ColorItem>(
      onAcceptWithDetails: (details) {
        if (details.data.colorName == colorName) {
          _onSorted(details.data);
        } else {
          _ttsService.speak("Oops! Try again!");
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: color, width: 4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_basket_rounded, size: 70, color: color),
              Text(
                colorName,
                style: GoogleFonts.baloo2(fontSize: 22, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        );
      },
    );
  }
}
