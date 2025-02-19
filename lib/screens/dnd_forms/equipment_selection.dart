import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/rpg_awesome_icons.dart';
import 'package:warlocks_of_the_beach/widgets/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/main_drawer.dart';
import '../../data/weapon_data.dart';
import '../../screens/dnd_forms/character_trait_selection.dart';
import '../../widgets/buttons/navigation_button.dart';

class EquipmentSelection extends StatefulWidget {
  const EquipmentSelection({Key? key, required this.characterName})
      : super(key: key);

  final String characterName;

  @override
  _EquipmentSelectionState createState() => _EquipmentSelectionState();
}

class _EquipmentSelectionState extends State<EquipmentSelection> {
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

  // Using customColor for icons; the overlay will now use gray tones.
  final Color customColor = const Color.fromARGB(255, 138, 28, 20);

  // GlobalKey to measure the bottom overlay’s height.
  final GlobalKey _selectedOverlayKey = GlobalKey();

  // This variable holds the measured height of the selected overlay.
  double _selectedOverlayHeight = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text;
      });
    });
    // Delay measurement until after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateOverlayHeight());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Call this method to measure the overlay's height.
  void _updateOverlayHeight() {
    final context = _selectedOverlayKey.currentContext;
    if (context != null) {
      final newHeight = context.size?.height ?? 0;
      if (newHeight != _selectedOverlayHeight) {
        setState(() {
          _selectedOverlayHeight = newHeight;
        });
      }
    }
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

  Future<void> _saveSelections() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef =
          firestore.collection('characters').doc(widget.characterName);
      await docRef.set({
        'name': widget.characterName,
        'weapons': selectedWeapons,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving weapons: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Re-measure the overlay each build in case the content changed.
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateOverlayHeight());

    final List<String> filteredWeapons = allWeapons.where((weapon) {
      return weapon.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Equipment"),
        backgroundColor: customColor,
        foregroundColor: Colors.white,
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      body: Stack(
        children: [
          // Main content area; the bottom padding equals the overlay's height.
          Padding(
            padding:
                EdgeInsets.fromLTRB(16.0, 16.0, 16.0, _selectedOverlayHeight),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Weapons',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: filteredWeapons.isNotEmpty
                      ? ListView.separated(
                          itemCount: filteredWeapons.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final weapon = filteredWeapons[index];
                            final String group = simpleWeapons.contains(weapon)
                                ? "SimpleWeapons"
                                : "MartialWeapons";
                            final details =
                                WeaponData.Weapons[group]?[weapon] ??
                                    {
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
                                  color: customColor,
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
                                  icon: Icon(Icons.add, color: customColor),
                                  onPressed: () {
                                    if (!selectedWeapons.contains(weapon)) {
                                      setState(() {
                                        selectedWeapons.add(weapon);
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                ),
              ],
            ),
          ),
          // Bottom overlay for selected weapons with a blur effect.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  key: _selectedOverlayKey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey[800]!,
                        Colors.grey[400]!,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: selectedWeapons.isNotEmpty
                      ? Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: selectedWeapons.map((weapon) {
                            return Chip(
                              backgroundColor: Theme.of(context).cardColor,
                              avatar: FaIcon(
                                _getWeaponIcon(weapon),
                                color: customColor,
                                size: 16,
                              ),
                              label: Text(weapon),
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () {
                                setState(() {
                                  selectedWeapons.remove(weapon);
                                });
                              },
                            );
                          }).toList(),
                        )
                      : Center(
                          child: Text(
                            'No weapons selected.',
                            style: TextStyle(
                              color: customColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}


// Container(
//             padding:
//                 const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             color: Colors.white,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 NavigationButton(
//                   onPressed: () => Navigator.pop(context),
//                   textContent: 'Back',
//                 ),
//                 NavigationButton(
//                   textContent: "Next",
//                   onPressed: () {
//                     _saveSelections();
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CharacterTraitScreen(
//                           characterName: widget.characterName,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),