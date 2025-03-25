import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/screens/browse_content/browse_content';
import 'package:warlocks_of_the_beach/screens/campaign_screen.dart';

class CombatBottomNavBar extends StatefulWidget {
  const CombatBottomNavBar({super.key});

  @override
  State<CombatBottomNavBar> createState() => _CombatBottomNavBarState();
}

class _CombatBottomNavBarState extends State<CombatBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to Combat
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BrowseContent()),
        );
        break;
      case 1:
        // Navigate to Other

        break;
      // case 2:
      //   // Navigate to Dice Roller
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => DiceRollScreen()),
      //   );
        // );
        // break;
    }
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
      type:
          BottomNavigationBarType.fixed, // Ensures background stays consistent
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.childCombatant),
          label: 'Combat',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.bookOpen),
          label: 'Other',
        ),
        // BottomNavigationBarItem(
        //   icon: FaIcon(FontAwesomeIcons.bookOpen),
        //   label: 'Dice Roller',
        // ),
      ],
    );
  }
}
