import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const AzaanApp());
}

class AzaanApp extends StatelessWidget {
  const AzaanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azaan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Amiri'),
      home: const HomeScreen(),
    );
  }
}
