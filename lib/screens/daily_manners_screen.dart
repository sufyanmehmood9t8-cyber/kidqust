import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'story_player_screen.dart';

class DailyMannersScreen extends StatefulWidget {
  const DailyMannersScreen({super.key});

  @override
  State<DailyMannersScreen> createState() => _DailyMannersScreenState();
}

class _DailyMannersScreenState extends State<DailyMannersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> manners = const [
    {
      'title': 'Wash Your Hands Song',
      'duration': '2:45',
      'thumbnailColor': '0xFFE8F5E9',
      'videoId': 'kU-W0X-lS6w',
      'thumbnailId': 'photo-1584622650111-993a426fbf0a' // Hands washing
    },
    {
      'title': 'Brush Your Teeth Song',
      'duration': '3:12',
      'thumbnailColor': '0xFFF1F8E9',
      'videoId': 'Pd4WnsXwdqw',
      'thumbnailId': 'photo-1475033191562-e32272286859' // Toothbrushing
    },
    {
      'title': 'Bath Time Fun!',
      'duration': '4:20',
      'thumbnailColor': '0xFFE0F2F1',
      'videoId': 'wCio_xVlgQ0',
      'thumbnailId': 'photo-1544145945-f904253db0ad' // Bathing
    },
    {
      'title': 'Cleaning My Body',
      'duration': '3:30',
      'thumbnailColor': '0xFFF0F4C3',
      'videoId': '7y_TUJy2TY8',
      'thumbnailId': 'photo-1532938911079-1b06ac7ceec7' // Hygiene
    },
    {
      'title': 'Morning Routine Fun',
      'duration': '5:10',
      'thumbnailColor': '0xFFC8E6C9',
      'videoId': 'V0lQ3ly7f64',
      'thumbnailId': 'photo-1503454537195-0df99d2b60ad' // Happy child morning
    },
    {
      'title': 'Good Eating Manners',
      'duration': '4:45',
      'thumbnailColor': '0xFFDCEDC8',
      'videoId': '6F_B85R-XG8',
      'thumbnailId': 'photo-1505575967455-40e256f73376' // Eating fruits/breakfast
    },
    {
      'title': 'Face Washing Fun',
      'duration': '2:15',
      'thumbnailColor': '0xFFF9FBE7',
      'videoId': 'kU-W0X-lS6w',
      'thumbnailId': 'photo-1518531933037-91b2f5f229cc' // Water splashing
    },
    {
      'title': 'Healthy Habits Mix',
      'duration': '8:30',
      'thumbnailColor': '0xFFA5D6A7',
      'videoId': 'D5SNCpL9m24',
      'thumbnailId': 'photo-1490645935967-10de6ba17051' // Healthy food/Habits
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get filteredManners {
    if (_searchQuery.isEmpty) {
      return manners;
    }
    return manners.where((manner) {
      final title = manner['title']?.toLowerCase() ?? '';
      return title.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF81C784), // Light Green
              Color(0xFF2E7D32), // Deep Forest Green
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'Daily Manners',
                  style: GoogleFonts.baloo2(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Learn Good Habits with Songs!',
                    style: GoogleFonts.baloo2(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Search manners (e.g., wash hand)...',
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredManners.isEmpty
                    ? Center(
                        child: Text(
                          'No videos found for "$_searchQuery"',
                          style: GoogleFonts.baloo2(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.78,
                        ),
                        itemCount: filteredManners.length,
                        itemBuilder: (context, index) {
                          final item = filteredManners[index];
                          return _MannerCard(
                            title: item['title']!,
                            duration: item['duration']!,
                            color: Color(int.parse(item['thumbnailColor']!)),
                            videoId: item['videoId']!,
                            thumbnailId: item['thumbnailId']!,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MannerCard extends StatelessWidget {
  final String title;
  final String duration;
  final Color color;
  final String videoId;
  final String thumbnailId;

  const _MannerCard({
    required this.title,
    required this.duration,
    required this.color,
    required this.videoId,
    required this.thumbnailId,
  });

  @override
  Widget build(BuildContext context) {
    final thumbUrl = 'https://images.unsplash.com/$thumbnailId?q=80&w=500';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryPlayerScreen(
              videoId: videoId,
              title: title,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      thumbUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: color.withOpacity(0.1),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            color: color.withOpacity(0.5),
                            size: 32,
                          ),
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: color.withOpacity(0.05),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: color.withOpacity(0.2),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    // Centered Play Button
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: color.withOpacity(0.8),
                          size: 32,
                        ),
                      ),
                    ),
                    // Duration Tag
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          duration,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.baloo2(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Watch Song',
                        style: GoogleFonts.baloo2(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: color.withOpacity(0.8),
                        ),
                      ),
                    ),
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
