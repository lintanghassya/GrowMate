import 'package:flutter/material.dart';

class ManageOrderPage extends StatefulWidget {
  const ManageOrderPage({super.key});

  @override
  State<ManageOrderPage> createState() => _ManageOrderPageState();
}

class _ManageOrderPageState extends State<ManageOrderPage> {
  String selectedFilter = 'All (6)';

  List<Map<String, dynamic>> orders = [
    {
      'id': 1,
      'name': 'Monstera Deliciosa',
      'email': 'carlozz@gmail.com',
      'price': 'Rp2000',
      'date': 'March 4, 2026',
      'status': 'Delivered',
    },
    {
      'id': 2,
      'name': 'Monstera Deliciosa',
      'email': 'carlozz@gmail.com',
      'price': 'Rp2000',
      'date': 'March 4, 2026',
      'status': 'Processing',
    },
    {
      'id': 3,
      'name': 'Monstera Deliciosa',
      'email': 'carlozz@gmail.com',
      'price': 'Rp2000',
      'date': 'March 4, 2026',
      'status': 'Shipped',
    },
    {
      'id': 4,
      'name': 'Monstera Deliciosa',
      'email': 'carlozz@gmail.com',
      'price': 'Rp2000',
      'date': 'March 4, 2026',
      'status': 'Shipped',
    },
    {
      'id': 5,
      'name': 'Monstera Deliciosa',
      'email': 'carlozz@gmail.com',
      'price': 'Rp2000',
      'date': 'March 4, 2026',
      'status': 'Delivered',
    },
    {
      'id': 6,
      'name': 'Monstera Deliciosa',
      'email': 'carlozz@gmail.com',
      'price': 'Rp2000',
      'date': 'March 4, 2026',
      'status': 'Delivered',
    },
  ];

  int getCount(String status) {
    if (status == "All") return orders.length;
    return orders.where((o) => o['status'] == status).length;
  }

  void updateStatus(int id, String currentStatus) {
    setState(() {
      int index = orders.indexWhere((o) => o['id'] == id);
      if (currentStatus == 'Processing') {
        orders[index]['status'] = 'Shipped';
      } else if (currentStatus == 'Shipped') {
        orders[index]['status'] = 'Delivered';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredOrders = orders.where((o) {
      if (selectedFilter.contains("All")) return true;
      return selectedFilter.contains(o['status']);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FCF9),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return _buildOrderCard(order);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF4CAF50),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manage Orders',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${getCount("All")} total orders',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 25),

          Center(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.center,
              children: [
                _filterButton("All (${getCount("All")})"),
                _filterButton("Pending (0)"),
                _filterButton("Processing (${getCount("Processing")})"),
                _filterButton("Shipped (${getCount("Shipped")})"),
                _filterButton("Delivered (${getCount("Delivered")})"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String label) {
    bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFACE3B0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    String status = order['status'];
    Color statusColor = status == 'Delivered'
        ? Colors.green
        : (status == 'Processing' ? Colors.orange : Colors.blue);
    Color bgColor = statusColor.withValues(alpha: 0.15);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFC4C4C4)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'images/monstera.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[200],
                      child: const Icon(Icons.eco, color: Colors.green),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      order['email'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order['price'],
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          order['date'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 25),
          order['status'] == 'Delivered'
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Order Completed",
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              : OutlinedButton.icon(
                  onPressed: () {
                    updateStatus(order['id'], order['status']);
                  },
                  icon: Icon(
                    order['status'] == 'Processing'
                        ? Icons.local_shipping_outlined
                        : Icons.check_circle_outline,
                    size: 18,
                  ),
                  label: Text(
                    order['status'] == 'Processing'
                        ? "Mark as Shipped"
                        : "Mark as Delivered",
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
