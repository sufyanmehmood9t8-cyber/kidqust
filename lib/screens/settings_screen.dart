import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AppSettings _settings = AppSettings();

  @override
  void initState() {
    super.initState();
    _settings.onSettingsChanged = () {
      if (mounted) setState(() {});
    };
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _resetProgress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Progress?'),
        content: const Text('This will reset all your stars and scores to zero. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              _settings.resetProgress();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Progress has been reset!')),
              );
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Parent Settings',
                  style: GoogleFonts.baloo2(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _settings.themeColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionHeader('Sound & Music'),
                _buildSwitchTile(
                  'Background Music',
                  'Play soft background music',
                  _settings.isMusicEnabled,
                  (v) => _settings.updateSettings(music: v),
                ),
                _buildSwitchTile(
                  'Sound Effects',
                  'Play "Ding" and "Pop" sounds',
                  _settings.isSoundEffectsEnabled,
                  (v) => _settings.updateSettings(sounds: v),
                ),
                
                _buildSectionHeader('App Customization'),
                _buildDropdownTile(
                  'App Language',
                  'Select UI language',
                  _settings.language,
                  ['English', 'Urdu'],
                  (v) => _settings.updateSettings(lang: v),
                ),
                _buildThemeColorPicker(),

                _buildSectionHeader('Progress & Reports'),
                _buildActionTile(
                  'Reset Progress',
                  'Clear stars and high scores',
                  Icons.restart_alt_rounded,
                  Colors.red,
                  _resetProgress,
                ),
                _buildActionTile(
                  'Learning Reports',
                  'Review activity summary',
                  Icons.analytics_rounded,
                  Colors.blue,
                  () {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report: You have studied for 15 minutes today!')),
                    );
                  },
                ),

                _buildSectionHeader('Support & Legal'),
                _buildActionTile(
                  'Rate Us',
                  'Support KidQuest on Play Store',
                  Icons.star_rate_rounded,
                  Colors.orange,
                  () => _launchUrl('https://play.google.com/store/apps'),
                ),
                _buildActionTile(
                  'Privacy Policy',
                  'How we protect your data',
                  Icons.privacy_tip_rounded,
                  Colors.grey,
                  () => _launchUrl('https://kidquestapp.example/privacy'),
                ),
                _buildActionTile(
                  'Contact Us',
                  'Send us an email',
                  Icons.email_rounded,
                  Colors.teal,
                  () => _launchUrl('mailto:support@kidquestapp.example'),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      child: Text(
        title,
        style: GoogleFonts.baloo2(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _settings.themeColor,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(title, style: GoogleFonts.baloo2(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: GoogleFonts.baloo2(fontSize: 14)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: _settings.themeColor,
      ),
    );
  }

  Widget _buildDropdownTile(String title, String subtitle, String value, List<String> items, Function(String?) onChanged) {
    return ListTile(
      title: Text(title, style: GoogleFonts.baloo2(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: GoogleFonts.baloo2(fontSize: 14)),
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        underline: Container(),
      ),
    );
  }

  Widget _buildThemeColorPicker() {
    final colors = [
      {'name': 'Pink', 'color': const Color(0xFFFF4081)},
      {'name': 'Blue', 'color': const Color(0xFF2196F3)},
      {'name': 'Yellow', 'color': const Color(0xFFFDE400)},
    ];
    return ListTile(
      title: Text('Theme Color', style: GoogleFonts.baloo2(fontWeight: FontWeight.bold)),
      subtitle: Row(
        children: colors.map((c) {
          bool isSelected = _settings.themeColor.value == (c['color'] as Color).value;
          return GestureDetector(
            onTap: () => _settings.updateSettings(theme: c['color'] as Color),
            child: Container(
              margin: const EdgeInsets.only(right: 15, top: 8),
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: c['color'] as Color,
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? Colors.black : Colors.grey[300]!, width: isSelected ? 3 : 1),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color, size: 28),
      title: Text(title, style: GoogleFonts.baloo2(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: GoogleFonts.baloo2(fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}
