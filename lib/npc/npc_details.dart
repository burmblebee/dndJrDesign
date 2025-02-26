import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'npc.dart';
import 'npc_provider.dart';

class NPCDetailScreen extends ConsumerWidget {
  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final npcState = ref.watch(npcProvider);
    final npc = npcState.selectedNPC;

    // Handle the case where no NPC is selected
    if (npc == null) {
      return Scaffold(
        appBar: AppBar(title: Text('NPC Details')),
        body: Center(child: Text('No NPC selected')),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          // Implement save functionality
          ref.read(npcProvider.notifier).updateNPC(npc);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('NPC details saved!')),
          );
          Navigator.pop(context);
        },
      ),
      appBar: AppBar(
        title: Text(npc.name),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              ref.read(npcProvider.notifier).deleteNPC(npc.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 20),
                Text('Name: ${npc.name}', style: TextStyle(fontSize: 24)),
                Spacer(),
                IconButton(
                    onPressed: () {
                      final nameController = TextEditingController(text: npc.name);
                      _editName(context, nameController, ref.read(npcProvider.notifier));
                    },
                    icon: Icon(Icons.edit)),
              ],
            ),
            SizedBox(height: 20),
            Text('Attack Options:', style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: npc.attacks.length,
                itemBuilder: (context, index) {
                  final attack = npc.attacks[index];
                  return ListTile(
                    title: Text(attack.name),
                    subtitle: Text(getDiceString(attack.diceConfig)),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _editAttack(context, ref.read(npcProvider.notifier),
                            attack, index);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editName(BuildContext context, TextEditingController nameController, NPCProvider npcNotifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit NPC Name'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'NPC Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await npcNotifier.editNPCName(npcNotifier.state.selectedNPC!, nameController.text);
                npcNotifier.updateNPC(npcNotifier.state.selectedNPC!);
                Navigator.pop(context); // Close the dialog after updating
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }



  void _editAttack(BuildContext context, NPCProvider npcNotifier,
      AttackOption attack, int index) {
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
                  AttackOption(
                      name: attackNameController.text, diceConfig: diceConfig),
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

  Widget _attackForm(
      TextEditingController attackNameController, List<int> diceConfig) {
    List<String> diceNames = ['d4', 'd6', 'd8', 'd10', 'd12', 'd20'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: attackNameController,
          decoration: InputDecoration(labelText: 'Attack Name'),
        ),
        SizedBox(height: 10),
        Text('Dice Configuration:', style: TextStyle(fontSize: 16)),
        ...List.generate(6, (index) {
          return Row(
            children: [
              Text('${diceNames[index]}: '),
              Expanded(
                  child: TextField(
                controller:
                    TextEditingController(text: diceConfig[index].toString()),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    diceConfig[index] = int.parse(value);
                  } else {
                    diceConfig[index] = 0;
                  }
                },
              )),
            ],
          );
        }),
      ],
    );
  }

  String getDiceString(List<int> diceConfig) {
    List<String> diceNames = ['d4', 'd6', 'd8', 'd10', 'd12', 'd20'];
    List<String> dice = [];
    for (int i = 0; i < diceConfig.length; i++) {
      if (diceConfig[i] > 0) {
        dice.add('${diceConfig[i]}${diceNames[i]}');
      }
    }
    return dice.isNotEmpty ? dice.join(' + ') : 'No dice configured';
  }
}
