import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColoringScreen extends StatefulWidget {
  const ColoringScreen({super.key});

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  Color _selectedColor = Colors.white;
  double _strokeWidth = 3.0;
  List<DrawingPoint?> _points = [];
  String _activeTool = 'pencil'; // pencil, brush, eraser

  // Blackboard color
  final Color _blackboardColor = const Color(0xFF1B3022); // Deep chalkboard green

  void _selectTool(String tool) {
    setState(() {
      _activeTool = tool;
      if (tool == 'pencil') {
        _strokeWidth = 3.0;
        if (_selectedColor == _blackboardColor) _selectedColor = Colors.white;
      } else if (tool == 'brush') {
        _strokeWidth = 10.0;
        if (_selectedColor == _blackboardColor) _selectedColor = Colors.white;
      } else if (tool == 'eraser') {
        _strokeWidth = 25.0;
        _selectedColor = _blackboardColor;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE400), // App theme yellow
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Magic Blackboard',
          style: GoogleFonts.baloo2(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 30),
            onPressed: () {
              setState(() {
                _points.clear();
              });
            },
          ),
          const SizedBox(width: 10),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Blackboard Area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _blackboardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF8B4513), width: 8), // Wooden frame
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      _points.add(DrawingPoint(
                        point: details.localPosition,
                        paint: Paint()
                          ..color = _selectedColor
                          ..isAntiAlias = true
                          ..strokeWidth = _strokeWidth
                          ..strokeCap = StrokeCap.round,
                      ));
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      _points.add(DrawingPoint(
                        point: details.localPosition,
                        paint: Paint()
                          ..color = _selectedColor
                          ..isAntiAlias = true
                          ..strokeWidth = _strokeWidth
                          ..strokeCap = StrokeCap.round,
                      ));
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      _points.add(null);
                    });
                  },
                  child: CustomPaint(
                    painter: DrawingPainter(pointsList: _points),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),

          // Tools and Color Palette
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Tools selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildToolButton('pencil', Icons.edit_rounded, "Pencil"),
                    _buildToolButton('brush', Icons.brush_rounded, "Brush"),
                    _buildToolButton('eraser', Icons.cleaning_services_rounded, "Eraser"),
                  ],
                ),
                const SizedBox(height: 20),
                // Color palette
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildColorCircle(Colors.white),
                      _buildColorCircle(Colors.red),
                      _buildColorCircle(Colors.blue),
                      _buildColorCircle(Colors.green),
                      _buildColorCircle(Colors.yellow),
                      _buildColorCircle(Colors.orange),
                      _buildColorCircle(Colors.pink),
                      _buildColorCircle(Colors.purple),
                      _buildColorCircle(Colors.cyan),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(String tool, IconData icon, String label) {
    bool isActive = _activeTool == tool;
    return GestureDetector(
      onTap: () => _selectTool(tool),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFE91E63) : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey[600],
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.baloo2(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isActive ? const Color(0xFFE91E63) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    bool isSelected = _selectedColor == color && _activeTool != 'eraser';
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
          // If eraser was active, switch back to previous tool or default to brush
          if (_activeTool == 'eraser') {
            _activeTool = 'brush';
            _strokeWidth = 10.0;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!, width: 1),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawingPoint {
  Paint paint;
  Offset point;
  DrawingPoint({required this.point, required this.paint});
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.pointsList});
  List<DrawingPoint?> pointsList;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(
          pointsList[i]!.point,
          pointsList[i + 1]!.point,
          pointsList[i]!.paint,
        );
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        canvas.drawCircle(
          pointsList[i]!.point,
          pointsList[i]!.paint.strokeWidth / 2,
          pointsList[i]!.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}
