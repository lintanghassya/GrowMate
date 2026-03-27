import 'package:flutter/material.dart';
import 'checkout.dart';
import 'my_plants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DetailPlant(),
    );
  }
}

class DetailPlant extends StatefulWidget {
  const DetailPlant({super.key});

  @override
  State<DetailPlant> createState() => _DetailPlantState();
}

class _DetailPlantState extends State<DetailPlant> {
  int quantity = 1;
  final int price = 2000;

  int get totalPrice => quantity * price;

  void tambah() {
    setState(() {
      quantity++;
    });
  }

  void kurang() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F3),

      /// NAVBAR
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /// HOME
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.home_outlined, color: Colors.grey),
                  SizedBox(height: 4),
                  Text("Home", style: TextStyle(fontSize: 12)),
                ],
              ),

              /// SHOP
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_bag_outlined, color: Color(0xFF234536)),
                  SizedBox(height: 4),
                  Text(
                    "Shop",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF234536),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              /// PLANTS
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyPlantsPage(),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.spa_outlined, color: Colors.grey),
                    SizedBox(height: 4),
                    Text("Plants", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),

              /// CARE
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications_none, color: Colors.grey),
                  SizedBox(height: 4),
                  Text("Care", style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            /// IMAGE + CARD
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Image.asset(
                    "assets/images/spider_plant.png",
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(20, 230, 20, 0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD6EAD9)),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Spider Plant",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F4D3F),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Text(
                            "Rp$price",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "per seedling",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// QUANTITY
                      Row(
                        children: [
                          const Text(
                            "Quantity:",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: kurang,
                          ),
                          Text(
                            "$quantity",
                            style: const TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: tambah,
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "The Spider Plant is a charming and easy-to-care-for houseplant.",
                        style: TextStyle(color: Colors.grey, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// CARE REQUIREMENTS
            buildCard(
              title: "Care Requirements",
              child: Row(
                children: const [
                  Expanded(
                    child: CareItem(
                      icon: Icons.water_drop,
                      title: "Water",
                      value: "Once a week",
                    ),
                  ),
                  Expanded(
                    child: CareItem(
                      icon: Icons.eco,
                      title: "Fertilize",
                      value: "Once a week",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// FEATURES
            buildCard(
              title: "Key Features",
              child: const Text(
                "• Hardy and low-maintenance, perfect for beginners\n"
                "• Excellent air purifier, improving indoor air quality\n"
                "• Adaptable to a variety of indoor conditions, including moderate light and humidity\n",
                style: TextStyle(color: Colors.grey, height: 1.6),
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),

      /// BUY BUTTON
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Checkout(price: totalPrice),
            ),
          );
        },
        child: Container(
          width: 320,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              "Buy Now - Rp$totalPrice",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// CARD WIDGET
Widget buildCard({required String title, required Widget child}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD6EAD9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F4D3F),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    ),
  );
}

class CareItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const CareItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFFE8F5E9),
          child: Icon(icon, color: Colors.green),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
