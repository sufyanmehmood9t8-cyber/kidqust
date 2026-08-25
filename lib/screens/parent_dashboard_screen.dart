// ============================================================
// lib/screens/parent_dashboard_screen.dart
// Little Scholars – PIN-Protected Parent Dashboard
// ============================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/language_provider.dart';
import '../providers/progress_provider.dart';
import '../constants/app_constants.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});
  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  bool _authenticated = false;
  String _enteredPin = '';
  String _savedPin = '1234';
  bool _wrongPin = false;
  int _screenTimeLimit = 30; // minutes
  bool _audioEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPin = prefs.getString('parent_pin') ?? '1234';
      _screenTimeLimit = prefs.getInt('screen_time_limit') ?? 30;
      _audioEnabled = prefs.getBool('audio_enabled') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('screen_time_limit', _screenTimeLimit);
    await prefs.setBool('audio_enabled', _audioEnabled);
  }

  Future<void> _changePin(String newPin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('parent_pin', newPin);
    setState(() => _savedPin = newPin);
  }

  void _onPinDigit(String digit) {
    if (_enteredPin.length < 4) {
      setState(() {
        _enteredPin += digit;
        _wrongPin = false;
      });
      if (_enteredPin.length == 4) {
        _checkPin();
      }
    }
  }

  void _checkPin() {
    if (_enteredPin == _savedPin) {
      setState(() => _authenticated = true);
    } else {
      setState(() {
        _wrongPin = true;
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isUrdu = lang.isUrdu;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          ),
        ),
        child: SafeArea(
          child: _authenticated
              ? _buildDashboard(context, isUrdu)
              : _buildPinScreen(isUrdu),
        ),
      ),
    );
  }

  // ============ PIN Entry Screen ============
  Widget _buildPinScreen(bool isUrdu) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔐', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(
            isUrdu ? 'والدین کا پینل' : 'Parent Dashboard',
            style: GoogleFonts.nunito(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.get('enter_pin', isUrdu),
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 28),
          // PIN Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) {
              final filled = i < _enteredPin.length;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _wrongPin
                      ? Colors.red
                      : filled
                          ? AppColors.purple
                          : Colors.white24,
                  border: Border.all(
                    color: _wrongPin ? Colors.red : Colors.white30,
                    width: 2,
                  ),
                ),
              );
            }),
          ),
          if (_wrongPin)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                isUrdu ? '❌ غلط پن' : '❌ Wrong PIN',
                style: GoogleFonts.nunito(color: Colors.red, fontSize: 14),
              ),
            ),
          const SizedBox(height: 28),
          // Number Pad
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 12,
              itemBuilder: (_, i) {
                final labels = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];
                final label = labels[i];
                if (label.isEmpty) return const SizedBox();
                return GestureDetector(
                  onTap: () {
                    if (label == '⌫') {
                      setState(() {
                        if (_enteredPin.isNotEmpty) {
                          _enteredPin =
                              _enteredPin.substring(0, _enteredPin.length - 1);
                        }
                      });
                    } else {
                      _onPinDigit(label);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Center(
                      child: Text(
                        label,
                        style: GoogleFonts.nunito(
                          fontSize: label == '⌫' ? 18 : 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white54, size: 18),
            label: Text(
              isUrdu ? 'واپس' : 'Go Back',
              style: GoogleFonts.nunito(color: Colors.white54, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // ============ Dashboard Screen ============
  Widget _buildDashboard(BuildContext context, bool isUrdu) {
    final progress = context.watch<ProgressProvider>();

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isUrdu ? '👨‍👩‍👧 والدین کا پینل' : '👨‍👩‍👧 Parent Dashboard',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Summary
                _SectionLabel(
                    label: isUrdu ? '📊 بچے کی ترقی' : '📊 Child Progress',
                    isUrdu: isUrdu),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _InfoCard(
                      emoji: '⭐',
                      value: '${progress.totalStars}',
                      label: isUrdu ? 'ستارے' : 'Stars',
                      color: AppColors.yellow,
                    ),
                    const SizedBox(width: 10),
                    _InfoCard(
                      emoji: '📖',
                      value: '${progress.completedLessons.length}',
                      label: isUrdu ? 'اسباق' : 'Lessons',
                      color: AppColors.green,
                    ),
                    const SizedBox(width: 10),
                    _InfoCard(
                      emoji: '🏅',
                      value: '${progress.earnedBadges.length}',
                      label: isUrdu ? 'بیجز' : 'Badges',
                      color: AppColors.pink,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Screen Time Control
                _SectionLabel(
                    label: isUrdu ? '⏱️ اسکرین ٹائم' : '⏱️ Screen Time Limit',
                    isUrdu: isUrdu),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isUrdu
                                ? 'روزانہ حد: $_screenTimeLimit منٹ'
                                : 'Daily Limit: $_screenTimeLimit min',
                            style: GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '⏱️ $_screenTimeLimit min',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              color: AppColors.orange,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _screenTimeLimit.toDouble(),
                        min: 10,
                        max: 120,
                        divisions: 11,
                        activeColor: AppColors.orange,
                        inactiveColor: Colors.white24,
                        onChanged: (v) {
                          setState(() => _screenTimeLimit = v.round());
                          _saveSettings();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Audio Toggle
                _SectionLabel(
                    label: isUrdu ? '🔊 آواز کی ترتیبات' : '🔊 Audio Settings',
                    isUrdu: isUrdu),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isUrdu ? 'آواز قرات فعال کریں' : 'Enable Audio Narration',
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Switch(
                        value: _audioEnabled,
                        onChanged: (v) {
                          setState(() => _audioEnabled = v);
                          _saveSettings();
                        },
                        activeColor: AppColors.green,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Change PIN
                _SectionLabel(
                    label: isUrdu ? '🔐 پن تبدیل کریں' : '🔐 Change PIN',
                    isUrdu: isUrdu),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showChangePinDialog(context, isUrdu),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.purple.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: AppColors.purple.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_rounded,
                            color: AppColors.purpleLight, size: 22),
                        const SizedBox(width: 12),
                        Text(
                          isUrdu
                              ? 'موجودہ پن: ****'
                              : 'Current PIN: ****',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          isUrdu ? 'تبدیل کریں' : 'Change',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: AppColors.purpleLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showChangePinDialog(BuildContext context, bool isUrdu) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B4B),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isUrdu ? 'نیا پن درج کریں (4 ہندسے)' : 'Enter New PIN (4 digits)',
          style: GoogleFonts.nunito(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
          style: const TextStyle(color: Colors.white, fontSize: 20),
          decoration: InputDecoration(
            counterStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isUrdu ? 'منسوخ' : 'Cancel',
                style: const TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (controller.text.length == 4) {
                _changePin(controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    isUrdu ? '✅ پن تبدیل ہو گیا' : '✅ PIN changed successfully',
                    style: GoogleFonts.nunito(),
                  ),
                  backgroundColor: AppColors.green,
                ));
              }
            },
            child: Text(isUrdu ? 'محفوظ کریں' : 'Save',
                style: GoogleFonts.nunito()),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isUrdu;
  const _SectionLabel({required this.label, required this.isUrdu});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Colors.white70,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String emoji, value, label;
  final Color color;
  const _InfoCard(
      {required this.emoji,
      required this.value,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.nunito(fontSize: 11, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
