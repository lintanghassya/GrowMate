import 'package:flutter/material.dart';
import 'main_navigation.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Data konten sesuai prototype kamu
  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to GrowMate",
      "desc": "Your plant care assistant that helps you keep your plants healthy and thriving every day.",
      "image": "lib/assets/onboard1.png"
    },
    {
      "title": "Organize Plant Care Easily",
      "desc": "Create and manage watering, fertilizing, and care schedules for all your plants in one place.",
      "image": "lib/assets/onboard2.png"
    },
    {
      "title": "Never Miss a Care Routine",
      "desc": "Receive timely reminders so your plants always get the care they need.",
      "image": "lib/assets/onboard3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Indikator Garis di Atas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: List.generate(onboardingData.length, (index) => Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _currentIndex == index ? const Color(0xFF2D9354) : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )),
              ),
            ),
            
            // Konten (Gambar & Teks)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  // Di dalam itemBuilder PageView:
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(  // ✅ Tambahkan ini
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            onboardingData[index]["image"]!,
                            height: 380,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          onboardingData[index]["title"]!,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          onboardingData[index]["desc"]!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20), // ✅ Extra space di bawah
                      ],
                    ),
                  ),
                );
                },
              ),
            ),

            // Tombol Panah Hijau (Circle)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    if (_currentIndex < onboardingData.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavigation()),
                    );
                  }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2D9354), // Hijau GrowMate
                      shape: BoxShape.circle, // Memperbaiki error BoxBoxShape
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}