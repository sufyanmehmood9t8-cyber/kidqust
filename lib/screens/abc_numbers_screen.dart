import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/tts_service.dart';

class AbcNumbersScreen extends StatefulWidget {
  const AbcNumbersScreen({super.key});

  @override
  State<AbcNumbersScreen> createState() => _AbcNumbersScreenState();
}

class _AbcNumbersScreenState extends State<AbcNumbersScreen> with SingleTickerProviderStateMixin {
  final TtsService _ttsService = TtsService();
  late TabController _tabController;

  final List<String> _abc = List.generate(26, (index) => String.fromCharCode(65 + index));
  final List<int> _numbers = List.generate(200, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _ttsService.init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ttsService.stop();
    super.dispose();
  }

  void _speak(String text) {
    _ttsService.speak(text);
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
          'ABC & Numbers',
          style: GoogleFonts.baloo2(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 4,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.baloo2(fontSize: 20, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'ABC', icon: Icon(Icons.font_download_rounded)),
            Tab(text: '123', icon: Icon(Icons.pin_rounded)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAbcGrid(),
          _buildNumbersGrid(),
        ],
      ),
    );
  }

  Widget _buildAbcGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: _abc.length,
      itemBuilder: (context, index) {
        final letter = _abc[index];
        return _buildItemCard(letter, Colors.primaries[index % Colors.primaries.length]);
      },
    );
  }

  Widget _buildNumbersGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _numbers.length,
      itemBuilder: (context, index) {
        final number = _numbers[index].toString();
        return _buildItemCard(number, Colors.accents[index % Colors.accents.length], isSmall: true);
      },
    );
  }

  Widget _buildItemCard(String text, Color color, {bool isSmall = false}) {
    return GestureDetector(
      onTap: () => _speak(text),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.baloo2(
              fontSize: isSmall ? 24 : 40,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
