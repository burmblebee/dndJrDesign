import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/content_selection.dart';
import 'package:warlocks_of_the_beach/screens/campaign_screen.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/character_name.dart';
import '../../diceRoller.dart'; // DiceRollScreen import

class MainBottomNavBar extends StatefulWidget {
  final int initialIndex;

  const MainBottomNavBar({super.key, this.initialIndex = 0});

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
          MaterialPageRoute(
            builder: (context) => const CharacterName(),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  DiceRollScreen(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ContentSelection(),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CampaignScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).bottomNavigationBarTheme;

    return BottomNavigationBar(
      backgroundColor: theme.backgroundColor,
      selectedItemColor: theme.selectedItemColor,
      unselectedItemColor: theme.unselectedItemColor,
      currentIndex: _selectedIndex,
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





// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:warlocks_of_the_beach/content_selection.dart';
// import 'package:warlocks_of_the_beach/screens/browse_content/browse_content.dart';

// import 'package:warlocks_of_the_beach/screens/campaign_screen.dart';
// import 'package:warlocks_of_the_beach/screens/dnd_forms/character_name.dart';
// import '../../diceRoller.dart'; // Import the DiceRollScreen

// class MainBottomNavBar extends StatefulWidget {
//   final int initialIndex;

//   const MainBottomNavBar({super.key, this.initialIndex = 0});

//   @override
//   State<MainBottomNavBar> createState() => _MainBottomNavBarState();
// }

// class _MainBottomNavBarState extends State<MainBottomNavBar> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     switch (index) {
//       case 0:
//         // Navigate to Browse Content
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => CharacterName()),
//         );
//         break;
//       case 1:
//         // Navigate to Dice Roller
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => DiceRollScreen()),
//         );
//         break;
//       case 2:
//         // Navigate to Your Content
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => ContentSelection()),
//         );
//         break;
//       case 3:
//         // Navigate to Campaigns
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => CampaignScreen()),
//         );
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context).bottomNavigationBarTheme;

//     return BottomNavigationBar(
//       backgroundColor: theme.backgroundColor, // Uses theme color
//       selectedItemColor: theme.selectedItemColor, // Theme-selected color
//       unselectedItemColor: theme.unselectedItemColor, // Theme-unselected color
//       currentIndex: _selectedIndex,
//       onTap: _onItemTapped,
//       type: BottomNavigationBarType.fixed, // Ensures background stays consistent
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person_add),
//           label: '   Create\nCharacter',
//         ),
//         BottomNavigationBarItem(
//           icon: FaIcon(FontAwesomeIcons.diceD20),
//           label: 'Dice Roller',
//         ),
//         BottomNavigationBarItem(
//           icon: FaIcon(FontAwesomeIcons.book),
//           label: 'Your Content',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: 'Campaigns',
//         ),
//       ],
//     );
//   }
// }