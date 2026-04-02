import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  // Controller untuk menangkap input user
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController _stockController =
      TextEditingController(); // Fixed: Added missing semicolon
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController wateringController = TextEditingController(
    text: "Every 5 days",
  );
  final TextEditingController fertilizingController = TextEditingController(
    text: "Every 14 days",
  );
  final TextEditingController descriptionController = TextEditingController();

  String selectedType = "Seed";
  String selectedCategory = "Herbs";
  bool isLoading = false;

  // FUNGSI UTAMA UNTUK KIRIM DATA KE LARAVEL
  Future<void> addProduct() async {
    // Validasi input wajib
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        _stockController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama, Harga, dan Stok wajib diisi!")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Parsing angka agar aman
      int priceValue = int.parse(
        priceController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      );
      int stockValue = int.parse(
        _stockController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      );

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/plants'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameController.text, // Sesuaikan dengan kolom DB
          "price": priceValue,
          "stock": stockValue,
          "type": selectedType,
          "category": selectedCategory,
          "image_url": imageUrlController.text.isEmpty
              ? "https://via.placeholder.com/150"
              : imageUrlController.text,
          "watering": wateringController.text,
          "fertilizing": fertilizingController.text,
          "description": descriptionController.text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Tanaman berhasil ditambah!"),
          ),
        );
        Navigator.pop(context, true); // Balik ke Manage Page & sinyal refresh
      } else {
        throw "Gagal ke server: ${response.statusCode}";
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Background Header
          Container(
            height: 250,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(200, 80),
              ),
            ),
          ),
          Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'Add New Plant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Form Area
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    sectionCard("Basic Information", [
                      inputLabel("Plant Name"),
                      customTextField(
                        "e.g., Spider Plant",
                        controller: nameController,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                inputLabel("Type"),
                                customDropdown(
                                  ["Seed", "Seedling", "Plant"],
                                  selectedType,
                                  (val) => setState(() => selectedType = val!),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                inputLabel("Category"),
                                customDropdown(
                                  ["Herbs", "Succulent", "Flowers", "Indoor"],
                                  selectedCategory,
                                  (val) =>
                                      setState(() => selectedCategory = val!),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      inputLabel("Price"),
                      customTextField(
                        "20000",
                        isNumber: true,
                        controller: priceController,
                      ),
                      const SizedBox(height: 15),
                      inputLabel("Stock"), // Bagian Stock yang baru ditambahin
                      customTextField(
                        "10",
                        isNumber: true,
                        controller: _stockController,
                      ),
                    ]),

                    sectionCard("Plant Image", [
                      inputLabel("Image URL"),
                      customTextField(
                        "https://image-url.com",
                        controller: imageUrlController,
                      ),
                    ]),

                    sectionCard("Care Instructions", [
                      inputLabel("Watering"),
                      customTextField(
                        "Every 5 days",
                        controller: wateringController,
                      ),
                      const SizedBox(height: 15),
                      inputLabel("Fertilizing"),
                      customTextField(
                        "Every 14 days",
                        controller: fertilizingController,
                      ),
                    ]),

                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: isLoading ? null : addProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Add Plant to Marketplace",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPERS ---
  Widget sectionCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget inputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF4CAF50),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget customTextField(
    String hint, {
    bool isNumber = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF9FBF9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget customDropdown(
    List<String> items,
    String currentValue,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBF9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          isExpanded: true,
          items: items
              .map((val) => DropdownMenuItem(value: val, child: Text(val)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
