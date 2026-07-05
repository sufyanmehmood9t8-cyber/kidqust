import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidquest/screens/Splash_screen.dart';
import 'screens/landing_page_screen.dart';

void main() {
  runApp(const KidQuestApp());
}

class KidQuestApp extends StatelessWidget {
  const KidQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KidQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFDE400),
          primary: const Color(0xFFFDE400),
          secondary: const Color(0xFF87CEEB),
          tertiary: const Color(0xFFFF4081),
        ),
        textTheme: GoogleFonts.baloo2TextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
