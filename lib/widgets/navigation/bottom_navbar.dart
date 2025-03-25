import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/screens/browse_content/browse_content';
import 'package:warlocks_of_the_beach/screens/campaign_screen.dart';
import '../../diceRoller.dart'; // Import the DiceRollScreen 

class MainBottomNavBar extends StatefulWidget {
  const MainBottomNavBar({super.key});

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to Browse Content
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BrowseContent()),
        );
        break;
      case 1:
        // Navigate to Dice Roller
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DiceRollScreen()),
        );
        break;
      case 2:
        // Navigate to Your Content
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => YourContentScreen()),
        // );
        break;
      case 3:
        // Navigate to Campaigns
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CampaignScreen()),
        );
        break;
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