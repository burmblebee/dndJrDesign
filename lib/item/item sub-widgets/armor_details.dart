import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../fixed_item.dart';
import '../item_provider.dart';

class ArmorDetailsScreen extends ConsumerWidget {
  const ArmorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemProvider);
    final armor = itemState.selectedItem as ArmorItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(armor.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(itemProvider.notifier).deleteItem(armor.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          ref.read(itemProvider.notifier).updateItem(armor);
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
              Text('Name: ${armor.name}', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 10),
              Text('Description:',
                  style: Theme.of(context).textTheme.titleMedium),
              Text(armor.description),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Type: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(armor.armorType.name),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Base Armor: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    armor.baseArmor != null
                        ? armor.baseArmor.toString().split('.').last
                        : 'None', // Handle null case if baseArmor is not set
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Price: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${armor.price} ${armor.currency.name}'),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Weight: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${armor.weight} lbs'),
                ],
              ),
              const Divider(height: 20),
              if (armor.requiresAttunement)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Requires Attunement',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    if (armor.attunementDescription?.isNotEmpty ?? false)
                      Text(armor.attunementDescription!),
                    const SizedBox(height: 20),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Text(
                    'Armor Class:',
                    style: TextStyle(fontSize: 24),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 5),
                    ),
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: Column(
                        children: [

                          const SizedBox(height: 10),
                          Text(
                            '${armor.armorClass}',
                            style: const TextStyle(fontSize: 40),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
