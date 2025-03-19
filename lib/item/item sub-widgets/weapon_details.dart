import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../fixed_item.dart';
import '../item_provider.dart';

class WeaponDetailsScreen extends ConsumerWidget {
  const WeaponDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemProvider);
    final weapon = itemState.selectedItem as CombatItem?;

    if (weapon == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Weapon Details')),
        body: const Center(
          child: Text(
            'Weapon not found!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
//tybiljkjhgcfrtfyuhijkngfcdxesrfyujikhgfdsfyujik
    return Scaffold(
      appBar: AppBar(
        title: Text(
          weapon.name,
        ),
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
              Text(
                'Name: ${weapon.name}',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 10),
              const Text(
                'Description:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                weapon.description,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Category: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    weapon.weaponCategory.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Price: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${weapon.price} ${weapon.currency.name}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Weight: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${weapon.weight} lbs',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (weapon.requiresAttunement)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Requires Attunement',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    if (weapon.attunementDescription?.isNotEmpty ?? false)
                      Text(
                        weapon.attunementDescription!,
                        style: const TextStyle(fontSize: 20),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              const Text(
                'Damage:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${weapon.damage1} (${weapon.damageType1.name})',
                style: const TextStyle(fontSize: 20),
              ),
              if (weapon.damage2 != null && weapon.damage2!.isNotEmpty)
                Text(
                  '${weapon.damage2} (${weapon.damageType2?.name})',
                  style: const TextStyle(fontSize: 20),
                ),
              const SizedBox(height: 20),
              const Text(
                'Weapon Types:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: (weapon.weaponTypes.isNotEmpty)
                    ? weapon.weaponTypes.map((type) {
                  if (type != null) {
                    return Chip(
                      label: Text(
                        type.name,
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    return const Chip(
                      label: Text(
                        'Unknown',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
                }).toList()
                    : [
                  const Chip(
                    label: Text(
                      'None',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
