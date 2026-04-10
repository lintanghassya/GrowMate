import 'package:flutter/material.dart';

class CareScreen extends StatefulWidget {
  const CareScreen({super.key});

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  bool isTodaySelected = true;

  // Data tanaman yang lebih variatif
  final List<Map<String, dynamic>> tasks = [
    {
      "name": "Monstera",
      "nickname": "Monty",
      "type": "Monstera Deliciosa",
      "water": "Every 7 days",
      "fert": "Every 5 days",
      "isDone": true,
      "tag": null,
      "image": "lib/assets/image14.png", // Tambahkan path gambar
    },
    {
      "name": "Snake Plant",
      "nickname": "Snaky",
      "type": "Sansevieria",
      "water": "Every 10 days",
      "fert": "Every 30 days",
      "isDone": false,
      "tag": "Water Today",
      "image": "lib/assets/image14.png",
    },
    {
      "name": "Spider Plant",
      "nickname": "Spidey",
      "type": "Chlorophytum",
      "water": "Every 5 days",
      "fert": "Every 14 days",
      "isDone": false,
      "tag": "Fertilize Today",
      "image": "lib/assets/image14.png",
    },
    {
      "name": "Aloe Vera",
      "nickname": "Aloe",
      "type": "Aloe Barbadensis",
      "water": "Every 14 days",
      "fert": "Every 60 days",
      "isDone": false,
      "tag": null,
      "image": "lib/assets/image14.png",
    },
  ];

  // Data history (riwayat perawatan yang sudah selesai)
  final List<Map<String, dynamic>> history = [
    {
      "name": "Monstera",
      "nickname": "Monty",
      "action": "Watered",
      "date": "Yesterday",
      "time": "08:30 AM",
      "image": "lib/assets/image14.png",
    },
    {
      "name": "Snake Plant",
      "nickname": "Snaky",
      "action": "Fertilized",
      "date": "2 days ago",
      "time": "10:15 AM",
      "image": "lib/assets/image14.png",
    },
    {
      "name": "Spider Plant",
      "nickname": "Spidey",
      "action": "Watered",
      "date": "3 days ago",
      "time": "09:00 AM",
      "image": "lib/assets/image14.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    int completedCount = tasks.where((t) => t['isDone'] == true).length;
    int dueTodayCount = tasks.where((t) => t['isDone'] == false).length;

    const Color primaryGreen = Color(0xFF4CAF50);
    const Color softGreenBg = Color(0xFFF1F8F1);

    return Scaffold(
      backgroundColor: softGreenBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER SECTION
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 60, left: 30),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Care Reminders",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Keep your plants happy and healthy",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                // STATS CARDS
                Positioned(
                  bottom: -40,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          dueTodayCount.toString(),
                          "Due Today",
                          Icons.access_time,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          completedCount.toString(),
                          "Completed",
                          Icons.check_circle_outline,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),

            // TAB SELECTOR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    _buildTabItem("Today", isTodaySelected, () {
                      setState(() => isTodaySelected = true);
                    }),
                    _buildTabItem("History", !isTodaySelected, () {
                      setState(() => isTodaySelected = false);
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CONTENT LIST
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: isTodaySelected
                  ? Column(
                      children: tasks.asMap().entries.map((entry) {
                        int idx = entry.key;
                        var task = entry.value;
                        return _buildCareItem(
                          task['nickname'],
                          task['name'],
                          task['type'],
                          task['water'],
                          task['fert'],
                          task['isDone'],
                          task['tag'],
                          task['image'],
                          onTap: () {
                            setState(() {
                              tasks[idx]['isDone'] = !tasks[idx]['isDone'];
                            });
                          },
                        );
                      }).toList(),
                    )
                  : _buildHistoryList(),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(String text, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow: isActive
                ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                : [],
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCareItem(
    String nickname,
    String name,
    String type,
    String water,
    String fert,
    bool isDone,
    String? tag,
    String imagePath, {
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black12.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // CHECKBOX BULAT
          GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(right: 12, left: 5),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: isDone ? Colors.green : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ),

          // GAMBAR TANAMAN - Menggunakan Image.asset
          Opacity(
            opacity: isDone ? 0.5 : 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.green[50],
                    child: const Icon(
                      Icons.local_florist,
                      size: 40,
                      color: Colors.green,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // INFO TEKS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        nickname,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDone ? Colors.grey : const Color(0xFF2D6A4F),
                          decoration: isDone ? TextDecoration.lineThrough : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (tag != null && !isDone)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (isDone)
                      const Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  type,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 6),
                if (isDone)
                  const Text(
                    "Completed Today ✓",
                    style: TextStyle(color: Colors.green, fontSize: 11),
                  )
                else
                  Row(
                    children: [
                      const Icon(Icons.water_drop_outlined,
                          size: 14, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        water,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.eco_outlined,
                          size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        fert,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    if (history.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          children: [
            Icon(Icons.history, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No history yet",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              "Complete your care tasks to see history",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: history.map((item) {
        return _buildHistoryItem(
          item['nickname'],
          item['name'],
          item['action'],
          item['date'],
          item['time'],
          item['image'],
        );
      }).toList(),
    );
  }

  Widget _buildHistoryItem(
    String nickname,
    String name,
    String action,
    String date,
    String time,
    String imagePath,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.green[50],
                  child: const Icon(
                    Icons.local_florist,
                    size: 40,
                    color: Colors.green,
                  ),
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
                  nickname,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D6A4F),
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      action == "Watered"
                          ? Icons.water_drop_outlined
                          : Icons.eco_outlined,
                      size: 14,
                      color: action == "Watered" ? Colors.blue : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$action • $date at $time",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}