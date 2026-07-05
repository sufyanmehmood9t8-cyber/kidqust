import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'shape_recognition_screen.dart';
import 'shape_matching_screen.dart';
import 'color_sorting_screen.dart';

class ShapesColorsMenuScreen extends StatelessWidget {
  const ShapesColorsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Shape Recognition\n(Pehchan)',
        'icon': Icons.visibility_rounded,
        'color': Colors.blue,
        'screen': const ShapeRecognitionScreen(),
      },
      {
        'title': 'Matching Game\n(Jora Milana)',
        'icon': Icons.extension_rounded,
        'color': Colors.green,
        'screen': const ShapeMatchingScreen(),
      },
      {
        'title': 'Color Sorting\n(Rangon ki Tafreq)',
        'icon': Icons.shopping_basket_rounded,
        'color': Colors.red,
        'screen': const ColorSortingScreen(),
      },
    ];

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
          'Shapes & Colors',
          style: GoogleFonts.baloo2(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: menuItems.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item['screen']),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: item['color'].withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(color: item['color'], width: 3),
                    ),
                    child: Row(
                      children: [
                        Icon(item['icon'], size: 50, color: item['color']),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            item['title'],
                            style: GoogleFonts.baloo2(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: item['color'],
                              height: 1.2,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
