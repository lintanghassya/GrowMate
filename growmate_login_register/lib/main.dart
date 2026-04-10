import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const GrowMateApp());
}

class GrowMateApp extends StatelessWidget {
  const GrowMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GrowMate',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF8FAF8),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(), // SplashScreen akan mengarahkan ke OnboardingScreen
    );
  }
}