import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).bottomNavigationBarTheme;

    return BottomNavigationBar(
      backgroundColor: theme.backgroundColor, // Uses theme color
      selectedItemColor: theme.selectedItemColor, // Theme-selected color
      unselectedItemColor: theme.unselectedItemColor, // Theme-unselected color
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed, // Ensures background stays consistent
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Browse\nContent',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.diceD20),
          label: 'Dice Roller',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.book),
          label: 'Your Content',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Campaigns',
        ),
      ],
    );
  }
}
