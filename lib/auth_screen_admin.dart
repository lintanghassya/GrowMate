import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: Stack(
        children: [
          // Background Hijau tetap ada di atas
          const SizedBox(height: 250, width: double.infinity),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.82,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  children: [
                    const Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 28, 
                        fontWeight: FontWeight.bold, 
                        color: Color(0xFF0D3B31)
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Admin Special Access Only",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 40),
                    
                    // Input Fields
                    _buildField(Icons.email_outlined, "Admin Email"),
                    const SizedBox(height: 20),
                    _buildField(Icons.lock_outline, "Password", isPass: true),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {}, 
                        child: const Text("Forgot Password?", style: TextStyle(color: Colors.grey))
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Button Sign In
                    ElevatedButton(
                      onPressed: () {
                        // Di sini nanti kamu bisa tambah validasi email/pass khusus admin
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D3B31),
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                      ),
                      child: const Text(
                        "Sign in", 
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("or login with", style: TextStyle(color: Colors.grey))),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 30),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialIcon('lib/assets/LOGO_FACEBOOK.webp'),
                        const SizedBox(width: 25),
                        _socialIcon('lib/assets/LOGO_GOOGLE.webp'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(IconData icon, String hint, {bool isPass = false}) => TextField(
    obscureText: isPass,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF0D3B31)),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFF0D3B31))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(color: Colors.grey.shade300)),
    ),
  );

  Widget _socialIcon(String path) => Container(
    height: 60, width: 80, padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300),
    ),
    child: Image.asset(path, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.error)),
  );
}