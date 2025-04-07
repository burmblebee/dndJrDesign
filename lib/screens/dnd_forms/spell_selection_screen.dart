import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/character_trait_selection.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import '../../services/spell_service.dart';
import '../../services/class_service.dart';
import '../../providers/character_provider.dart';

class SpellSelectionScreen extends ConsumerStatefulWidget {
  const SpellSelectionScreen({Key? key}) : super(key: key);

  @override
  _SpellSelectionScreenState createState() => _SpellSelectionScreenState();
}

class _SpellSelectionScreenState extends ConsumerState<SpellSelectionScreen> {
  ///////////// VARIABLES & STATE /////////////
  int allowedSpells = 0;
  int allowedCantrips = 0;

  List<String> availableSpells = [];
  List<String> availableCantrips = [];

  Set<String> selectedSpells = {};
  Set<String> selectedCantrips = {};

  bool isLoading = true;
  String errorMessage = '';

  // Cache for spell descriptions
  final Map<String, String> _spellDescriptionCache = {};

  // Controller for spell search field.
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  ///////////// FILTER STATES FOR MULTI-SELECTION /////////////
  Set<String> selectedSchools = {}; // Holds selected magic schools.
  Set<String> selectedTypes =
      {}; // Holds selected spell types (Damage, Utility).
  Set<String> selectedRanges =
      {}; // Holds selected spell ranges (Range, Touch, Self).

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

  @override
  void initState() {
    super.initState();
    loadData();
    // Listen to changes in the search field and update the UI.
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

  ///////////// DATA LOADING SECTION /////////////
  Future<void> loadData() async {
    try {
      final characterClass = ref.read(characterProvider).characterClass;
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
      final table = classTable["table"];
      allowedSpells =
          int.tryParse((table["Spells Known"]?[0] ?? "0").toString()) ?? 0;
      allowedCantrips =
          int.tryParse((table["Cantrips Known"]?[0] ?? "0").toString()) ?? 0;

      availableCantrips = await SpellService.getSpellsByClass(
          '$characterClass Spells', 'Cantrips (0 Level)');
      availableSpells = await SpellService.getSpellsByClass(
          '$characterClass Spells', '1st Level');

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
                isSelected
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.add_circle_outline,
                        color: Theme.of(context).iconTheme.color),
              ],
            ),
            onTap: () {
              setState(() {
                if (isCantrip) {
                  if (isSelected) {
                    selectedCantrips.remove(spellName);
                    isSelected = false;
                  } else {
                    if (selectedCantrips.length < allowedCantrips) {
                      selectedCantrips.add(spellName);
                      isSelected = true;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'You can only select $allowedCantrips cantrips.',
                              style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    }
                  }
                } else {
                  if (isSelected) {
                    selectedSpells.remove(spellName);
                    isSelected = false;
                  } else {
                    if (selectedSpells.length < allowedSpells) {
                      selectedSpells.add(spellName);
                      isSelected = true;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'You can only select $allowedSpells spells.',
                            style: const TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      );
                    }
                  }
                }
              });
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

  ///////////// SPELL FILTERING SECTION /////////////
  Future<List<String>> filterSpells(List<String> spells) async {
    List<String> filteredSpells = [];
    for (String spell in spells) {
      String description = await _getSpellDescription(spell);
      if (searchQuery.isNotEmpty &&
          !spell.toLowerCase().contains(searchQuery.toLowerCase())) {
        continue;
      }
      if (selectedSchools.isNotEmpty) {
        bool matchesSchool = selectedSchools.any(
          (school) => description.toLowerCase().contains(school.toLowerCase()),
        );
        if (!matchesSchool) continue;
      }
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
      filteredSpells.add(spell);
    }
    return filteredSpells;
  }

  ///////////// FILTER MODAL SECTION /////////////
  void updateParentState() {
    setState(() {});
  }

  Future<void> _showFilterModal() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Filter Options',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('School of Magic',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    ...schoolOptions.map((school) {
                      return SwitchListTile(
                        title: Text(school,
                            style: const TextStyle(color: Colors.white)),
                        value: selectedSchools.contains(school),
                        onChanged: (bool value) {
                          modalSetState(() {
                            if (value) {
                              selectedSchools.add(school);
                            } else {
                              selectedSchools.remove(school);
                            }
                          });
                          updateParentState();
                        },
                      );
                    }).toList(),
                    const Divider(color: Colors.white70),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Type',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    ...typeOptions.map((type) {
                      return SwitchListTile(
                        title: Text(type,
                            style: const TextStyle(color: Colors.white)),
                        value: selectedTypes.contains(type),
                        onChanged: (bool value) {
                          modalSetState(() {
                            if (value) {
                              selectedTypes.add(type);
                            } else {
                              selectedTypes.remove(type);
                            }
                          });
                          updateParentState();
                        },
                      );
                    }).toList(),
                    const Divider(color: Colors.white70),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Range',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    ...rangeOptions.map((range) {
                      return SwitchListTile(
                        title: Text(range,
                            style: const TextStyle(color: Colors.white)),
                        value: selectedRanges.contains(range),
                        onChanged: (bool value) {
                          modalSetState(() {
                            if (value) {
                              selectedRanges.add(range);
                            } else {
                              selectedRanges.remove(range);
                            }
                          });
                          updateParentState();
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).iconTheme.color!),
                      ),
                      child: const Text('Done',
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    setState(() {});
  }

  ///////////// BUILD METHOD & UI SECTION /////////////
  @override
  Widget build(BuildContext context) {
    final characterClass =
        ref.watch(characterProvider).characterClass ?? 'Unknown Class';
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: MainBottomNavBar(),
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('$characterClass Spell Selection',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: _showFilterModal,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage,
                      style: const TextStyle(color: Colors.white)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Spells',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<String>>(
                        future: filterSpells(availableCantrips),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}',
                                    style:
                                        const TextStyle(color: Colors.white)));
                          } else {
                            final filteredCantrips = snapshot.data ?? [];
                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cantrips (Select $allowedCantrips)',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),

                                  const Divider(color: Colors.white70),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: filteredCantrips.length,
                                    itemBuilder: (context, index) {
                                      return buildSpellTile(
                                          filteredCantrips[index], true);
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    '1st Level Spells (Select $allowedSpells)',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  // Text(
                                  //   'Selected: ${selectedSpells.length} / $allowedSpells',
                                  //   style: const TextStyle(color: Colors.white),
                                  // ),
                                  const Divider(color: Colors.white70),
                                  FutureBuilder<List<String>>(
                                    future: filterSpells(availableSpells),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}',
                                                style: const TextStyle(
                                                    color: Colors.white)));
                                      } else {
                                        final filteredSpells =
                                            snapshot.data ?? [];
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: filteredSpells.length,
                                          itemBuilder: (context, index) {
                                            return buildSpellTile(
                                                filteredSpells[index], false);
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(Icons.arrow_back,
                                            color: Colors.white),
                                        label: const Text("Back"),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          // ref
                                          //     .read(characterProvider.notifier)
                                          //     .updateSpells({
                                          //   'cantrips':
                                          //       selectedCantrips.toList(),
                                          //   'spells': selectedSpells.toList(),
                                          // });
                                          ref.read(characterProvider.notifier).updateSpells(selectedSpells.toList());
                                          ref.read(characterProvider.notifier).updateCantrips(selectedCantrips.toList());
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CharacterTraitScreen(),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.arrow_forward,
                                            color: Colors.white),
                                        label: const Text("Next"),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
