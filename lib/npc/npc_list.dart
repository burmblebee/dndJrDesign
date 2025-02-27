import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'npc_creator.dart';
import 'npc_details.dart';
import 'npc_provider.dart';

class NPCListScreen extends ConsumerWidget {
  const NPCListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch NPCs automatically when the screen is built
    ref.read(npcProvider.notifier).fetchNPCs();

    final npcState = ref.watch(npcProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('NPC List')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNPCScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: npcState.npcs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(

        itemCount: npcState.npcs.length,
        itemBuilder: (context, index) {
          final npc = npcState.npcs[index];
          return ListTile(
            selectedColor: Theme.of(context).canvasColor,
            title: Text(npc.name),
            onTap: () {
              ref.read(npcProvider.notifier).selectNPC(npc); // Select the NPC
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NPCDetailScreen(), // Pass no parameters, fetch from the provider
                ),
              );
            },
          );

        },
      ),
    );
  }
}
