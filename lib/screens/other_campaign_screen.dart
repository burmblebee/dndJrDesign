import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/screens/Compendium/monster_compendium.dart';
import 'package:warlocks_of_the_beach/screens/Compendium/spell_compendium.dart';
import 'package:warlocks_of_the_beach/screens/campaign_screen.dart';
import 'package:warlocks_of_the_beach/screens/character_sheet/character_sheet.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/combat_nav_bar.dart';

class OtherCampaignScreen extends StatelessWidget {
  const OtherCampaignScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        bottomNavigationBar: CombatBottomNavBar(),
        appBar: AppBar(
          title: const Text('Campaign Overview'),
          bottom: const TabBar(
            isScrollable: false,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Character Sheet'),
              Tab(icon: Icon(Icons.book), text: 'Monsters'),
              Tab(icon: Icon(Icons.auto_stories), text: 'Spells'),
              Tab(icon: Icon(Icons.note), text: 'Notes'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CharacterSheet(characterID: "place holder for now",), // Character Sheet Tab
            MonsterCompendium(), // Monster Compendium Tab
            SpellCompendium(), // Spell Compendium Tab
            // Notes(), // Notes Tab
            SpellCompendium(), // Placeholder for Notes Tab
            
          ],
        ),
      ),
    );
  }
}