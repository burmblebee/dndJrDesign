import 'package:dnd_jr_design/item/add_item.dart';
import 'package:dnd_jr_design/item/item_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class itemListScreen extends ConsumerWidget {
  const itemListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(itemProvider.notifier).fetchItems();

    final itemState = ref.watch(itemProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Item List')),
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
              builder: (context) => AddItem(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: itemState.items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(

        itemCount: itemState.items.length,
        itemBuilder: (context, index) {
          final item = itemState.items[index];
          return Column(
            children: [
              const SizedBox(height: 10),
              ListTile(
                tileColor: const Color(0xFFD4C097).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                visualDensity: const VisualDensity(vertical: 4),
                title: Text(item.name, style: const TextStyle(fontSize: 20)),
                onTap: () {
                  //ref.read(itemProvider.notifier).selectItem(item);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const NPCDetailScreen(), // Pass no parameters, fetch from the provider
                  //   ),
                //  );
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
