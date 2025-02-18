import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/dnd_forms/character_trait_selection.dart';
import '../../screens/dnd_forms/spell_selection.dart';
import '../../widgets/loaders/weapon_data_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/loaders/alignment_data_loader.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/buttons/navigation_button.dart';
import '../../widgets/loaders/lifestyle_data_loader.dart';

class EquipmentSelection extends StatefulWidget {
  const EquipmentSelection({super.key, required this.characterName});

  final characterName;

  @override
  _EquipmentSelectionState createState() => _EquipmentSelectionState();
}

class _EquipmentSelectionState extends State<EquipmentSelection> {
  final List<String> simpleWeapons = [
    'None',
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
    'None',
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
    'Blowgun',
    'Hand Crossbow',
    'Heavy Crossbow',
    'Longbow',
    'Net',
  ];

  late Widget mainContent;
  late var weaponOne = "None";
  late var weaponTwo = "None";
  late var weaponThree = "None";
  late var weaponFour = "None";
  final customColor = const Color.fromARGB(255, 138, 28, 20);

  final TextEditingController _firstWeaponController = TextEditingController();
  final TextEditingController _secondWeaponController = TextEditingController();
  final TextEditingController _thirdWeaponController = TextEditingController();
  final TextEditingController _fourthWeaponController = TextEditingController();

  String _currentSection = 'Weapon 1';

  void _saveSelections() async {
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      final docRef = FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(currentUserUid)
          .collection('characters')
          .doc(widget.characterName); // Use the UID directly

      try {
        await docRef.set({
          'weaponOne': weaponOne,
          'weaponTwo': weaponTwo,
          'weaponThree': weaponThree,
          'weaponFour': weaponFour,
          'name': widget.characterName,
        }, SetOptions(merge: true)); // Merge ensures only this field is updated
      } catch (e) {
        print('Error saving weapons: $e');
      }
    }
  }

  Widget weaponOneScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Weapon 1',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: weaponOne,
              hint: Text('Select a weapon'),
              items: simpleWeapons.map((String weapon) {
                return DropdownMenuItem<String>(
                  value: weapon,
                  child: Text(weapon),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  weaponOne = newValue ?? "None";
                });
              },
            ),
            if (weaponOne.isNotEmpty)
              WeaponDataLoader(
                weaponName: weaponOne,
                WeaponType: "SimpleWeapons",
              ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  Widget weaponTwoScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Weapon 2',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: weaponTwo,
              hint: Text('Select a weapon'),
              items: simpleWeapons.map((String weapon) {
                return DropdownMenuItem<String>(
                  value: weapon,
                  child: Text(weapon),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  weaponTwo = newValue ?? "None";
                });
              },
            ),
            if (weaponTwo.isNotEmpty)
              WeaponDataLoader(
                weaponName: weaponTwo,
                WeaponType: "SimpleWeapons",
              ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  Widget weaponThreeScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Weapon 3',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: weaponThree,
              hint: Text('Select a weapon'),
              items: martialWeapons.map((String weapon) {
                return DropdownMenuItem<String>(
                  value: weapon,
                  child: Text(weapon),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  weaponThree = newValue ?? "None";
                });
              },
            ),
            if (weaponThree.isNotEmpty)
              WeaponDataLoader(
                weaponName: weaponThree,
                WeaponType: "MartialWeapons",
              ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  Widget weaponFourScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Weapon 4',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: weaponFour,
              hint: Text('Select a weapon'),
              items: martialWeapons.map((String weapon) {
                return DropdownMenuItem<String>(
                  value: weapon,
                  child: Text(weapon),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  weaponFour = newValue ?? "None";
                });
              },
            ),
            if (weaponFour.isNotEmpty)
              WeaponDataLoader(
                weaponName: weaponFour,
                WeaponType: "MartialWeapons",
              ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentSection == 'Weapon 1') {
      mainContent = weaponOneScreen();
    } else if (_currentSection == 'Weapon 2') {
      mainContent = weaponTwoScreen();
    } else if (_currentSection == 'Weapon 3') {
      mainContent = weaponThreeScreen();
    } else if (_currentSection == 'Weapon 4') {
      mainContent = weaponFourScreen();
    } else {
      mainContent = Container();
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Equipment"),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: customColor,foregroundColor: Colors.white,
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
                  builder: (context) => CharacterTraitScreen(characterName: widget.characterName), // Pass characterName
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SegmentedButton<String>(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return customColor;
                    }
                    return Colors.grey;
                  },
                ),
                foregroundColor: const WidgetStatePropertyAll(Colors.white),
              ),
              showSelectedIcon: false,
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(
                  value: 'Weapon 1',
                  label: Center(child: Text('Weapon 1')),
                ),
                ButtonSegment<String>(
                  value: 'Weapon 2',
                  label: Center(child: Text('Weapon 2')),
                ),
                ButtonSegment<String>(
                  value: 'Weapon 3',
                  label: Center(child: Text('Weapon 3')),
                ),
                ButtonSegment<String>(
                  value: 'Weapon 4',
                  label: Center(child: Text('Weapon 4')),
                ),
              ],
              selected: {_currentSection},
              emptySelectionAllowed: false,
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _currentSection = newSelection.first;
                });
              },
            ),
            mainContent,
          ],
        ),
      ),
    );
  }
}
