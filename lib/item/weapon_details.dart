import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fixed_item.dart';
import 'item_provider.dart';

class WeaponDetailsScreen extends ConsumerWidget {
  const WeaponDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemProvider);
    final weapon = itemState.selectedItem as CombatItem?;

    if (weapon == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Weapon Details')),
        body: const Center(child: Text('Weapon not found!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(weapon.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ref.read(itemProvider.notifier).deleteItem(weapon.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          ref.read(itemProvider.notifier).updateItem(weapon);
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
              Text('Name: ${weapon.name}',
                  style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 10),
              Text('Description:',
                  style: Theme.of(context).textTheme.titleMedium),
              Text(weapon.description),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Category: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(weapon.weaponCategory.name),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Price: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${weapon.price} ${weapon.currency.name}'),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Weight: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${weapon.weight} lbs'),
                ],
              ),
              const Divider(height: 20),
              if (weapon.requiresAttunement)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Requires Attunement',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    if (weapon.attunementDescription?.isNotEmpty ?? false)
                      Text(weapon.attunementDescription!),
                    const SizedBox(height: 20),
                  ],
                ),
              Text('Damage:', style: Theme.of(context).textTheme.titleMedium),
              Text(
                  '${weapon.damage1} (${weapon.damageType1?.name ?? 'Unknown'})'),
              if (weapon.damage2 != null && weapon.damage2!.isNotEmpty)
                Text(
                    '${weapon.damage2} (${weapon.damageType2?.name ?? 'Unknown'})'),
              const Divider(height: 20),
              Text('Weapon Types:',
                  style: Theme.of(context).textTheme.titleMedium),
              Wrap(
                spacing: 8.0,
                children: (weapon.weaponTypes?.isNotEmpty ?? false)
                    ? weapon.weaponTypes!.map((type) {
                        // Safely check if 'type' is non-null before accessing its properties
                        if (type != null) {
                          return Chip(label: Text(type.name));
                        } else {
                          return const Chip(label: Text('Unknown'));
                        }
                      }).toList()
                    : [const Chip(label: Text('None'))],
              )
            ],
          ),
        ),
      ),
    );
  }
}
