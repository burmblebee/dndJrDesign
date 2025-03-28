import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../fixed_item.dart';
import '../item_provider.dart';

class MiscDetailsScreen extends ConsumerWidget {
  const MiscDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemProvider);
    final item = itemState.selectedItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(item!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(itemProvider.notifier).deleteItem(item.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          ref.read(itemProvider.notifier).updateItem(item);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item details saved!')),
          );
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${item.name}', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 10),
              const Text('Description:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(item.description, style: const TextStyle(fontSize: 20)),
              Row(
                children: [
                  const Text(
                    'Rarity: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(item.rarity.name, style: const TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Price: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text('${item.price} ${item.currency.name}',
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Weight: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text('${item.weight} lbs',
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),
              if (item.requiresAttunement)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Requires Attunement',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    if (item.attunementDescription?.isNotEmpty ?? false)
                      Text(item.attunementDescription!,
                          style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
