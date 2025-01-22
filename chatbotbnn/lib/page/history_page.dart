import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Section: Tên con chat
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('resources/logo_chatbox.jpg'),
                radius: 16,
              ),
              SizedBox(width: 6),
              Text(
                "SmartChat1",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              // CircleAvatar(
              //   backgroundImage: AssetImage('resources/logo_chatbox.jpg'),
              //   radius: 16,
              // ),
              // SizedBox(width: 6),
              // Text(
              //   "SmartChat2",
              //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              // ),
              // CircleAvatar(
              //   backgroundImage: AssetImage('resources/logo_chatbox.jpg'),
              //   radius: 16,
              // ),
              // SizedBox(width: 6),
              // Text(
              //   "SmartChat3",
              //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              // ),
            ],
          ),
          const SizedBox(height: 16),

          // Section: Thanh tìm kiếm theo ngày
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm theo ngày...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Search button logic
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text("Lọc"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Section: Danh sách lịch sử chat
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Example list size
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.chat_bubble, color: Colors.white),
                    ),
                    title: Text(
                      "Chat ngày ${index + 1}/01/2023",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text("Nội dung ngắn của đoạn chat..."),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to chat detail
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
