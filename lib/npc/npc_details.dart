import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'npc_provider.dart';

class NPCDetailScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final npcState = ref.watch(npcProvider);
    final npc = npcState.selectedNPC;

    if (npc == null) {
      return Scaffold(
        appBar: AppBar(title: Text('NPC Details')),
        body: Center(child: Text('No NPC selected')),
      );
    }

    return Scaffold(
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
                IconButton(onPressed: (
                    //option to edit name

                    ){}, icon: Icon(Icons.edit))
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
                        // option to edit attack
                      },
                    ),
                  );
                },
              ),
            ),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/npcEditor');
            //   },
            //   child: Text('Edit NPC'),
            // ),
          ],
        ),
      ),
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
