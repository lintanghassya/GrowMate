import 'package:flutter/material.dart';
import 'screens/admin/auth_screen_admin.dart';
import 'screens/admin/dashboard_screen_admin.dart';
import 'screens/admin/add_product.dart';
import 'screens/admin/manage_order.dart';
import 'screens/admin/manage_product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant Shop',
      theme: ThemeData(
        primaryColor: const Color(0xFF0D3B31),
        fontFamily: 'Poppins',
      ),

      home: const AuthScreen(),

      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/add_product': (context) => const AddProductPage(),
        '/manage_order': (context) => const ManageOrderPage(),
        '/manage_product': (context) => const ManageProductPage(),
      },
    );
  }
}
