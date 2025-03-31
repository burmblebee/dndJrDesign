import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/character_trait_selection.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import '../../services/spell_service.dart';
import '../../services/class_service.dart';
import '../../providers/character_provider.dart';

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
        for (var spell in characterData?["spells"] ?? []) {
          selectedSpells.add(spell);
        }
        for (var cantrip in characterData?["cantrips"] ?? []) {
          selectedCantrips.add(cantrip);
        }
      });
    } catch (e) {
      print('Error fetching character data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addSpell() async {
    TextEditingController spellNameController = TextEditingController();
    TextEditingController spellLevelController = TextEditingController();
    TextEditingController spellDescriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Spell"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: spellNameController,
                decoration: const InputDecoration(labelText: "Spell Name"),
              ),
              TextField(
                controller: spellLevelController,
                decoration: const InputDecoration(labelText: "Spell Level"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: spellDescriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (spellNameController.text.isNotEmpty &&
                    spellLevelController.text.isNotEmpty) {
                  Map<String, dynamic> newSpell = {
                    "name": spellNameController.text,
                    "level": int.tryParse(spellLevelController.text) ?? 0,
                    "description": spellDescriptionController.text,
                  };

                  List<dynamic> updatedSpells =
                      List.from(characterData?["spells"] ?? []);
                  updatedSpells.add(newSpell);

                  await FirebaseFirestore.instance
                      .collection('characters')
                      .doc(widget.characterID)
                      .update({"spells": updatedSpells});

                  setState(() {
                    characterData?["spells"] = updatedSpells;
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
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
                    tabs: [
                      Tab(text: 'Stats'),
                      Tab(text: 'Skills'),
                      Tab(text: 'Spells'),
                      Tab(
                        child: Text('Combat'),
                      ),
                      Tab(text: 'Traits'),
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
    );
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


  Widget _buildStatsTab() {
    return Center(child: Text("Stats Placeholder"));
  }

  Widget _buildSkillsTab() {
    return Center(child: Text("Skills & Saves Placeholder"));
  }

  Widget _buildTraitsTab() {
    // Placeholder for traits tab, if needed in the future
    return Center(child: Text("Traits Placeholder"));
  }

  Widget _buildCombatTab() {
    // Placeholder for combat tab, if needed in the future
    return Center(child: Text("Combat Placeholder"));
  }

  ////////////////// Funcation Timeeeeeeee /////////////////

  Future<void> loadData() async {
    try {
      final characterClass = characterData?["class"];
      if (characterClass == null) {
        setState(() {
          errorMessage = 'No class selected.';
          isLoading = false;
        });
        return;
      }

      final classData = await ClassService.getClassData(characterClass);
      if (classData == null) {
        setState(() {
          errorMessage = 'No class data found for $characterClass.';
          isLoading = false;
        });
        return;
      }

      final features = classData["Class Features"];
      if (features == null) {
        setState(() {
          errorMessage = 'No "Class Features" found for $characterClass.';
          isLoading = false;
        });
        return;
      }
      final classTableKey = "The $characterClass";
      final classTable = features[classTableKey];
      if (classTable == null || classTable["table"] == null) {
        setState(() {
          errorMessage = 'No table data found for $classTableKey.';
          isLoading = false;
        });
        return;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading data: $e';
        isLoading = false;
      });
    }
  }

  ///////////// SPELL DESCRIPTION & DIALOG SECTION /////////////
  Future<String> _getSpellDescription(String spellName) async {
    // Check if description is already cached.
    if (_spellDescriptionCache.containsKey(spellName)) {
      return _spellDescriptionCache[spellName]!;
    }
    String? desc = await SpellService.getSpellDescription(spellName);
    String finalDesc = desc ?? 'No description available.';
    _spellDescriptionCache[spellName] = finalDesc;
    return finalDesc;
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

  // Helper to extract a summary from a spell description.
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

  Widget _buildTile(
      String spellName, String summary, bool isSelected, bool isCantrip) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.grey[850],
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ListTile(
            leading: FaIcon(FontAwesomeIcons.wandMagic,
                color: Theme.of(context).iconTheme.color),
            title: Text(
              spellName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            subtitle: Text(
              summary,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.info_outline,
                      color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    _showSpellInfoDialog(context, spellName);
                  },
                ),
                // isSelected
                //     ? const Icon(Icons.check_circle, color: Colors.green)
                //     : Icon(Icons.add_circle_outline,
                //         color: Theme.of(context).iconTheme.color),
              ],
            ),
            onTap: () {
              // setState(() {
              //   if (isCantrip) {
              //     if (isSelected) {
              //       selectedCantrips.remove(spellName);
              //       isSelected = false;
              //     } else {
              //       if (selectedCantrips.length < allowedCantrips) {
              //         selectedCantrips.add(spellName);
              //         isSelected = true;
              //       } else {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           SnackBar(
              //             content: Text(
              //                 'You can only select $allowedCantrips cantrips.',
              //                 style: const TextStyle(color: Colors.white)),
              //           ),
              //         );
              //       }
              //     }
              //   } else {
              //     if (isSelected) {
              //       selectedSpells.remove(spellName);
              //       isSelected = false;
              //     } else {
              //       if (selectedSpells.length < allowedSpells) {
              //         selectedSpells.add(spellName);
              //         isSelected = true;
              //       } else {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           SnackBar(
              //             content: Text(
              //               'You can only select $allowedSpells spells.',
              //               style: const TextStyle(color: Colors.black),
              //             ),
              //             backgroundColor: Colors.white,
              //           ),
              //         );
              //       }
              //     }
              //   }
              // });
            },
          );
        },
      ),
    );
  }

// Updated buildSpellTile that uses the cache to avoid reloading on each setState.
  Widget buildSpellTile(String spellName, bool isCantrip) {
    bool isSelected = isCantrip
        ? selectedCantrips.contains(spellName)
        : selectedSpells.contains(spellName);

    // If the description is already cached, build the tile directly.
    if (_spellDescriptionCache.containsKey(spellName)) {
      String description = _spellDescriptionCache[spellName]!;
      String summary = _buildSummary(description);
      return _buildTile(spellName, summary, isSelected, isCantrip);
    } else {
      // Otherwise, use FutureBuilder to load and cache the description.
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
}


