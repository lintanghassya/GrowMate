import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'add_product.dart';
import 'edit_product.dart';
// Pastikan path model ini benar di project kamu
import 'package:flutter_application_1/models/product_model.dart';

class ManageProductPage extends StatefulWidget {
  const ManageProductPage({super.key});

  @override
  State<ManageProductPage> createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  // Fungsi Refresh Data agar bisa dipanggil berulang kali
  void _refreshData() {
    setState(() {
      futureProducts = fetchProducts();
    });
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/plants'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json", // Ini biar Laravel tau kita mau JSON
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception('Gagal muat data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal konek ke Laravel: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/plants/$id'),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Berhasil dihapus!")));
      _refreshData(); // Panggil fungsi refresh yang kita buat tadi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          _buildGreenHeader(),
          Column(
            children: [
              _buildTopNav(context),
              _buildSearchBar(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: FutureBuilder<List<Product>>(
                    future: futureProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF4CAF50),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error: ${snapshot.error}",
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Belum ada data tanaman"),
                            const SizedBox(height: 10),
                            _buildAddButton(), // Tetap munculkan tombol add meski kosong
                          ],
                        );
                      }

                      final plants = snapshot.data!;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Plants (${plants.length})",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              _buildAddButton(),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async =>
                                  _refreshData(), // Biar bisa pull-to-refresh
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                                itemCount: plants.length,
                                itemBuilder: (context, index) =>
                                    productCard(index, plants[index]),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- UI Components ---
  Widget _buildGreenHeader() => Container(
    height: 250,
    decoration: const BoxDecoration(
      color: Color(0xFF4CAF50),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
    ),
  );

  Widget _buildTopNav(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(25, 60, 25, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
              'Manage Plants',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 48),
          child: Text(
            'View and edit your GrowMate plants',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    ),
  );

  Widget _buildSearchBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Search here",
        prefixIcon: const Icon(Icons.search),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );

  Widget _buildAddButton() => ElevatedButton(
    onPressed: () async {
      // Tunggu hasil dari halaman AddProduct
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddProductPage()),
      );
      // Jika berhasil simpan (return true), refresh datanya!
      if (result == true) {
        _refreshData();
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4CAF50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    child: const Text("Add Plant", style: TextStyle(color: Colors.white)),
  );

  Widget productCard(int index, Product plant) => Container(
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FDFB),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 130,
            width: double.infinity,
            color: Colors.grey[100],
            child: (plant.imageUrl != null && plant.imageUrl!.isNotEmpty)
                ? Image.network(
                    plant.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.eco, color: Colors.green, size: 50),
                  )
                : const Icon(Icons.eco, color: Colors.green, size: 50),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Pastikan field di model Product adalah 'name' atau 'namaProduct'
            Expanded(
              child: Text(
                plant.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF0D3B31),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildActiveBadge(),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoColumn("Price", "Rp ${plant.price}"),
            _infoColumn("Stock", "${plant.stock}"),
            _infoColumn("Sales", "0"),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _actionButton(
              label: "Edit",
              icon: Icons.edit_outlined,
              color: const Color(0xFF0D3B31),
              onTap: () {
                deleteProduct(plant.id);
              },
            ),
            const SizedBox(width: 10),
            _actionButton(
              label: "Delete",
              icon: Icons.delete_outline,
              color: Colors.redAccent,
              onTap: () {
                // Implementasi delete nanti di sini
              },
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildActiveBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFE8F5E9),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Text(
      "Active",
      style: TextStyle(
        color: Color(0xFF4CAF50),
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _infoColumn(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ],
  );

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 16, color: color),
    label: Text(
      label,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    ),
    style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
  );
}
