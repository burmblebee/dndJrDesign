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
              const Text('Description:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(armor.description, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Type: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(armor.armorType.name, style: const TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Base Armor: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    armor.baseArmor.toString().split('.').last,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'Price: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text('${armor.price} ${armor.currency.name}', style: const TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Weight: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text('${armor.weight} lbs', style: const TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height:20),
              if (armor.requiresAttunement)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Requires Attunement',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    if (armor.attunementDescription?.isNotEmpty ?? false)
                      Text(armor.attunementDescription!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Spacer(),
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
                          child: Row(
                            children: [
                              const Spacer(),
                              Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    '${armor.armorClass}',
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            showACDetails(context, armor);
                          },
                          child: const Text('Details'))
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text(
                    'Stealth Disadvantage: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(armor.stealthDisadvantage ? 'Yes' : 'No', style: const TextStyle(fontSize: 20)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  showACDetails(context, ArmorItem armor) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("AC Details"),
            content: Consumer(
              builder: (context, ref, _) {
                int acState = armor.armorClass;
                ArmorType armorType = armor.armorType;

                return Column(mainAxisSize: MainAxisSize.min, children: [
                  if (armorType == ArmorType.Light)
                    Row(
                      children: [
                        const Text("Light Armor: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('$acState + Dex Modifier'),
                      ],
                    ),
                  if (armorType == ArmorType.Medium)
                    Row(
                      children: [
                        const Text("Medium Armor: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('$acState + Dex Modifier (max 2)'),
                      ],
                    ),
                  if (armorType == ArmorType.Heavy)
                    Row(
                      children: [
                        const Text("Heavy Armor: ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('$acState'),
                      ],
                    ),
                ]);
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        });
  }
}
