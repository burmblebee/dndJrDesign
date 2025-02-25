import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

import 'npc.dart';
import 'npc_provider.dart';

class AddNPCScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add NPC')),
      body: Column(
        children: [
          TextField(controller: nameController, decoration: InputDecoration(labelText: 'NPC Name')),

          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Provider.of<NPCProvider>(context, listen: false).addNPC(
                  NPC(name: nameController.text, attacks: [
                    AttackOption(name: 'Slash', diceConfig: [0, 1, 0, 0, 0, 0, 0]),  // 1d4
                    AttackOption(name: 'Bite', diceConfig: [0, 0, 1, 0, 0, 0, 0]),   // 1d6
                    AttackOption(name: 'Arrow Shot', diceConfig: [0, 0, 0, 1, 0, 0, 0]), // 1d8
                  ]),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Save NPC'),
          ),
        ],
      ),
    );
  }
}
