import 'dart:async';
import 'package:flutter/material.dart';
import 'onboard.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background daun
          Positioned.fill(
            child: Image.asset(
              'lib/assets/bg_splash.jpeg', // Perbaiki path: tambahkan 'assets/'
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Tampilkan placeholder jika gambar tidak ditemukan
                return Container(
                  color: const Color(0xFF4CAF50),
                  child: const Center(
                    child: Text(
                      '🌱',
                      style: TextStyle(fontSize: 100),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Logo dengan shadow
          Center(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1), 
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Image.asset(
                'lib/assets/logo.png', // Perbaiki path: tambahkan 'assets/' dan pastikan nama file benar
                width: 200,
                errorBuilder: (context, error, stackTrace) {
                  // Tampilkan teks jika logo tidak ditemukan
                  return const Text(
                    'GrowMate',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 7, 35, 8),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}