import 'package:flutter/material.dart';
import 'package:grocerease/screens/bottomnavbar.dart';
import 'package:grocerease/screens/homepage.dart';
import 'package:grocerease/screens/list.dart';
import 'package:grocerease/screens/notification.dart';
import 'package:grocerease/screens/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ListPage(),
    const Placeholder(),
    const ProfilePage(),
  ];

  void selectedDestination(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 170,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Row(
            children: const [
              Text(
                'Grocer',
                style: TextStyle(
                  color: Color(0xFF139A5A),
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                'Ease',
                style: TextStyle(
                  color: Color(0xFFFA8801),
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: IconButton(
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ));
              },
              icon: const Icon(Icons.notifications),
            ),
          ),
        ],
      ),
      body: _pages[currentPageIndex],
      bottomNavigationBar: BottomMenu(
        selectedDestination: selectedDestination,
        currentPageIndex: currentPageIndex,
      ),
    );
  }
}
