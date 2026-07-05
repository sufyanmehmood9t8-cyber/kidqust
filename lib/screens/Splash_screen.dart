import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidquest/screens/landing_page_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LandingPageScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Avatars
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                     CircleAvatar(
                      backgroundImage: AssetImage('assets/images/book.png'),
                      radius: 35,
                    ),
                     CircleAvatar(
                      backgroundImage: AssetImage('assets/images/book.png'),
                      radius: 35,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              
              // Main Content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'KidQuest',
                    style: GoogleFonts.bangers(
                      fontSize: 84,
                      color: Colors.white,
                      letterSpacing: 4,
                      shadows: [
                        const Shadow(offset: Offset(4, 4), blurRadius: 10, color: Colors.black38),
                        Shadow(offset: const Offset(-2, -2), blurRadius: 4, color: Colors.blue.shade200),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Book Logo
                  Image.asset(
                    'assets/images/book_clean.png',
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Let's Go",
                    style: GoogleFonts.bangers(
                      fontSize: 50,
                      color: Colors.white,
                      letterSpacing: 4,
                      shadows: [
                        const Shadow(offset: Offset(4, 4), blurRadius: 10, color: Colors.black38),
                        Shadow(offset: const Offset(-2, -2), blurRadius: 4, color: Colors.blue.shade200),
                      ],
                    ),
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Footer
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Developed By',
                          style: GoogleFonts.bangers(
                            fontSize: 14,
                            color: Colors.white70,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          'Sufyan Mehmood',
                          style: GoogleFonts.bangers(
                            fontSize: 22,
                            color: Colors.white,
                            letterSpacing: 2,
                            shadows: const [
                              Shadow(offset: Offset(2, 2), blurRadius: 5, color: Colors.black26),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/pic.jpeg'),
                      radius: 35,
                      backgroundColor: Colors.white,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
