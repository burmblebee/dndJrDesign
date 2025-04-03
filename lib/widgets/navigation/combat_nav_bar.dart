import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/combat/dm_combat_screen.dart';
import 'package:warlocks_of_the_beach/item/bag_of_holding.dart';
import 'package:warlocks_of_the_beach/screens/campaign_screen.dart';

import '../../combat/player_combat_screen.dart';

class CombatBottomNavBar extends StatefulWidget {
  CombatBottomNavBar({super.key, required this.campaignId, required this.isDM});
  String campaignId;
  bool isDM;

  @override
  State<CombatBottomNavBar> createState() => _CombatBottomNavBarState();
}

class _CombatBottomNavBarState extends State<CombatBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    Widget screen;
    _selectedIndex = index;

    if (index == 0) {
      screen = widget.isDM
          ? DMCombatScreen(campaignId: widget.campaignId)
          : PlayerCombatScreen(campaignId: widget.campaignId);
    } else if (index == 1) {
      screen = BagOfHolding(campaignId: widget.campaignId, isDM: widget.isDM);
    } else {
      return;
    }
    debugPrint('Selected index: $_selectedIndex');
    debugPrint('index: $index');

    // Replace the current screen instead of stacking new ones
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
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
