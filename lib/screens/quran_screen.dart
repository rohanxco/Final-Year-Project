// lib/screens/quran_screen.dart
import 'package:flutter/material.dart';

class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Qur'an")),
      body: const Center(
        child: Text(
          "Qur'an screen is wired ✅\n\nNext: load JSON and show Surah list",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
