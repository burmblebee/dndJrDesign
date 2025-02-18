import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/weapon_data.dart';

class CharacterEquipment extends StatefulWidget {
  const CharacterEquipment({Key? key, required this.characterName})
      : super(key: key);

  final characterName;

  @override
  State<CharacterEquipment> createState() => _CharacterEquipmentState();
}

class _CharacterEquipmentState extends State<CharacterEquipment> {
  late String weaponOne = 'Club';
  late String weaponTwo = 'Dagger';
  late String weaponThree = 'Rapier';
  late String weaponFour = 'Flail';

  @override
  void initState() {
    super.initState();
    _fetchWeapons();
  }

  final customColor = const Color.fromARGB(255, 138, 28, 20);

  final Map<String, IconData> weaponTypeIcons = {
    'bludgeoning': Icons.gavel,
    'piercing': Icons.sports_kabaddi,
    'slashing': Icons.cut,
    'special': Icons.star,
    'ammunition': Icons.architecture,
    '—': Icons.cancel, // No damage type
  };

  IconData getWeaponIcon(String damageType) {
    return weaponTypeIcons[damageType] ??
        Icons.help; // Default to help icon if type is unknown
  }

  Future<void> _fetchWeapons() async {
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      try {
        final docRef = FirebaseFirestore.instance
            .collection('app_user_profiles')
            .doc(currentUserUid)
            .collection('characters')
            .doc(widget.characterName);

        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null) {
            setState(() {
              weaponOne = data['weaponOne'] ?? 'Unknown';
              weaponTwo = data['weaponTwo'] ?? 'Unknown';
              weaponThree = data['weaponThree'] ?? 'Unknown';
              weaponFour = data['weaponFour'] ?? 'Unknown';
            });
          }
        } else {
          print('Document does not exist.');
        }
      } catch (e) {
        print('Error fetching weapons: $e');
      }
    }
  }

  Map<String, dynamic>? getWeaponData(String weapon) {
    if (WeaponData.Weapons['SimpleWeapons']!.containsKey(weapon)) {
      return WeaponData.Weapons['SimpleWeapons']![weapon];
    }
    if (WeaponData.Weapons['MartialWeapons']!.containsKey(weapon)) {
      return WeaponData.Weapons['MartialWeapons']![weapon];
    }
    return null; // Weapon not found
  }

  Widget buildWeapon(String weapon) {
    final weaponData = getWeaponData(weapon) ?? {};
    final damageType = weaponData['damage_type'] ?? '—';

    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: Colors.black),
      ),
      height: 200,
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weapon,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Icon(
            getWeaponIcon(damageType),
            size: 75,
            color: customColor,
          ),
          const SizedBox(height: 10),
          Text('Damage: ${weaponData['damage_die'] ?? 'N/A'}'),
          Text('Type: $damageType'),
          Text(
            'Properties: ${(weaponData['properties'] as List?)?.join(', ') ?? 'N/A'}',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildRow(String one, String two) {
    return Row(
      children: [
        const Spacer(),
        buildWeapon(one),
        const SizedBox(width: 30),
        buildWeapon(two),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildRow(weaponOne, weaponTwo),
        const SizedBox(height: 30),
        buildRow(weaponThree, weaponFour),
      ],
    );
  }
}
