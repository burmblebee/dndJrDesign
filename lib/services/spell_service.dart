import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SpellService {
  // Loads the entire Spellcasting section from spellcasting.json.
  static Future<Map<String, dynamic>> _loadSpellCastingData() async {
    String jsonString =
        await rootBundle.loadString('lib/data/SRD Data/spellcasting.json');
    return json.decode(jsonString)['Spellcasting'];
  }

  // Returns a list of spells for a given class key and level key.
  // For example, classKey = 'Bard Spells', levelKey = '1st Level' or 'Cantrips (0 Level)'
  static Future<List<String>> getSpellsByClass(
      String classKey, String levelKey) async {
    final data = await _loadSpellCastingData();
    final spellLists = data['Spell Lists'];
    if (spellLists.containsKey(classKey)) {
      final classSpells = spellLists[classKey];
      if (classSpells.containsKey(levelKey)) {
        return List<String>.from(classSpells[levelKey]);
      }
    }
    return [];
  }

  // Returns the spell description for a given spell name.
  static Future<String?> getSpellDescription(String spellName) async {
    final data = await _loadSpellCastingData();
    final descriptions = data['Spell Descriptions'];
    if (descriptions != null && descriptions.containsKey(spellName)) {
      var content = descriptions[spellName]['content'];
      if (content is List) {
        return content.join('\n');
      } else if (content is String) {
        return content;
      }
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> getAllSpells() async {
    final data = await _loadSpellCastingData();
    final spellLists = data['Spell Lists'];
    final descriptions = data['Spell Descriptions'];

    // Map to store spells grouped by level
    Map<String, List<Map<String, dynamic>>> spellsByLevel = {
      'Cantrips': [],
      'Level 1': [],
      'Level 2': [],
      'Level 3': [],
      'Level 4': [],
      'Level 5': [],
      'Level 6': [],
      'Level 7': [],
      'Level 8': [],
      'Level 9': [],
    };

    // Iterate through all class spell lists
    spellLists.forEach((classKey, classSpells) {
      classSpells.forEach((levelKey, spells) {
        String level =
            _mapLevelKeyToLevel(levelKey); // Map level key to readable level
        if (spellsByLevel.containsKey(level)) {
          for (String spellName in spells) {
            // Avoid duplicates by checking if the spell is already added
            if (!spellsByLevel[level]!
                .any((spell) => spell['name'] == spellName)) {
              spellsByLevel[level]!.add({
                'name': spellName,
                'level': level,
                'description': descriptions[spellName]?['content'] ??
                    'No description available',
                'classes': [
                  classKey.replaceAll(' Spells', '')
                ], // Add class name
              });
            } else {
              // If the spell already exists, add the class to its classes list
              var existingSpell = spellsByLevel[level]!
                  .firstWhere((spell) => spell['name'] == spellName);
              existingSpell['classes'].add(classKey.replaceAll(' Spells', ''));
            }
          }
        }
      });
    });

    // Flatten the map into a single list of spells
    List<Map<String, dynamic>> allSpells = [];
    spellsByLevel.forEach((level, spells) {
      allSpells.addAll(spells);
    });

    return allSpells;
  }

// Helper method to map level keys to readable levels
  static String _mapLevelKeyToLevel(String levelKey) {
    if (levelKey == 'Cantrips (0 Level)') return 'Cantrips';
    if (levelKey.endsWith('Level')) {
      return 'Level ${levelKey.split(' ')[0]}';
    }
    return 'Unknown';
  }
}
