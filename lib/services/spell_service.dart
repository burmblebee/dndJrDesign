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
  static Future<List<String>> getSpellsByClass(String classKey, String levelKey) async {
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
}
