import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'npc.dart';
import 'npc_provider.dart';

class AddNPCScreen extends ConsumerWidget {
  final TextEditingController nameController = TextEditingController();
  List<String> diceLabels = ['d4', 'd6', 'd8', 'd10', 'd12', 'd20', 'd100'];

  AddNPCScreen({super.key});

  String getDiceString(List<int> diceConfig) {
    List<String> diceParts = [];
    for (int i = 0; i < diceConfig.length; i++) {
      if (diceConfig[i] > 0) {
        diceParts.add('${diceConfig[i]}${diceLabels[i]}');
      }
    }
    return diceParts.isNotEmpty ? diceParts.join(' + ') : 'No dice set';
  }

  final TextEditingController armorClassController = TextEditingController();
  final TextEditingController healthController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final npcNotifier = ref.read(npcProvider.notifier);
    final npcState = ref.watch(npcProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add NPC')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'NPC Name'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Max Health: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: TextField(
                    controller: healthController,
                    decoration: const InputDecoration(labelText: 'Health'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 5),
              ),
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 100,
                width: 100,
                child: TextField(
                  textAlign: TextAlign.center,
                  scrollPadding: const EdgeInsets.all(10),
                  controller: armorClassController,
                  decoration: const InputDecoration(
                      labelText: 'AC',
                      labelStyle: TextStyle(
                        fontSize: 24,
                      )),
                  keyboardType: TextInputType.number,
                  expands: false,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: npcState.attackOptions.length,
                itemBuilder: (context, index) {
                  final attack = npcState.attackOptions[index];
                  return ListTile(
                    title: Text(attack.name),
                    subtitle: Text(getDiceString(attack.diceConfig)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        npcNotifier.removeAttackOption(index);
                      },
                    ),
                    onTap: () => _editAttack(context, npcNotifier, attack, index),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _addAttack(context, npcNotifier),
              child: const Text('Add Attack Option'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final newDocRef = FirebaseFirestore.instance.collection('npcs').doc();
                  final npcNotifier = ref.read(npcProvider.notifier);
                  final attackOptions = npcNotifier.state.attackOptions; // Get attack options from the provider

                  final newNPC = NPC(
                    id: newDocRef.id, // Use the Firestore document ID
                    name: nameController.text,
                    attacks: attackOptions,
                    maxHealth: int.tryParse(healthController.text) ?? -1,
                    ac: int.tryParse(armorClassController.text) ?? 10,
                  );

                  await npcNotifier.addNPC(newNPC, newDocRef.id);
                  // Clear the fields after saving
                  nameController.clear();
                  healthController.clear();
                  armorClassController.clear();
                  npcNotifier.clearAttackOptions();
                  Navigator.pop(context);
                }
              },

              child: const Text('Save NPC'),
            ),
          ],
        ),
      ),
    );
  }

  void _addAttack(BuildContext context, NPCProvider npcNotifier) {
    final attackNameController = TextEditingController();
    List<int> diceConfig = List.filled(7, 0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Attack Option'),
        content: _attackForm(attackNameController, diceConfig),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (attackNameController.text.isNotEmpty) {
                npcNotifier.addAttackOption(
                  AttackOption(name: attackNameController.text, diceConfig: diceConfig),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editAttack(BuildContext context, NPCProvider npcNotifier, AttackOption attack, int index) {
    final attackNameController = TextEditingController(text: attack.name);
    List<int> diceConfig = List.from(attack.diceConfig);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Attack Option'),
        content: _attackForm(attackNameController, diceConfig),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (attackNameController.text.isNotEmpty) {
                npcNotifier.updateAttackOption(
                  index,
                  AttackOption(name: attackNameController.text, diceConfig: diceConfig),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _attackForm(TextEditingController nameController, List<int> diceConfig) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Attack Name'),
          ),
          const SizedBox(height: 20),
          const Text('Dice Configuration (e.g., 1d4, 2d6)'),
          Column(
            children: List.generate(7, (index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(diceLabels[index]),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      initialValue: diceConfig[index].toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        diceConfig[index] = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
