import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedActionIndex = -1; // -1 berarti tidak ada yang terpilih awal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- PERUBAHAN UTAMA DI SINI ---
      // Ganti warna background Scaffold menjadi abu-abu sangat muda (seperti desain)
      backgroundColor: const Color(0xFFF5F5F5), 
      
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header Hijau
              Container(
                padding: const EdgeInsets.fromLTRB(25, 60, 25, 40),
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40), 
                    bottomRight: Radius.circular(40)
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Admin Dashboard", 
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/'), 
                          icon: const Icon(Icons.logout, color: Colors.white)
                        ),
                      ],
                    ),
                    const Text("Manage GrowMate Platform", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 30),
                    Row(children: [_statCard("30", "Total Users", Icons.people, Colors.purple), const SizedBox(width: 15), _statCard("102", "Active Plants", Icons.eco, Colors.green)]),
                    const SizedBox(height: 15),
                    Row(children: [_statCard("30", "Total Orders", Icons.shopping_bag, Colors.blue), const SizedBox(width: 15), _statCard("4", "Pending", Icons.layers, Colors.orange)]),
                  ],
                ),
              ),

              // Quick Action Section
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Quick Action", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0D3B31))),
                    const SizedBox(height: 20),
                    
                    // Daftar Quick Action
                    _actionTile(0, "Add New Product", "Add plants to marketplace", Icons.add),
                    _actionTile(1, "Manage Products", "View and edit product", Icons.inventory_2_outlined),
                    _actionTile(2, "Manage Orders", "View and update orders", Icons.grid_view),
                    
                    const SizedBox(height: 30),
                    
                    // Welcome Admin Card (Juga warna putih agar kontras dengan background abu-abu)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03), // Bayangan sangat halus
                            blurRadius: 10, 
                            offset: const Offset(0, 4)
                          )
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
                          SizedBox(width: 15),
                          Text("Welcome Admin!", 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D3B31))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper Stat Card (Tetap Putih)
  Widget _statCard(String val, String label, IconData icon, Color col) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white, // Harus tetap putih agar terlihat mengambang
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02), // Bayangan super halus
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: col, size: 28),
          const SizedBox(width: 10),
          Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
          ])),
        ],
      ),
    ),
  );

  // Widget Helper Action Tile (Interaktif)
  Widget _actionTile(int index, String title, String sub, IconData icon) {
    bool isSelected = selectedActionIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedActionIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18), // Sedikit lebih lega
        decoration: BoxDecoration(
          // Logika warna interaktif: Hijau muda jika diklik, Putih jika tidak
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent, // Border hanya muncul saat dipilih
            width: 1.5
          ),
          boxShadow: [
            if (!isSelected) // Bayangan hanya saat tidak dipilih
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3)
              )
          ],
        ),
        child: Row(
          children: [
            // Container Icon lingkaran putih
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Icon(icon, color: isSelected ? Colors.green : Colors.grey.shade600, size: 22),
            ),
            const SizedBox(width: 18),
            Expanded( // Pakai Expanded agar teks tidak nabrak
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, 
                    style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 15,
                        color: isSelected ? const Color(0xFF0D3B31) : Colors.black87)),
                Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ]),
            ),
            if (isSelected) // Tambahkan checkmark kecil jika dipilih (opsional, tapi bagus buat UX)
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }
}