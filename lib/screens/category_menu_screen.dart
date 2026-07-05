import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'moral_stories_screen.dart';
import 'daily_manners_screen.dart';
import 'coloring_screen.dart';
import 'abc_numbers_screen.dart';
import 'brain_game_screen.dart';
import 'shapes_colors_menu_screen.dart';

class CategoryMenuScreen extends StatelessWidget {
  const CategoryMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Moral Stories',
        'icon': Icons.menu_book_rounded,
        'color': const Color(0xFFFF9800), // Orange
        'subtitle': 'Learn with fun stories',
        'route': const MoralStoriesScreen(),
      },
      {
        'title': 'Daily Manners',
        'icon': Icons.clean_hands_rounded,
        'color': const Color(0xFF4CAF50), // Green
        'subtitle': 'Good habits for kids',
        'route': const DailyMannersScreen(),
      },
      {
        'title': 'Fun Coloring',
        'icon': Icons.palette_rounded,
        'color': const Color(0xFFE91E63), // Pink
        'subtitle': 'Draw and paint',
        'route': const ColoringScreen(),
      },
      {
        'title': 'ABC & Numbers',
        'icon': Icons.font_download_rounded,
        'color': const Color(0xFF2196F3), // Blue
        'subtitle': 'Learn to read and count',
        'route': const AbcNumbersScreen(),
      },
      {
        'title': 'Brain Games',
        'icon': Icons.psychology_rounded,
        'color': const Color(0xFF9C27B0), // Purple
        'subtitle': 'Challenge your mind',
        'route': const BrainGameScreen(),
      },
      {
        'title': 'Shapes & Colors',
        'icon': Icons.category_rounded,
        'color': const Color(0xFFFFC107), // Amber
        'subtitle': 'Identify world around you',
        'route': const ShapesColorsMenuScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDE400), // Same bright yellow
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Choose a Quest!',
          style: GoogleFonts.baloo2(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _CategoryCard(
                      title: category['title'],
                      icon: category['icon'],
                      color: category['color'],
                      subtitle: category['subtitle'],
                      onTap: () {
                        if (category['route'] != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => category['route']),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Starting ${category['title']}!'),
                              backgroundColor: category['color'],
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  
                  size: 50,
                  color: widget.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.baloo2(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
