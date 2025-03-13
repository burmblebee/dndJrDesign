import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/rpg_awesome_icons.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/spell_selection_screen.dart';
import 'package:warlocks_of_the_beach/widgets/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import '../../data/character creator data/weapon_data.dart';
import 'package:warlocks_of_the_beach/providers/character_provider.dart';

class EquipmentSelection extends ConsumerStatefulWidget {
  const EquipmentSelection({Key? key}) : super(key: key);

  @override
  _EquipmentSelectionState createState() => _EquipmentSelectionState();
}

class _EquipmentSelectionState extends ConsumerState<EquipmentSelection> {
  final List<String> simpleWeapons = [
    'Club',
    'Dagger',
    'Greatclub',
    'Handaxe',
    'Javelin',
    'Light Hammer',
    'Mace',
    'Quarterstaff',
    'Sickle',
    'Spear',
    'Light Crossbow',
    'Dart',
    'Shortbow',
    'Sling',
    'Blowgun',
  ];

  final List<String> martialWeapons = [
    'Battleaxe',
    'Flail',
    'Glaive',
    'Greataxe',
    'Greatsword',
    'Halberd',
    'Lance',
    'Longsword',
    'Maul',
    'Morningstar',
    'Pike',
    'Rapier',
    'Scimitar',
    'Shortsword',
    'Trident',
    'War Pick',
    'Warhammer',
    'Whip',
    'Hand Crossbow',
    'Heavy Crossbow',
    'Longbow',
    'Net',
  ];

  late final List<String> allWeapons = (() {
    final weapons = {...simpleWeapons, ...martialWeapons}.toList();
    weapons.sort();
    return weapons;
  })();

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  List<String> selectedWeapons = [];

  
  

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _getWeaponIcon(String weapon) {
    final lower = weapon.toLowerCase();
    if (lower.contains('sword') ||
        lower.contains('rapier') ||
        lower.contains('scimitar') ||
        lower.contains('shortsword') ||
        lower.contains('longsword') ||
        lower.contains('greatsword')) {
      return RpgAwesomeIcons.crossedSwords;
    } else if (lower.contains('axe')) {
      return RpgAwesomeIcons.batteredAxe;
    } else if (lower.contains('bow') || lower.contains('crossbow')) {
      return RpgAwesomeIcons.arrowCluster;
    } else if (lower.contains('dagger')) {
      return RpgAwesomeIcons.knife;
    } else if (lower.contains('club') ||
        lower.contains('mace') ||
        lower.contains('hammer') ||
        lower.contains('flail')) {
      return FontAwesomeIcons.hammer;
    } else if (lower.contains('spear') || lower.contains('javelin')) {
      return FontAwesomeIcons.solidCircle; // placeholder
    }
    return FontAwesomeIcons.crosshairs; // fallback
  }

  @override
  Widget build(BuildContext context) {
    final elevatedButtonColor = Theme.of(context)
            .elevatedButtonTheme
            .style
            ?.backgroundColor
            ?.resolve({}) ??
        Colors.grey;

    final List<String> filteredWeapons = allWeapons.where((weapon) {
      return weapon.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar.
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Weapons',
                  prefixIcon: Icon(Icons.search, size: 20, color: Theme.of(context).iconTheme.color,),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // List of selected weapons and available weapons.
            Expanded(
              child: ListView(
                children: [
                  // Selected weapons section.
                  const Text(
                    'Selected Weapons',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  selectedWeapons.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: selectedWeapons.length,
                          itemBuilder: (context, index) {
                            final weapon = selectedWeapons[index];
                            final String group = simpleWeapons.contains(weapon)
                                ? "SimpleWeapons"
                                : "MartialWeapons";
                            final details =
                                WeaponData.Weapons[group]?[weapon] ?? {
                              "damage_die": "N/A",
                              "gold_cost": "N/A",
                              "damage_type": "N/A",
                              "properties": ["N/A"],
                              "weight": "N/A",
                            };

                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: FaIcon(
                                  _getWeaponIcon(weapon),
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                title: Text(
                                  weapon,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Cost: ${details["gold_cost"]} | Damage: ${details["damage_die"]} (${details["damage_type"]}) | ${group == "SimpleWeapons" ? "Simple" : "Martial"}',
                                ),
                                trailing: IconButton(
                                  icon:  Icon(Icons.remove_circle, color: Theme.of(context).iconTheme.color),
                                  onPressed: () {
                                    setState(() {
                                      selectedWeapons.remove(weapon);
                                      allWeapons.add(weapon);
                                      allWeapons.sort();
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text('No weapons selected.'),
                        ),
                  const SizedBox(height: 10),
                  // Available weapons section.
                  const Text(
                    'Available Weapons',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  filteredWeapons.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredWeapons.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final weapon = filteredWeapons[index];
                            final String group = simpleWeapons.contains(weapon)
                                ? "SimpleWeapons"
                                : "MartialWeapons";
                            final details =
                                WeaponData.Weapons[group]?[weapon] ?? {
                              "damage_die": "N/A",
                              "gold_cost": "N/A",
                              "damage_type": "N/A",
                              "properties": ["N/A"],
                              "weight": "N/A",
                            };

                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: FaIcon(
                                  _getWeaponIcon(weapon),
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                title: Text(
                                  weapon,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Cost: ${details["gold_cost"]} | Damage: ${details["damage_die"]} (${details["damage_type"]}) | ${group == "SimpleWeapons" ? "Simple" : "Martial"}',
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.add, color: Theme.of(context).iconTheme.color),
                                  onPressed: () {
                                    if (!selectedWeapons.contains(weapon)) {
                                      setState(() {
                                        selectedWeapons.add(weapon);
                                        allWeapons.remove(weapon);
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('$weapon already added!'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text('No weapons match your search.'),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Navigation buttons.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text("Back"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: elevatedButtonColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(characterProvider.notifier)
                        .updateWeapons(selectedWeapons);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpellSelectionScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text("Next"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: elevatedButtonColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}