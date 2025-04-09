import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/content_selection.dart';
import 'package:warlocks_of_the_beach/screens/campaign_screen.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/character_name.dart';
import '../../diceRoller.dart'; // DiceRollScreen import

class MainBottomNavBar extends StatefulWidget {
  final int initialIndex;

  const MainBottomNavBar({super.key, this.initialIndex = 4}); // 4 = no tab selected

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CharacterName()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DiceRollScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ContentSelection()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CampaignScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).bottomNavigationBarTheme;
    final bool noSelection = _selectedIndex >= 4;

    return BottomNavigationBar(
      backgroundColor: theme.backgroundColor,
      selectedItemColor: noSelection
          ? theme.unselectedItemColor // visually deselect all
          : theme.selectedItemColor,
      unselectedItemColor: theme.unselectedItemColor,
      currentIndex: noSelection ? 0 : _selectedIndex, // must stay within bounds
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_add),
          label: '   Create\nCharacter',
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
