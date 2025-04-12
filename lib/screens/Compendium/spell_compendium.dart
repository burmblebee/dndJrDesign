import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/spell_service.dart';

/// Represents a spell along with the list of classes that offer it.
class CombinedSpell {
  final String name;
  final List<String> classes;
  CombinedSpell({required this.name, required this.classes});
}

class SpellCompendium extends StatefulWidget {
  final bool inSession; // Add the inSession parameter

  const SpellCompendium({Key? key, this.inSession = false}) : super(key: key);

  @override
  _SpellCompendiumState createState() => _SpellCompendiumState();
}

class _SpellCompendiumState extends State<SpellCompendium> {
  ///////////// VARIABLES & STATE /////////////
  bool isLoading = true;
  String errorMessage = '';

  // Cache for spell descriptions.
  final Map<String, String> _spellDescriptionCache = {};

  // Controller for the search bar.
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  // Filter states.
  Set<String> selectedSchools = {};
  Set<String> selectedTypes = {};
  Set<String> selectedRanges = {};
  Set<String> selectedClasses = {};

  // Predefined filter options.
  final List<String> schoolOptions = [
    'Abjuration',
    'Conjuration',
    'Divination',
    'Enchantment',
    'Evocation',
    'Illusion',
    'Necromancy',
    'Transmutation'
  ];
  final List<String> typeOptions = ['Damage', 'Utility'];
  final List<String> rangeOptions = ['Range', 'Touch', 'Self'];

  // List of classes.
  final List<String> classOptions = [
    'Bard',
    'Cleric',
    'Druid',
    'Paladin',
    'Ranger',
    'Sorcerer',
    'Warlock',
    'Wizard',
  ];

  // Original per‑class data.
  static Map<String, Map<String, List<String>>> allSpells = {};

  // Combined data by level.
  Map<String, List<CombinedSpell>> combinedSpellsByLevel = {};

  /// Loads the Spellcasting data from JSON and returns its "Spellcasting" section.
  static Future<Map<String, dynamic>> _loadSpellCastingData() async {
    String jsonString =
        await rootBundle.loadString('lib/data/SRD Data/spellcasting.json');
    return json.decode(jsonString)['Spellcasting'];
  }

  /// Converts a level number into the JSON key.
  /// Level 0 becomes "Cantrips (0 Level)", level 1 becomes "1st Level", etc.
  String getLevelKey(int level) {
    if (level == 0) return "Cantrips (0 Level)";
    if (level == 1) return "1st Level";
    if (level == 2) return "2nd Level";
    if (level == 3) return "3rd Level";
    return "${level}th Level";
  }

  /// Loads allSpells from JSON.
  /// For Ranger and Paladin, only levels 1–5 are loaded.
  Future<void> loadAllSpells() async {
    try {
      final data = await _loadSpellCastingData();
      final spellLists = data['Spell Lists'];
      allSpells.clear();

      for (String className in classOptions) {
        // JSON keys are like "Bard Spells", "Cleric Spells", etc.
        String jsonClassKey = "$className Spells";
        Map<String, List<String>> levelMap = {};

        if (spellLists.containsKey(jsonClassKey)) {
          final classSpells = spellLists[jsonClassKey];
          if (className == 'Ranger' || className == 'Paladin') {
            for (int i = 1; i <= 5; i++) {
              String levelKey = getLevelKey(i);
              if (classSpells.containsKey(levelKey)) {
                levelMap[levelKey] = List<String>.from(classSpells[levelKey]);
              } else {
                levelMap[levelKey] = [];
              }
            }
          } else {
            for (int i = 0; i <= 9; i++) {
              String levelKey = getLevelKey(i);
              if (classSpells.containsKey(levelKey)) {
                levelMap[levelKey] = List<String>.from(classSpells[levelKey]);
              } else {
                levelMap[levelKey] = [];
              }
            }
          }
          allSpells[className] = levelMap;
        } else {
          allSpells[className] = {};
        }
      }
      combineSpellsByLevel();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading spells: $e';
        isLoading = false;
      });
    }
  }

  /// Combines allSpells (by class) into a map organized by level.
  void combineSpellsByLevel() {
    combinedSpellsByLevel.clear();
    List<String> levelOrder = [
      "Cantrips (0 Level)",
      "1st Level",
      "2nd Level",
      "3rd Level",
      "4th Level",
      "5th Level",
      "6th Level",
      "7th Level",
      "8th Level",
      "9th Level"
    ];
    for (String levelKey in levelOrder) {
      combinedSpellsByLevel[levelKey] = [];
    }
    // For each class, add spells into the combined map.
    for (String className in classOptions) {
      Map<String, List<String>> classMap = allSpells[className] ?? {};
      classMap.forEach((levelKey, spells) {
        for (String spell in spells) {
          List<CombinedSpell> list = combinedSpellsByLevel[levelKey]!;
          int index = list.indexWhere((cs) => cs.name == spell);
          if (index != -1) {
            if (!list[index].classes.contains(className)) {
              list[index].classes.add(className);
            }
          } else {
            list.add(CombinedSpell(name: spell, classes: [className]));
          }
        }
      });
    }
    // Sort spells alphabetically for each level.
    for (String levelKey in levelOrder) {
      combinedSpellsByLevel[levelKey]!.sort((a, b) => a.name.compareTo(b.name));
    }
  }

  /// Retrieves a spell's description (caching it if needed).
  Future<String> _getSpellDescription(String spellName) async {
    if (_spellDescriptionCache.containsKey(spellName)) {
      return _spellDescriptionCache[spellName]!;
    }
    String? desc = await SpellService.getSpellDescription(spellName);
    String finalDesc = desc ?? 'No description available.';
    _spellDescriptionCache[spellName] = finalDesc;
    return finalDesc;
  }

  /// Extracts the school from the description.
  String _getSchool(String description) {
    List<String> lines = description
        .split('\n')
        .map((l) => l.replaceAll('*', '').trim())
        .toList();
    return lines.firstWhere(
      (line) => line.toLowerCase().startsWith('school:'),
      orElse: () => '',
    );
  }

  /// Shows an info dialog with the spell description.
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
              child: _buildFormattedDescription(description)),
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

  /// Formats the spell description into styled widgets.
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
                        color: Colors.white),
                  ),
                  TextSpan(
                    text: detail,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
          );
        } else {
          lineWidgets.add(Text(cleanLine,
              style: const TextStyle(fontSize: 14, color: Colors.white)));
        }
      } else {
        lineWidgets.add(Text(cleanLine,
            style: const TextStyle(fontSize: 14, color: Colors.white)));
      }
      lineWidgets.add(const SizedBox(height: 8));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: lineWidgets);
  }

  /// Extracts a brief summary from the spell description.
  String _buildSummary(String description) {
    List<String> lines = description
        .split('\n')
        .map((line) => line.replaceAll('*', '').trim())
        .toList();
    String schoolInfo = lines.firstWhere(
        (line) => line.toLowerCase().startsWith('school:'),
        orElse: () => '');
    String classInfo = lines.firstWhere(
        (line) => line.toLowerCase().startsWith('class:'),
        orElse: () => '');
    String rangeInfo = lines.firstWhere(
        (line) => line.toLowerCase().startsWith('range:'),
        orElse: () => '');
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

  /// Builds the spell tile for a CombinedSpell.
  Widget _buildTile(CombinedSpell cs, String summary, String school) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.grey[850],
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.wandMagic,
            color: Theme.of(context).iconTheme.color),
        title: Text(
          cs.name,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (school.isNotEmpty)
              Text(
                school,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            Text(summary,
                style: const TextStyle(fontSize: 12, color: Colors.white)),
            Text("Classes: ${cs.classes.join(', ')}",
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.info_outline,
              color: Theme.of(context).iconTheme.color),
          onPressed: () {
            _showSpellInfoDialog(context, cs.name);
          },
        ),
        onTap: () {},
      ),
    );
  }

  /// Builds a spell tile using FutureBuilder to load description if needed.
  Widget buildSpellTile(CombinedSpell cs) {
    if (_spellDescriptionCache.containsKey(cs.name)) {
      String description = _spellDescriptionCache[cs.name]!;
      String summary = _buildSummary(description);
      String school = _getSchool(description);
      return _buildTile(cs, summary, school);
    } else {
      return FutureBuilder<String>(
        future: _getSpellDescription(cs.name),
        builder: (context, snapshot) {
          String summary = 'Loading description...';
          String school = '';
          if (snapshot.hasData) {
            String description = snapshot.data!;
            summary = _buildSummary(description);
            school = _getSchool(description);
          }
          return _buildTile(cs, summary, school);
        },
      );
    }
  }

  /// Filters a list of CombinedSpell objects based on search query and selected filters.
  Future<List<CombinedSpell>> filterCombinedSpells(
      List<CombinedSpell> spells) async {
    List<CombinedSpell> filtered = [];
    for (var cs in spells) {
      // Filter by spell name.
      if (searchQuery.isNotEmpty &&
          !cs.name.toLowerCase().contains(searchQuery.toLowerCase())) continue;
      // Class filter (case-insensitive).
      if (selectedClasses.isNotEmpty) {
        final lowerSelected =
            selectedClasses.map((e) => e.toLowerCase()).toSet();
        final lowerSpellClasses =
            cs.classes.map((e) => e.toLowerCase()).toSet();
        if (lowerSpellClasses.intersection(lowerSelected).isEmpty) continue;
      }
      // Get description for additional filtering.
      String description = await _getSpellDescription(cs.name);
      // School filtering.
      if (selectedSchools.isNotEmpty) {
        bool matchesSchool = selectedSchools
            .any((s) => description.toLowerCase().contains(s.toLowerCase()));
        if (!matchesSchool) continue;
      }
      // Type filtering.
      if (selectedTypes.isNotEmpty) {
        bool matchesType = selectedTypes.any((type) {
          if (type == 'Damage') {
            return description.toLowerCase().contains('damage');
          } else if (type == 'Utility') {
            return !description.toLowerCase().contains('damage');
          }
          return false;
        });
        if (!matchesType) continue;
      }
      // Range filtering.
      if (selectedRanges.isNotEmpty) {
        bool matchesRange = selectedRanges.any((range) {
          if (range == 'Touch') {
            return description.toLowerCase().contains('touch');
          } else if (range == 'Self') {
            return description.toLowerCase().contains('self');
          } else if (range == 'Range') {
            return !(description.toLowerCase().contains('touch') ||
                description.toLowerCase().contains('self'));
          }
          return false;
        });
        if (!matchesRange) continue;
      }
      filtered.add(cs);
    }
    return filtered;
  }

  Future<void> _showFilterModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filter Options',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        const Text('School of Magic',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        ...schoolOptions.map((school) {
                          return SwitchListTile(
                            title: Text(school,
                                style: const TextStyle(color: Colors.white)),
                            value: selectedSchools.contains(school),
                            onChanged: (bool value) {
                              modalSetState(() {
                                value
                                    ? selectedSchools.add(school)
                                    : selectedSchools.remove(school);
                              });
                            },
                          );
                        }).toList(),
                        const Divider(color: Colors.white70),
                        const Text('Type',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        ...typeOptions.map((type) {
                          return SwitchListTile(
                            title: Text(type,
                                style: const TextStyle(color: Colors.white)),
                            value: selectedTypes.contains(type),
                            onChanged: (bool value) {
                              modalSetState(() {
                                value
                                    ? selectedTypes.add(type)
                                    : selectedTypes.remove(type);
                              });
                            },
                          );
                        }).toList(),
                        const Divider(color: Colors.white70),
                        const Text('Range',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        ...rangeOptions.map((range) {
                          return SwitchListTile(
                            title: Text(range,
                                style: const TextStyle(color: Colors.white)),
                            value: selectedRanges.contains(range),
                            onChanged: (bool value) {
                              modalSetState(() {
                                value
                                    ? selectedRanges.add(range)
                                    : selectedRanges.remove(range);
                              });
                            },
                          );
                        }).toList(),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the modal
                            },
                            style: ButtonStyle(
                                backgroundColor: Theme.of(context)
                                    .elevatedButtonTheme
                                    .style!
                                    .backgroundColor),
                            child: const Text('Done',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );

    // Trigger a rebuild after the modal is closed
    setState(() {});
  }

  Future<void> _showClassFilterModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return DraggableScrollableSheet(
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filter by Class',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        ...classOptions.map((className) {
                          return SwitchListTile(
                            title: Text(className,
                                style: const TextStyle(color: Colors.white)),
                            value: selectedClasses.contains(className),
                            onChanged: (bool value) {
                              modalSetState(() {
                                value
                                    ? selectedClasses.add(className)
                                    : selectedClasses.remove(className);
                              });
                            },
                          );
                        }).toList(),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the modal
                            },
                            style: ButtonStyle(
                                backgroundColor: Theme.of(context)
                                    .elevatedButtonTheme
                                    .style!
                                    .backgroundColor),
                            child: const Text('Apply Filters', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );

    // Trigger a rebuild after the modal is closed
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadAllSpells();
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

  /// The main build method.
  /// A styled search bar is at the top and spells are shown by level.
  @override
  Widget build(BuildContext context) {
    List<String> levelOrder = [
      "Cantrips (0 Level)",
      "1st Level",
      "2nd Level",
      "3rd Level",
      "4th Level",
      "5th Level",
      "6th Level",
      "7th Level",
      "8th Level",
      "9th Level"
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Spell Compendium',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[900],
        leading: widget.inSession
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back if inSession is true
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              )
            : IconButton(
                onPressed: () {}, // Invisible button with no action
                icon: const SizedBox.shrink(),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: _showClassFilterModal,
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: _showFilterModal,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Show loading circle
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : Column(
                  children: [
                    // Styled Search Bar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Spells',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    // Expanded list of spells by level.
                    Expanded(
                      child: ListView.builder(
                        itemCount: levelOrder.length,
                        itemBuilder: (context, levelIndex) {
                          String levelKey = levelOrder[levelIndex];
                          List<CombinedSpell> spells =
                              combinedSpellsByLevel[levelKey] ?? [];
                          return FutureBuilder<List<CombinedSpell>>(
                            future: filterCombinedSpells(spells),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              List<CombinedSpell> filteredSpells =
                                  snapshot.data!;
                              if (filteredSpells.isEmpty)
                                return const SizedBox.shrink();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      levelKey,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: filteredSpells.length,
                                    itemBuilder: (context, spellIndex) {
                                      return buildSpellTile(
                                          filteredSpells[spellIndex]);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}