import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'npc_creator.dart';
import 'npc_details.dart';
import 'npc_provider.dart';

class NPCListScreen extends ConsumerWidget {
  const NPCListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(npcProvider.notifier).fetchNPCs();

    final npcState = ref.watch(npcProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('NPC List')),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF25291C),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          child: const Text('Bottom Navigation Bar', style: TextStyle(color: Colors.white)),
        ),
      ),
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
          return Column(
            children: [
              const SizedBox(height: 10),
              ListTile(
                tileColor: const Color(0xFFD4C097).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                visualDensity: const VisualDensity(vertical: 4),
                title: Text(npc.name, style: const TextStyle(fontSize: 20)),
                onTap: () {
                  ref.read(npcProvider.notifier).selectNPC(npc);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NPCDetailScreen(), // Pass no parameters, fetch from the provider
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          );

        },
      ),
    );
  }
}
