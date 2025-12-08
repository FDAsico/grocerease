import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomMenu extends StatelessWidget {
  final currentPageIndex;
  ValueChanged<int> selectedDestination;
  BottomMenu(
      {super.key, required this.selectedDestination, this.currentPageIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: selectedDestination,
      surfaceTintColor: Colors.white,
      indicatorColor: Color(0xFF139A5A),
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.groups),
          icon: Icon(Icons.groups_outlined),
          label: 'List',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.storefront),
          icon: Icon(Icons.storefront_outlined),
          label: 'Favorites',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.person),
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
