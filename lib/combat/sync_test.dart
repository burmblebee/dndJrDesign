// screen with 2 buttons, one leading to npc list and one leading to item list
import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/combat/create_combat.dart';
import 'package:warlocks_of_the_beach/combat/dm_combat_screen.dart';
import 'package:warlocks_of_the_beach/combat/player_combat_screen.dart';


class SyncTest extends StatelessWidget {
  final String campaignId;


  const SyncTest({super.key, required this.campaignId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Selection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DMCombatScreen(campaignId: '20'),
                ));
              },
              child: const Text('DM'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>  PlayerCombatScreen(campaignId: '20'),
                ));
              },
              child: const Text('Player'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>  AddCombat(campaignId: '20'),
                ));
              },
              child: const Text('Add Combat'),
            ),
          ],
        ),
      ),
    );
  }

}