import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Jembatan ke Laravel
import 'dart:convert'; // Untuk mengolah data JSON
import 'main_navigation.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignIn = true;
  bool isLoading = false; // Untuk indikator loading

  // Controllers untuk mengambil input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // --- FUNGSI LOGIN (API) ---
  Future<void> _handleSignIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    setState(() => isLoading = true);

    try {
      // Gunakan 10.0.2.2 untuk Emulator Android
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/login'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showSuccess("Welcome back, ${data['user']['name']}! 🌱");
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      } else {
        final error = jsonDecode(response.body);
        _showError(error['message'] ?? "Login failed");
      }
    } catch (e) {
      _showError("Connection error. Is Laravel running?");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // --- FUNGSI REGISTER (API) ---
  Future<void> _handleSignUp() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/register'),
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password, // Biasanya Laravel butuh ini
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSuccess("Account created successfully! 🎉");
        setState(() {
          isSignIn = true;
          nameController.clear();
          emailController.clear();
          passwordController.clear();
        });
      } else {
        final error = jsonDecode(response.body);
        _showError(error['message'] ?? "Registration failed");
      }
    } catch (e) {
      _showError("Connection error. Check your server.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: double.infinity,
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
                    Text(
                      isSignIn ? "Welcome Back!" : "Create Account",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D3B31),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Toggle
                    Container(
                      height: 55,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          _buildToggleButton("Sign in", isSignIn),
                          _buildToggleButton("Sign up", !isSignIn),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Input
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        key: ValueKey<bool>(isSignIn),
                        children: [
                          if (!isSignIn) ...[
                            _buildTextField(
                              Icons.person_outline, 
                              "Full Name",
                              controller: nameController,
                            ),
                            const SizedBox(height: 20),
                          ],
                          _buildTextField(
                            Icons.email_outlined, 
                            "Email",
                            controller: emailController,
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            Icons.lock_outline, 
                            "Password", 
                            isPassword: true,
                            controller: passwordController,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 25),

                    // Main Action Button
                    ElevatedButton(
                      onPressed: isLoading ? null : () {
                        if (isSignIn) {
                          _handleSignIn();
                        } else {
                          _handleSignUp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D3B31),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isSignIn ? "Sign In" : "Sign Up",
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPERS ---
  Widget _buildToggleButton(String text, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isSignIn = (text == "Sign in")),
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? const Color(0xFF0D3B31) : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, {bool isPassword = false, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF0D3B31)),
        hintText: hint,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFF0D3B31), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
        ),
      ),
    );
  }
}