import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/rpg_awesome_icons.dart';
import '../../screens/dnd_forms/character_trait_selection.dart';
import '../../widgets/dnd_form_widgets/main_drawer.dart';
import '../../widgets/buttons/navigation_button.dart';
import '../../widgets/loaders/weapon_data_loader.dart';

class EquipmentSelection extends StatefulWidget {
  const EquipmentSelection({Key? key, required this.characterName})
      : super(key: key);

  final String characterName;

  @override
  _EquipmentSelectionState createState() => _EquipmentSelectionState();
}

class _EquipmentSelectionState extends State<EquipmentSelection> {
  // Lists of available weapons (excluding a "None" option)
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

  // Combined list of weapons (duplicates removed and sorted alphabetically)
  late final List<String> allWeapons = (() {
    final weapons = {...simpleWeapons, ...martialWeapons}.toList();
    weapons.sort();
    return weapons;
  })();

  // Mapping of weapon details.
  final Map<String, Map<String, String>> weaponDetails = {
    'Club': {
      'cost': '1 gp',
      'damage': '1d4',
      'damageType': 'Bludgeoning',
      'weaponType': 'Simple'
    },
    'Dagger': {
      'cost': '2 gp',
      'damage': '1d4',
      'damageType': 'Piercing',
      'weaponType': 'Simple'
    },
    'Greatclub': {
      'cost': '2 gp',
      'damage': '1d8',
      'damageType': 'Bludgeoning',
      'weaponType': 'Simple'
    },
    'Handaxe': {
      'cost': '5 gp',
      'damage': '1d6',
      'damageType': 'Slashing',
      'weaponType': 'Simple'
    },
    'Javelin': {
      'cost': '1 gp',
      'damage': '1d6',
      'damageType': 'Piercing',
      'weaponType': 'Simple'
    },
    'Light Hammer': {
      'cost': '2 gp',
      'damage': '1d4',
      'damageType': 'Bludgeoning',
      'weaponType': 'Simple'
    },
    'Mace': {
      'cost': '5 gp',
      'damage': '1d6',
      'damageType': 'Bludgeoning',
      'weaponType': 'Simple'
    },
    'Quarterstaff': {
      'cost': '2 gp',
      'damage': '1d6',
      'damageType': 'Bludgeoning',
      'weaponType': 'Simple'
    },
    'Sickle': {
      'cost': '1 gp',
      'damage': '1d4',
      'damageType': 'Slashing',
      'weaponType': 'Simple'
    },
    'Spear': {
      'cost': '1 gp',
      'damage': '1d6',
      'damageType': 'Piercing',
      'weaponType': 'Simple'
    },
    'Light Crossbow': {
      'cost': '25 gp',
      'damage': '1d8',
      'damageType': 'Piercing',
      'weaponType': 'Simple'
    },
    'Dart': {
      'cost': '1/4 gp',
      'damage': '1d4',
      'damageType': 'Piercing',
      'weaponType': 'Simple'
    },
    'Shortbow': {
      'cost': '25 gp',
      'damage': '1d6',
      'damageType': 'Piercing',
      'weaponType': 'Simple'
    },
    'Sling': {
      'cost': '1 gp',
      'damage': '1d4',
      'damageType': 'Bludgeoning',
      'weaponType': 'Simple'
    },
    'Blowgun': {
      'cost': '10 gp',
      'damage': '1',
      'damageType': 'Piercing',
      'weaponType': 'Simple'
    },
    'Battleaxe': {
      'cost': '10 gp',
      'damage': '1d8',
      'damageType': 'Slashing',
      'weaponType': 'Martial'
    },
    'Flail': {
      'cost': '10 gp',
      'damage': '1d8',
      'damageType': 'Bludgeoning',
      'weaponType': 'Martial'
    },
    'Glaive': {
      'cost': '20 gp',
      'damage': '1d10',
      'damageType': 'Slashing',
      'weaponType': 'Martial'
    },
    'Greataxe': {
      'cost': '30 gp',
      'damage': '1d12',
      'damageType': 'Slashing',
      'weaponType': 'Martial'
    },
    'Greatsword': {
      'cost': '50 gp',
      'damage': '2d6',
      'damageType': 'Slashing',
      'weaponType': 'Martial'
    },
    'Halberd': {
      'cost': '20 gp',
      'damage': '1d10',
      'damageType': 'Slashing',
      'weaponType': 'Martial'
    },
    'Lance': {
      'cost': '10 gp',
      'damage': '1d12',
      'damageType': 'Piercing',
      'weaponType': 'Martial'
    },
    'Longsword': {
      'cost': '15 gp',
      'damage': '1d8',
      'damageType': 'Slashing',
      'weaponType': 'Martial'
    },
    'Maul': {
      'cost': '10 gp',
      'damage': '2d6',
      'damageType': 'Bludgeoning',
      'weaponType': 'Martial'
    },
    'Morningstar': {
      'cost': '15 gp',
      'damage': '1d8',
      'damageType': 'Piercing',
      'weaponType': 'Martial'
    },
    'Pike': {
      'cost': '5 gp',
      'damage': '1d10',
      'damageType': 'Piercing',
      'weaponType': 'Martial'
    },
    'Rapier': {
      'cost': '25 gp',
      'damage': '1d8',
      'damageType': 'Piercing',
      'weaponType': 'Martial'
    },
    'Scimitar': {
      'cost': '25 gp',
      'damage': '1d6',
      'damageType': 'Slashing',
      'weaponType': 'Martial'
    },
    'Shortsword': {
      'cost': '10 gp',
      'damage': '1d6',
      'damageType': 'Piercing',
      'weaponType': 'Martial'
    },
    'Trident': {
      'cost': '5 gp',
      'damage': '1d6',
      'damageType': 'Piercing',
      'weaponType': 'Martial'
    },
    'War Pick': {
      'cost': '5 gp',
      'damage': '1d8',
      'damageType': 'Piercing',
      'weaponType': 'Martial'
    },
    'Warhammer': {
      'cost': '15 gp',
      'damage': '1d8',
      'damageType': 'Bludgeoning',
      'weaponType': 'Martial'
    },
    'Whip': {
      'cost': '2 gp',
      'damage': '1d4',
      'damageType': 'Slashing',
      'weaponType': 'Martial'
    },
    'Hand Crossbow': {
      'cost': '75 gp',
      'damage': '1d6',
      'damageType': 'Piercing',
      'weaponType': 'Martial'
    },
    'Heavy Crossbow': {
      'cost': '50 gp',
      'damage': '1d10',
      'damageType': 'Piercing',
      'weaponType': 'Martial'
    },
    'Longbow': {
      'cost': '50 gp',
      'damage': '1d8',
      'damageType': 'Piercing',
      'weaponType': 'Martial'
    },
    'Net': {
      'cost': '1 gp',
      'damage': '-',
      'damageType': '-',
      'weaponType': 'Martial'
    },
  };

  // Controller for the search bar.
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  // List to hold the selected weapons.
  List<String> selectedWeapons = [];

  // Custom color used in the UI.
  final Color customColor = const Color.fromARGB(255, 138, 28, 20);

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

  // Returns a FontAwesome icon that best matches the given weapon.
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
      return FontAwesomeIcons.solidCircle; // a placeholder icon
    }
    return FontAwesomeIcons.crosshairs; // default icon
  }

  // Save the selected weapons to Firestore under a root-level "characters" collection.
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
    // Filter available weapons by the current search query (case-insensitive)
    final List<String> filteredWeapons = allWeapons.where((weapon) {
      return weapon.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Equipment"),
        backgroundColor: customColor,
        foregroundColor: Colors.white,
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: Row(
        children: [
          NavigationButton(
            onPressed: () {
              Navigator.pop(context);
            },
            textContent: 'Back',
          ),
          const SizedBox(width: 30),
          NavigationButton(
            textContent: "Next",
            onPressed: () {
              _saveSelections();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterTraitScreen(
                      characterName: widget.characterName),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar for filtering weapons.
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Weapons',
                border: OutlineInputBorder(),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            // List of filtered weapons.
            if (filteredWeapons.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredWeapons.length,
                itemBuilder: (context, index) {
                  final weapon = filteredWeapons[index];
                  final details = weaponDetails[weapon] ??
                      {
                        'cost': 'N/A',
                        'damage': 'N/A',
                        'damageType': 'N/A',
                        'weaponType': simpleWeapons.contains(weapon)
                            ? 'Simple'
                            : 'Martial'
                      };
                  return ListTile(
                    leading: FaIcon(_getWeaponIcon(weapon), color: customColor),
                    title: Text(weapon),
                    subtitle: Text(
                        'Cost: ${details['cost']} | Damage: ${details['damage']} (${details['damageType']}) | Type: ${details['weaponType']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.add, color: customColor),
                      onPressed: () {
                        if (!selectedWeapons.contains(weapon)) {
                          setState(() {
                            selectedWeapons.add(weapon);
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('$weapon already added!')));
                        }
                      },
                    ),
                  );
                },
              )
            else
              const Text('No weapons match your search.'),
            const SizedBox(height: 20),
            // Display the selected weapons as chips with a delete icon.
            if (selectedWeapons.isNotEmpty)
              Wrap(
                spacing: 8,
                children: selectedWeapons.map((weapon) {
                  return Chip(
                    label: Text(weapon),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () {
                      setState(() {
                        selectedWeapons.remove(weapon);
                      });
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 20),
            // Optionally, display detailed info for each selected weapon.
            Column(
              children: selectedWeapons.map((weapon) {
                final details = weaponDetails[weapon] ??
                    {
                      'cost': 'N/A',
                      'damage': 'N/A',
                      'damageType': 'N/A',
                      'weaponType': simpleWeapons.contains(weapon)
                          ? 'Simple'
                          : 'Martial'
                    };
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading:
                          FaIcon(_getWeaponIcon(weapon), color: customColor),
                      title: Text(weapon,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          'Cost: ${details['cost']} | Damage: ${details['damage']} (${details['damageType']}) | Type: ${details['weaponType']}'),
                    ),
                    WeaponDataLoader(
                      weaponName: weapon,
                      WeaponType: details['weaponType']!,
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
