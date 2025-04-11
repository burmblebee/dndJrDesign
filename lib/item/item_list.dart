import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/rpg_awesome_icons.dart';

import '../widgets/navigation/main_drawer.dart';
import 'add_item.dart';
import 'filter_provider.dart';
import 'fixed_item.dart';
import 'item sub-widgets/armor_details.dart';
import 'item sub-widgets/misc_details.dart';
import 'item sub-widgets/weapon_details.dart';
import 'item sub-widgets/wondrous_details.dart';
import 'item_provider.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';

/*
Armor: shield
Weapon: rpg awesome icon
Wondrous: wand_sparkles
Misc: gifts ?
 */

class itemListScreen extends ConsumerWidget {
  itemListScreen({super.key});
  final List<bool> filters = [true, true, true, true];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(itemProvider.notifier).fetchItems();
    final itemState = ref.watch(itemProvider);
    final filters = ref.watch(filterProvider);
    final filteredItems = itemState.items.where((item) {
      if (item.itemType == ItemType.Armor && filters[0]) return true;
      if (item.itemType == ItemType.Weapon && filters[1]) return true;
      if (item.itemType == ItemType.Wondrous && filters[2]) return true;
      if (item.itemType == ItemType.Miscellaneous && filters[3]) return true;
      return false;
    }).toList();


    return Scaffold(
      appBar: AppBar(title: const Text('Item List')),
      bottomNavigationBar: MainBottomNavBar(),
      drawer: MainDrawer(),
      endDrawer: filterDrawer(ref),
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
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  var item = filteredItems[index];
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      ListTile(
                        tileColor: const Color(0xFFD4C097).withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        visualDensity: const VisualDensity(vertical: 4),
                        leading: correctIcon(item),
                        title: Text(item.name,
                            style: const TextStyle(fontSize: 20)),
                        onTap: () {
                          ref.read(itemProvider.notifier).resetSelectedItem();
                          ref.read(itemProvider.notifier).selectItem(item);

                          if (item.itemType == ItemType.Weapon) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeaponDetailsScreen(
                                  weapon: item as CombatItem,
                                ),
                              ),
                            );
                          } else if (item.itemType == ItemType.Armor) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArmorDetailsScreen(
                                  armor: item as ArmorItem,
                                ),
                              ),
                            );
                          } else if (item.itemType == ItemType.Wondrous) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WondrousDetailsScreen(
                                  item: item as WondrousItem,
                                ),
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
            ),
    );
  }

  Widget correctIcon(Item item) {
    if (item.itemType == ItemType.Weapon) {
      return Icon(RpgAwesomeIcons.crossedSwords);
    }
    if (item.itemType == ItemType.Armor) {
      return const Icon(Icons.shield);
    }
    if (item.itemType == ItemType.Wondrous) {
      return const FaIcon(FontAwesomeIcons.wandSparkles);
    }
    return const FaIcon(FontAwesomeIcons.gifts);
  }

  filterDrawer(WidgetRef ref) {
    final filters = ref.watch(filterProvider);
    final filterNotifier = ref.read(filterProvider.notifier);
    return Drawer(
      backgroundColor: const Color(0xFF25291C),
      child: Column(
        children: [
          AppBar(
            backgroundColor: const Color(0xFF25291C),
            title: const Text('Filter Items'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Armor',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const Spacer(),
                    Switch(
                        value: filters[0],
                        onChanged: (bool newValue) {
                          filterNotifier.toggle(0);
                        }),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Weapons',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const Spacer(),
                    Switch(
                        value: filters[1],
                        onChanged: (bool newValue) {
                          filterNotifier.toggle(1);
                        }),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Wondrous',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const Spacer(),
                    Switch(
                        value: filters[2],
                        onChanged: (bool newValue) {
                          filterNotifier.toggle(2);
                        }),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Miscellaneous',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const Spacer(),
                    Switch(
                        value: filters[3],
                        onChanged: (bool newValue) {
                          filterNotifier.toggle(3);
                        }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
