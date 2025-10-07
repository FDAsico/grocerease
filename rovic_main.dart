import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NotificationScreen(),
  ));
}

class NotificationScreen extends StatelessWidget {
  final List<Map<String, String>> newNotifications = [
    {"title": "Mother", "message": "Added a new Item in your Grocery List."},
    {"title": "Mother", "message": "Added a new Item in your Grocery List."},
  ];

  final List<Map<String, String>> todayNotifications = [
    {"title": "Dairy Shop", "message": "Milk has restock"},
    {"title": "Dairy Shop", "message": "Cheese has restock"},
    {"title": "John Doe", "message": "Commented on your post"},
    {"title": "Reminder", "message": "Scheduled Grocery at 2pm"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD1FBF3), 
      appBar: AppBar(
        backgroundColor: Color(0xFFD1FBF3),
        elevation: 0,
        centerTitle: true,
        title: Text(
      "Notifications",
      style: TextStyle(
        color: Color.fromARGB(255, 82, 152, 140),
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),
        leading: Icon(Icons.arrow_back, color: Colors.black),
        actions: [
          Icon(Icons.more_horiz, color: Colors.black),
          SizedBox(width: 10, height: 24),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            _buildSectionTitle("New"),
            ...newNotifications.map((n) => _buildNotificationCard(n)),
            SizedBox(height: 20),
            _buildSectionTitle("Today"),
            ...todayNotifications.map((n) => _buildNotificationCard(n)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Community"),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/barcode_scanner.png', 
                width: 35,
                height: 35,
              ),
              label: "",
            ),
          BottomNavigationBarItem(
              icon: Icon(Icons.storefront), label: "Marketplace"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, String> notification) {
    Color titleColor = Colors.teal.shade700;
    if (notification["title"] == "Reminder") {
      titleColor = Colors.orange.shade700;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification['title'] ?? '',
            style: TextStyle(
              color: titleColor, 
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 2),
          Text(
            notification['message'] ?? '',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}