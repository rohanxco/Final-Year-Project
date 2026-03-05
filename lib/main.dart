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
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 25, 57, 218),
        fontFamily: 'Amiri',
      ),
      home: const HomeScreen(),
    );
  }
}
