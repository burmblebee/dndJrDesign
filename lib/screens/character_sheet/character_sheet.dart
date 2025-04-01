import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/rpg_awesome_icons.dart';
import 'package:warlocks_of_the_beach/screens/character_sheet/popup_dice_roller.dart';
import '../../services/spell_service.dart';
import '../../services/class_service.dart';

class CharacterSheet extends StatefulWidget {
  final String characterID;
  const CharacterSheet({Key? key, required this.characterID}) : super(key: key);

  @override
  _CharacterSheetState createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  Map<String, dynamic>? characterData;
  bool isLoading = true;
  final Map<String, String> _spellDescriptionCache = {};
  String errorMessage = '';
  Set<String> selectedSpells = {};
  Set<String> selectedCantrips = {};
  Set<String> selectedWeapons = {};
  String strengthScore = '10';
  String dexterityScore = '10';
  String constitutionScore = '10';
  String intelligenceScore = '10';
  String wisdomScore = '10';
  String charismaScore = '10';
  String strengthModifier = '0';
  String dexterityModifier = '0';
  String constitutionModifier = '0';
  String intelligenceModifier = '0';
  String wisdomModifier = '0';
  String charismaModifier = '0';
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

  final Map<String, String> simpleWeaponDamage = {
    'Club': '1d4',
    'Dagger': '1d4',
    'Greatclub': '2d4',
    'Handaxe': '1d6',
    'Javelin': '1d6',
    'Light Hammer': '1d4',
    'Mace': '1d6',
    'Quarterstaff': '1d6',
    'Sickle': '1d4',
    'Spear': '1d6',
    'Light Crossbow': '1d8',
    'Dart': '1d4',
    'Shortbow': '1d6',
    'Sling': '1d4',
    'Blowgun': '1',
  };

  final Map<String, String> martialWeaponDamage = {
    'Battleaxe': '1d8',
    'Flail': '1d8',
    'Glaive': '1d10',
    'Greataxe': '1d12',
    'Greatsword': '2d6',
    'Halberd': '1d10',
    'Lance': '1d12',
    'Longsword': '1d8',
    'Maul': '2d6',
    'Morningstar': '1d8',
    'Pike': '1d10',
    'Rapier': '1d8',
    'Scimitar': '1d6',
    'Shortsword': '1d6',
    'Trident': '1d6',
    'War Pick': '1d8',
    'Warhammer': '1d8',
    'Whip': '1d4',
    'Hand Crossbow': '1d6',
    'Heavy Crossbow': '1d10',
    'Longbow': '1d8',
    'Net': '0',
  };

  final Map<String, String> weaponModifiers = {
    'Club': 'Strength',
    'Dagger': 'Dexterity or Strength',
    'Greatclub': 'Strength',
    'Handaxe': 'Dexterity or Strength',
    'Javelin': 'Dexterity or Strength',
    'Light Hammer': 'Dexterity or Strength',
    'Mace': 'Strength',
    'Quarterstaff': 'Strength',
    'Sickle': 'Strength',
    'Spear': 'Dexterity or Strength',
    'Light Crossbow': 'Dexterity',
    'Dart': 'Dexterity',
    'Shortbow': 'Dexterity',
    'Sling': 'Dexterity',
    'Blowgun': 'Dexterity',
    'Battleaxe': 'Strength',
    'Flail': 'Strength',
    'Glaive': 'Strength',
    'Greataxe': 'Strength',
    'Greatsword': 'Strength',
    'Halberd': 'Strength',
    'Lance': 'Strength',
    'Longsword': 'Strength',
    'Maul': 'Strength',
    'Morningstar': 'Strength',
    'Pike': 'Strength',
    'Rapier': 'Dexterity',
    'Scimitar': 'Dexterity',
    'Shortsword': 'Dexterity',
    'Trident': 'Dexterity or Strength',
    'War Pick': 'Strength',
    'Warhammer': 'Strength',
    'Whip': 'Dexterity',
    'Hand Crossbow': 'Dexterity',
    'Heavy Crossbow': 'Dexterity',
    'Longbow': 'Dexterity',
    'Net': 'Dexterity',
  };

  @override
  void initState() {
    super.initState();
    _fetchCharacterData();
  }

  Future<void> _fetchCharacterData() async {
    final User user = FirebaseAuth.instance.currentUser!;
    final uuid = user.uid;
    try {
      DocumentSnapshot characterSnapshot = await FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(uuid)
          .collection('characters')
          .doc(widget.characterID)
          .get();

      setState(() {
        characterData = characterSnapshot.data() as Map<String, dynamic>?;
        isLoading = false;

        //set the scores for easy access
        strengthScore =
            characterData?["abilityScores"]["Strength"]?.toString() ?? '10';
        dexterityScore =
            characterData?["abilityScores"]["Dexterity"]?.toString() ?? '10';
        constitutionScore =
            characterData?["abilityScores"]["Constitution"]?.toString() ?? '10';
        intelligenceScore =
            characterData?["abilityScores"]["Intelligence"]?.toString() ?? '10';
        wisdomScore =
            characterData?["abilityScores"]["Wisdom"]?.toString() ?? '10';
        charismaScore =
            characterData?["abilityScores"]["Charisma"]?.toString() ?? '10';

        //set the ability modifiers based on the scores
        strengthModifier = ((int.parse(strengthScore) - 10) ~/ 2).toString();
        dexterityModifier = ((int.parse(dexterityScore) - 10) ~/ 2).toString();
        charismaModifier = ((int.parse(charismaScore) - 10) ~/ 2).toString();
        constitutionModifier =
            ((int.parse(constitutionScore) - 10) ~/ 2).toString();
        intelligenceModifier =
            ((int.parse(intelligenceScore) - 10) ~/ 2).toString();
        wisdomModifier = ((int.parse(wisdomScore) - 10) ~/ 2).toString();

        for (var spell in characterData?["spells"] ?? []) {
          selectedSpells.add(spell);
        }
        for (var cantrip in characterData?["cantrips"] ?? []) {
          selectedCantrips.add(cantrip);
        }
        for (var weapon in characterData?["weapons"] ?? []) {
          selectedWeapons.add(weapon);
        }
      });
    } catch (e) {
      print('Error fetching character data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(characterData?['name'] ?? 'Character Sheet')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 5,
              child: Column(
                children: [
                  const TabBar(
                    isScrollable: false,
                    tabs: [
                      Tab(child: Text('Stats')),
                      Tab(child: Text('Skills')),
                      Tab(child: Text('Spells')),
                      Tab(child: Text('Combat')),
                      Tab(child: Text('Traits')),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildStatsTab(),
                        _buildSkillsTab(),
                        _buildSpellsTab(),
                        _buildCombatTab(),
                        _buildTraitsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Roll 2d6 using the popup dice roller
          int? result = await showDiceRollPopup(context, "2d6");
          if (result != null) {
            // Show the result in a dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Dice Roll Result"),
                content: Text("You rolled: $result"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.casino), // Dice icon
      ),
    );
  }

  Widget _buildStatsTab() {
    return Center(child: Text("Stats Placeholder"));
  }

  Widget _buildSkillsTab() {
    return Center(child: Text("Skills Placeholder"));
  }

  Widget _buildSpellsTab() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedCantrips.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '    Cantrips:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            for (var cantrip in selectedCantrips) buildSpellTile(cantrip, true),
          ],
          if (selectedSpells.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '    Level 1 Spells:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            for (var spell in selectedSpells) buildSpellTile(spell, false),
          ],
          if (selectedCantrips.isEmpty && selectedSpells.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No spells selected.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCombatTab() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            if (selectedWeapons.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '    Weapons:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              for (var weapon in selectedWeapons)
                _buildWeaponTile(weapon), // Use the weapon tile builder
            ],
          ],
        ),
      ),
    );
    // return Center(
    //     child: Column(
    //   children: [
    //     if (selectedWeapons.isNotEmpty) ...[
    //       const Padding(
    //         padding: EdgeInsets.symmetric(vertical: 8.0),
    //         child: Text(
    //           '    Weapons:',
    //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //       for (var weapon in selectedWeapons) Text(weapon),
    //     ],
    //   ],
    // ));
  }

  Widget _buildTraitsTab() {
    return Center(child: Text("Traits Placeholder"));
  }

  Widget buildSpellTile(String spellName, bool isCantrip) {
    bool isSelected = isCantrip
        ? selectedCantrips.contains(spellName)
        : selectedSpells.contains(spellName);

    if (_spellDescriptionCache.containsKey(spellName)) {
      String description = _spellDescriptionCache[spellName]!;
      String summary = _buildSummary(description);
      return _buildTile(spellName, summary, isSelected, isCantrip);
    } else {
      return FutureBuilder<String>(
        future: _getSpellDescription(spellName),
        builder: (context, snapshot) {
          String summary = 'Loading description...';
          if (snapshot.hasData) {
            String description = snapshot.data!;
            summary = _buildSummary(description);
          }
          return _buildTile(spellName, summary, isSelected, isCantrip);
        },
      );
    }
  }

  Future<String> _getSpellDescription(String spellName) async {
    if (_spellDescriptionCache.containsKey(spellName)) {
      return _spellDescriptionCache[spellName]!;
    }
    String? desc = await SpellService.getSpellDescription(spellName);
    String finalDesc = desc ?? 'No description available.';
    _spellDescriptionCache[spellName] = finalDesc;
    return finalDesc;
  }

  Widget _buildTile(
      String spellName, String summary, bool isSelected, bool isCantrip) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.grey[850],
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.wandMagic,
            color: Theme.of(context).iconTheme.color),
        title: Text(
          spellName,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          summary,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        trailing: IconButton(
          icon: Icon(Icons.info_outline,
              color: Theme.of(context).iconTheme.color),
          onPressed: () {
            _showSpellInfoDialog(context, spellName);
          },
        ),
      ),
    );
  }

  Future<void> _showSpellInfoDialog(
      BuildContext context, String spellName) async {
    String description = await _getSpellDescription(spellName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            spellName,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: _buildFormattedDescription(description),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }

  Widget _buildFormattedDescription(String description) {
    List<Widget> lineWidgets = [];
    for (var line in description.split('\n')) {
      String cleanLine = line.replaceAll('*', '').trim();
      if (cleanLine.isEmpty) continue;
      if (cleanLine.contains(':')) {
        var parts = cleanLine.split(RegExp(r':\s*'));
        if (parts.length >= 2) {
          String header = parts[0] + ":";
          String detail = parts.sublist(1).join(": ");
          lineWidgets.add(
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: header + " ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: detail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          lineWidgets.add(
            Text(
              cleanLine,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          );
        }
      } else {
        lineWidgets.add(
          Text(
            cleanLine,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        );
      }
      lineWidgets.add(const SizedBox(height: 8));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lineWidgets,
    );
  }

  String _buildSummary(String description) {
    List<String> lines = description
        .split('\n')
        .map((line) => line.replaceAll('*', '').trim())
        .toList();
    String schoolInfo = lines.firstWhere(
      (line) => line.toLowerCase().startsWith('school:'),
      orElse: () => '',
    );
    String classInfo = lines.firstWhere(
      (line) => line.toLowerCase().startsWith('class:'),
      orElse: () => '',
    );
    String rangeInfo = lines.firstWhere(
      (line) => line.toLowerCase().startsWith('range:'),
      orElse: () => '',
    );
    List<String> infoParts = [];
    if (schoolInfo.isNotEmpty) infoParts.add(schoolInfo);
    if (classInfo.isNotEmpty) infoParts.add(classInfo);
    if (rangeInfo.isNotEmpty) infoParts.add(rangeInfo);
    String summary = infoParts.join(' | ');
    if (summary.isEmpty) {
      summary = description.split('\n').take(3).join('\n');
    }
    return summary;
  }

  Widget _buildWeaponTile(String weaponName) {
    final String damage = simpleWeaponDamage[weaponName] ??
        martialWeaponDamage[weaponName] ??
        'Unknown';
    final String attackModifier = _getWeaponAttackModifier(weaponName);
    final String modifierType = weaponModifiers[weaponName] ?? 'Strength';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: Theme.of(context).listTileTheme.tileColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weapon Icon
            FaIcon(
              _getWeaponIcon(weaponName),
              size: 40,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 12),

            // Weapon Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weapon Name
                  Text(
                    weaponName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Damage and Attack Modifier
                  Text(
                    'Damage: $damage + $attackModifier',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Modifier Type
                  Text(
                    'Modifier: $modifierType',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Attack Modifier Display
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).iconTheme.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'To Hit',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '+$attackModifier',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  String _getWeaponAttackModifier(String weaponName) {
    int returnModifier = 0;
    String modifierType = weaponModifiers[weaponName] ?? 'Strength';
    switch (modifierType) {
      case 'Strength':
        returnModifier = int.parse(strengthModifier) + 2;
        return returnModifier
            .toString(); // +2 is the proficiency bonus for simplicity
      case 'Dexterity':
        returnModifier = int.parse(dexterityModifier) + 2;
        return returnModifier.toString();
      case 'Dexterity or Strength':
        if (int.parse(dexterityScore) >= int.parse(strengthScore)) {
          returnModifier = int.parse(dexterityModifier) + 2;
          return returnModifier.toString(); //use Dexterity if it's higher
        } else {
          returnModifier = int.parse(strengthModifier) + 2;
          return returnModifier.toString(); //otherwise use Strength
        }
      default:
        return '0'; // trust ol default we all know and love :)
    }
  }
}
