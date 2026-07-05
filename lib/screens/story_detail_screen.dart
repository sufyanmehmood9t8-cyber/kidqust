import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/tts_service.dart';

class StoryDetailScreen extends StatefulWidget {
  final Map<String, String> story;

  const StoryDetailScreen({
    super.key,
    required this.story,
  });

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final TtsService _ttsService = TtsService();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _ttsService.init();
    await _ttsService.setLanguage("ur-PK");
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  Future<void> _toggleSpeech() async {
    if (_isSpeaking) {
      await _ttsService.stop();
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isSpeaking = true;
        });
      }
      await _ttsService.speak(widget.story['content']!, languageCode: "ur-PK");
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.story['title'] ?? 'کہانی';
    final content = widget.story['content'] ?? '';
    final colorHex = widget.story['thumbnailColor'] ?? '0xFFFDE400';
    final cardColor = Color(int.parse(colorHex));
    final thumbnailUrl = widget.story['thumbnailUrl'] ?? '';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              backgroundColor: cardColor,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  title,
                  style: GoogleFonts.notoNastaliqUrdu(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        blurRadius: 10,
                        color: Colors.black26,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (thumbnailUrl.isNotEmpty)
                      Image.network(
                        thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: cardColor.withOpacity(0.1),
                          child: Center(
                            child: Icon(Icons.image_not_supported_rounded, color: cardColor.withOpacity(0.5), size: 40),
                          ),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: cardColor.withOpacity(0.05),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: cardColor.withOpacity(0.3),
                              ),
                            ),
                          );
                        },
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            cardColor.withOpacity(0.4),
                            cardColor,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: cardColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'اخلاقی کہانی',
                            style: GoogleFonts.notoNastaliqUrdu(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: cardColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleSpeech,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _isSpeaking ? Colors.red.shade400 : Colors.green.shade400,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (_isSpeaking ? Colors.red : Colors.green).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      content,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.notoNastaliqUrdu(
                        fontSize: 18,
                        height: 2.2,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

