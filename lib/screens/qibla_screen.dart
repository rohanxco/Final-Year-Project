// lib/screens/qibla_screen.dart
import 'package:flutter/material.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qibla')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Qibla feature placeholder.\n\n'
            'Next step: use sensors/compass + Kaaba bearing calculation.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
