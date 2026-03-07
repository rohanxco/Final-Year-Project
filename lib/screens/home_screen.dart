import 'package:flutter/material.dart';

import 'prayer_times_screen.dart';
import 'qibla_screen.dart';
import 'quran_screen.dart';
import 'mosque_finder_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Azaan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Tile(
            icon: Icons.schedule,
            title: "Prayer Times",
            subtitle: "View today's prayer times + next prayer",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrayerTimesScreen()),
            ),
          ),
          const SizedBox(height: 12),

          _Tile(
            icon: Icons.explore,
            title: "Qibla",
            subtitle: "Bearing + arrow guidance",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QiblaScreen()),
            ),
          ),
          const SizedBox(height: 12),

          _Tile(
            icon: Icons.location_on,
            title: "Mosque Finder",
            subtitle: "Find nearby mosques using your location",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MosqueFinderScreen()),
            ),
          ),
          const SizedBox(height: 12),

          _Tile(
            icon: Icons.menu_book,
            title: "Qur'an",
            subtitle: "Read Surahs and verses",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QuranScreen()),
            ),
          ),
          const SizedBox(height: 12),

          _Tile(
            icon: Icons.settings,
            title: "Settings",
            subtitle: "Manual location + storage actions",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}