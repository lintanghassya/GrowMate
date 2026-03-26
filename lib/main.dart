import 'package:flutter/material.dart';
import 'auth_screen_admin.dart';
import 'dashboard_screen_admin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GrowMate App',
      theme: ThemeData(primarySwatch: Colors.green),
      // Kita tentukan rute di sini
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}