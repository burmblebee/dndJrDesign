import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'npc.dart';
import 'npc_provider.dart';

class NPCDetailScreen extends ConsumerWidget {
  const NPCDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final npcState = ref.watch(npcProvider);
    final npc = npcState.selectedNPC;

    if (npc == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('NPC Details')),
        body: const Center(child: Text('No NPC selected')),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          ref.read(npcProvider.notifier).updateNPC(npc);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('NPC details saved!')),
          );
          Navigator.pop(context);
        },
      ),
      appBar: AppBar(
        title: Text(npc.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(npcProvider.notifier).deleteNPC(npc.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 20),
                Text('Name: ${npc.name}', style: const TextStyle(fontSize: 24)),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      final nameController = TextEditingController(text: npc.name);
                      _editName(context, nameController, ref.read(npcProvider.notifier));
                    },
                    icon: const Icon(Icons.edit)),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Attack Options:', style: TextStyle(fontSize: 20)),
            Expanded(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: npc.attacks.length,
                    itemBuilder: (context, index) {
                      final attack = npc.attacks[index];
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          ListTile(
                            tileColor: const Color(0xFFD4C097).withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(attack.name),
                            subtitle: Text(getDiceString(attack.diceConfig)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _editAttack(context, ref.read(npcProvider.notifier), attack, index);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                                  onPressed: () {
                                    ref.read(npcProvider.notifier).removeAttackOption(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),

                  ListTile(
                    title: const Text('Add Attack Option'),
                    leading: const Icon(Icons.add),
                    tileColor: const Color(0xFF25291C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      _addAttack(context, ref.read(npcProvider.notifier));
                    },
                  ),
                ],
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
        title: const Text('Edit NPC Name'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'NPC Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                await npcNotifier.editNPCName(npcNotifier.state.selectedNPC!, nameController.text);
                npcNotifier.updateNPC(npcNotifier.state.selectedNPC!);
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
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
                npcNotifier.editAttackOption(npcNotifier.state.selectedNPC!.id, index, AttackOption(name: attackNameController.text, diceConfig: diceConfig));
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _addAttack(BuildContext context, NPCProvider npcNotifier) {
    final attackNameController = TextEditingController();
    List<int> diceConfig = List.filled(6, 0);

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
                npcNotifier.addAttackOption(AttackOption(
                  name: attackNameController.text,
                  diceConfig: diceConfig,
                ));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }


  Widget _attackForm(TextEditingController attackNameController, List<int> diceConfig) {
    List<String> diceNames = ['d4', 'd6', 'd8', 'd10', 'd12', 'd20'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: attackNameController,
          decoration: const InputDecoration(labelText: 'Attack Name'),
        ),
        const SizedBox(height: 10),
        const Text('Dice Configuration:', style: TextStyle(fontSize: 16)),
        ...List.generate(6, (index) {
          return Row(
            children: [
              Text('${diceNames[index]}: '),
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: diceConfig[index].toString()),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    diceConfig[index] = value.isNotEmpty ? int.parse(value) : 0;
                  },
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  String getDiceString(List<int> diceConfig) {
    List<String> diceNames = ['d4', 'd6', 'd8', 'd10', 'd12', 'd20'];
    List<String> diceStrings = [];
    for (int i = 0; i < diceConfig.length; i++) {
      if (diceConfig[i] > 0) {
        diceStrings.add('${diceConfig[i]} ${diceNames[i]}');
      }
    }
    return diceStrings.join(', ');
  }
}
