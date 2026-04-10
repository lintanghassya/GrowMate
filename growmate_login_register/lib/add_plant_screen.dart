import 'package:flutter/material.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({super.key});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final List<String> categories = ["Herbs", "Succulent", "Flowers"];
  String? selectedCategory;
  
  // Pilihan untuk Watering Frequency
  final List<String> wateringOptions = [
    "Every day",
    "Every 2 days",
    "Every 3 days",
    "Every 5 days",
    "Every week",
    "Every 2 weeks",
    "Every month",
  ];
  String? selectedWatering;
  
  // Pilihan untuk Fertilizing Frequency
  final List<String> fertilizingOptions = [
    "Every week",
    "Every 2 weeks",
    "Every 3 weeks",
    "Every month",
    "Every 2 months",
    "Every 3 months",
  ];
  String? selectedFertilizing;

  // Controllers untuk mengambil input dari text field
  final TextEditingController plantNameController = TextEditingController();
  final TextEditingController plantingDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCategory = categories[0]; // Set default ke item pertama
    selectedWatering = "Every 5 days"; // Set default watering
    selectedFertilizing = "Every 2 weeks"; // Set default fertilizing
  }

  @override
  void dispose() {
    plantNameController.dispose();
    plantingDateController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4CAF50),
              onPrimary: Colors.white,
              surface: Color(0xFF4CAF50),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        plantingDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Fungsi untuk menyimpan data plant
  void _savePlant() {
    // Validasi input
    if (plantNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter plant name"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    if (plantingDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select planting date"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // Tampilkan pesan sukses dengan detail
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "🌱 ${plantNameController.text} has been added to your collection!\n"
          "💧 Water: $selectedWatering\n"
          "🌿 Fertilize: $selectedFertilizing",
          style: const TextStyle(fontSize: 12),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 3),
      ),
    );
    
    // Kembali ke halaman sebelumnya setelah 1.5 detik
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4CAF50);
    const Color softGreenBg = Color(0xFFF1F8F1);
    const Color inputBg = Color(0xFFF0F4F0);

    return Scaffold(
      backgroundColor: softGreenBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF234536)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Add New Plant",
          style: TextStyle(
            color: Color(0xFF234536),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // Form Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Card: Plant Information
                  _buildSectionCard(
                    title: "Plant Information",
                    children: [
                      _buildLabel("Plant Name *"),
                      _buildTextField(
                        plantNameController,
                        "e.g., Spider Plant",
                        inputBg,
                      ),
                      const SizedBox(height: 15),
                      
                      _buildLabel("Planting Date *"),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: _buildTextField(
                            plantingDateController,
                            "Select date",
                            inputBg,
                            suffixIcon: const Icon(Icons.calendar_today, size: 20, color: Color(0xFF4CAF50)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      _buildLabel("Category"),
                      _buildDropdown(categories, inputBg, selectedCategory, (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      }),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Card: Care Schedule
                  _buildSectionCard(
                    title: "Care Schedule",
                    children: [
                      _buildLabel("Watering Frequency"),
                      _buildDropdown(
                        wateringOptions, 
                        inputBg, 
                        selectedWatering, 
                        (value) {
                          setState(() {
                            selectedWatering = value;
                          });
                        },
                        hint: "Select watering frequency",
                      ),
                      const SizedBox(height: 15),
                      
                      _buildLabel("Fertilizing Frequency"),
                      _buildDropdown(
                        fertilizingOptions, 
                        inputBg, 
                        selectedFertilizing, 
                        (value) {
                          setState(() {
                            selectedFertilizing = value;
                          });
                        },
                        hint: "Select fertilizing frequency",
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Buttons
                  ElevatedButton.icon(
                    onPressed: _savePlant,
                    icon: const Icon(Icons.add),
                    label: const Text(
                      "Add Plant to Collection",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      side: const BorderSide(color: Colors.black54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                  ),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black12.withValues(alpha: 0.05)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4332),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D6A4F),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    Color bgColor, {
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: bgColor,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    List<String> items,
    Color bgColor,
    String? selectedValue,
    Function(String?) onChanged, {
    String hint = "Select option",
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(color: Colors.grey[400]),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4CAF50)),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          dropdownColor: Colors.white,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}