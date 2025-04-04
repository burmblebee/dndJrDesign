
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_item.dart';
import 'fixed_item.dart';
import 'item sub-widgets/armor_details.dart';
import 'item sub-widgets/misc_details.dart';
import 'item sub-widgets/weapon_details.dart';
import 'item sub-widgets/wondrous_details.dart';
import 'item_provider.dart';

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
          child: const Text('Bottom Navigation Bar',
              style: TextStyle(color: Colors.white)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(itemProvider.notifier).resetSelectedItem();
          ref.read(selectedItemTypeProvider.notifier).state = null;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddItem(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: itemState.items.isEmpty
          ? const Center(child: Text('No items available'))
          : ListView.builder(
              itemCount: itemState.items.length,
              itemBuilder: (context, index) {
                var item = itemState.items[index];
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    ListTile(
                      tileColor: const Color(0xFFD4C097).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      visualDensity: const VisualDensity(vertical: 4),
                      title:
                          Text(item.name, style: const TextStyle(fontSize: 20)),
                      onTap: () {
                        ref.read(itemProvider.notifier).resetSelectedItem();
                        ref.read(itemProvider.notifier).selectItem(item);

                        if (item.itemType == ItemType.Weapon) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeaponDetailsScreen(weapon: item as CombatItem,),
                            ),
                          );
                        } else if (item.itemType == ItemType.Armor) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArmorDetailsScreen(armor: item as ArmorItem,),
                            ),
                          );
                        } else if (item.itemType == ItemType.Wondrous) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                WondrousDetailsScreen(item: item as WondrousItem,),
                            ),
                          );
                        } else if (item.itemType == ItemType.Miscellaneous) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              MiscDetailsScreen(item: item),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Selected item is not available')),
                          );
                        }
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
