import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Checkout extends StatefulWidget {
  final int price;
  const Checkout({super.key, required this.price});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String shippingMethod = "Instant";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Method untuk menampilkan popup order detail
  void _showOrderDetailPopup(BuildContext context, String customerName, String address, String shipping, int total) {
    showDialog(
      context: context,
      barrierDismissible: false, // User harus tekan tombol Close
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha:0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF4CAF50),
                    size: 50,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Order Detail",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF234536),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Order Info Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6F4),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFD2EFDA)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow("Customer:", customerName),
                      const SizedBox(height: 12),
                      _buildDetailRow("Address:", address),
                      const SizedBox(height: 12),
                      _buildDetailRow("Shipping Method:", shipping),
                      const SizedBox(height: 12),
                      _buildDetailRow("Order Date:", _getCurrentDate()),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      _buildDetailRow("Items:", "Spider Plant - Rp${widget.price}"),
                      const SizedBox(height: 12),
                      _buildTotalRow("Total:", "Rp$total"),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper untuk membuat row detail
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF234536),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
            ),
          ),
        ),
      ],
    );
  }

  // Helper untuk membuat row total
  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF234536),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }

  // Mendapatkan tanggal saat ini
  String _getCurrentDate() {
    final DateTime now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    int shipping = shippingMethod == "Instant" ? 500 : 
                   shippingMethod == "Same Day" ? 400 :
                   shippingMethod == "Regular" ? 300 : 200;
    int total = widget.price + shipping;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF234536)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Checkout",
              style: TextStyle(
                color: Color(0xFF234536),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Complete your purchase",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Order Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD2EFDA)),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Summary",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F4336),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          "lib/assets/spider_plant.png",
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Spider Plant",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Rp${widget.price}",
                        style: const TextStyle(
                          color: Color(0xFF34C759),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Subtotal"),
                      Text("Rp${widget.price}"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text("Shipping"), Text("Rp$shipping")],
                  ),
                  const Divider(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rp$total",
                        style: const TextStyle(
                          color: Color(0xFF34C759),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Shipping Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD2EFDA)),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Recipient Name"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      filled: true,
                      fillColor: const Color(0xFFF1F8F4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Shipping Address"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      hintText: "Enter your address",
                      filled: true,
                      fillColor: const Color(0xFFF1F8F4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Shipping Method"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8F4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: shippingMethod,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: const [
                          DropdownMenuItem(
                            value: "Instant",
                            child: Text("Instant (1-2 Hours) - Rp500"),
                          ),
                          DropdownMenuItem(
                            value: "Same Day",
                            child: Text("Same Day Delivery - Rp400"),
                          ),
                          DropdownMenuItem(
                            value: "Regular",
                            child: Text("Regular (2-3 Days) - Rp300"),
                          ),
                          DropdownMenuItem(
                            value: "Economy",
                            child: Text("Economy (4-7 Days) - Rp200"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            shippingMethod = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // QR PAYMENT
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD2EFDA)),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const Text(
                    "Scan to Pay",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F4336),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  QrImageView(
                    data: "PAYMENT-${widget.price}-${DateTime.now().millisecondsSinceEpoch}",
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                  
                  const SizedBox(height: 16),
                  const Text(
                    "Please scan QR code to complete your payment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF3A3A3A),
                              width: 1.2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color(0xFF3A3A3A),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Validasi input
                            if (nameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter your name"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            if (addressController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter your address"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            
                            // Tampilkan popup order detail
                            _showOrderDetailPopup(
                              context,
                              nameController.text,
                              addressController.text,
                              shippingMethod,
                              total,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Confirm Payment",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}