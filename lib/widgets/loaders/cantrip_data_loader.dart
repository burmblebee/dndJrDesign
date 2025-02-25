
import 'package:flutter/material.dart';
import '../../data/spell and cantrips/bard_cantrips_and_spells.dart';
import '../../data/spell and cantrips/sorcerer_cantrip_and_spells.dart';
import '../../data/spell and cantrips/warlock_cantrips_and_spells.dart';
import '../../data/spell and cantrips/wizard_cantrips_and_spells.dart';
import '../../data/spell and cantrips/druid_cantrip_and_spells.dart';
import '../../data/spell and cantrips/cleric_cantrips_and_spells.dart';

class CantripDataLoader extends StatelessWidget {
  final String cantripName;
  final String className;

  const CantripDataLoader(
      {super.key, required this.cantripName, required this.className});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? cantripData;

    switch (className) {
      case 'Bard':
        cantripData = _getCantripData(bardMap, cantripName);
        break;
      case 'Cleric':
        cantripData = _getCantripData(clericMap, cantripName);
        break;
      case 'Druid':
        cantripData = _getCantripData(druidMap, cantripName);
        break;
      case 'Sorcerer':
        cantripData = _getCantripData(sorcererMap, cantripName);
        break;
      case 'Warlock':
        cantripData = _getCantripData(warlockMap, cantripName);
        break;
      case 'Wizard':
        cantripData = _getCantripData(wizardMap, cantripName);
        break;
      default:
        cantripData = null;
    }

    return cantripData == null
        ? Center(child: Text('Cantrip not found'))
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Container(
                height: 500,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cantripName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cantripData['description'] ?? 'No description available',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Divider(height: 30, color: Colors.grey),
                    Text(
                      'Range: ${cantripData['range'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Components: ${cantripData['components'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Duration: ${cantripData['duration'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Level: ${cantripData['level'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'School: ${cantripData['school'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Cast Time: ${cantripData['castTime'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ), 
          );
  }

  Map<String, dynamic>? _getCantripData(
      Map<String, dynamic> classMap, String cantripName) {
    for (var cantrip in classMap["Cantrips"]!) {
      if (cantrip["name"] == cantripName) {
        return cantrip;
      }
    }
    return null;
  }
}

