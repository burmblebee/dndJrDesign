import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  // Custom color used throughout the screen.
  final Color customColor = const Color.fromARGB(255, 138, 28, 20);

  // Controller for spell search field.
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  ///////////// FILTER STATES FOR MULTI-SELECTION /////////////
  Set<String> selectedSchools = {}; // Holds selected magic schools.
  Set<String> selectedTypes = {};   // Holds selected spell types (Damage, Utility).
  Set<String> selectedRanges = {};  // Holds selected spell ranges (Range, Touch, Self).

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
  /// Loads class and spell data based on the selected character class.
  Future<void> loadData() async {
    try {
      // Get the character's class from the provider.
      final characterClass = ref.read(characterProvider).characterClass;
      if (characterClass == null) {
        setState(() {
          errorMessage = 'No class selected.';
          isLoading = false;
        });
        return;
      }

      // Load class details from ClassService.
      final classData = await ClassService.getClassData(characterClass);
      if (classData == null) {
        setState(() {
          errorMessage = 'No class data found for $characterClass.';
          isLoading = false;
        });
        return;
      }

      // Extract class features and table data.
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
      allowedSpells = int.tryParse((table["Spells Known"]?[0] ?? "0").toString()) ?? 0;
      allowedCantrips = int.tryParse((table["Cantrips Known"]?[0] ?? "0").toString()) ?? 0;

      // Load available cantrips and spells using SpellService.
      availableCantrips = await SpellService.getSpellsByClass('$characterClass Spells', 'Cantrips (0 Level)');
      availableSpells = await SpellService.getSpellsByClass('$characterClass Spells', '1st Level');

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
  /// Retrieves the full description of a spell.
  Future<String> _getSpellDescription(String spellName) async {
    String? desc = await SpellService.getSpellDescription(spellName);
    return desc ?? 'No description available.';
  }

  /// Displays a dialog with detailed spell information.
  Future<void> _showSpellInfoDialog(BuildContext context, String spellName) async {
    String description = await _getSpellDescription(spellName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            spellName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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

  /// Formats a spell's description by removing asterisks and highlighting headers.
  Widget _buildFormattedDescription(String description) {
    List<Widget> lineWidgets = [];
    // Split the description into lines and format each line.
    for (var line in description.split('\n')) {
      // Remove all asterisks and trim spaces.
      String cleanLine = line.replaceAll('*', '').trim();
      if (cleanLine.isEmpty) continue;
      // If the line contains a colon, bold the header part.
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

  ///////////// SPELL TILE BUILDING SECTION /////////////
  /// Builds each spell's list tile widget.
  /// This version extracts and shows School, Class, and Range info.
  Widget buildSpellTile(String spellName, bool isCantrip) {
    bool isSelected = isCantrip
        ? selectedCantrips.contains(spellName)
        : selectedSpells.contains(spellName);
    return FutureBuilder<String>(
      future: _getSpellDescription(spellName),
      builder: (context, snapshot) {
        String summary = 'Loading description...';
        if (snapshot.hasData) {
          // Process the spell description: remove asterisks and break into lines.
          List<String> lines = snapshot.data!
              .split('\n')
              .map((line) => line.replaceAll('*', '').trim())
              .toList();
          // Extract School, Class, and Range info from the description.
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
          summary = infoParts.join(' | ');
          // If no info was found, fall back to the first three lines.
          if (summary.isEmpty) {
            summary = snapshot.data!.split('\n').take(3).join('\n');
          }
        }
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: Colors.grey[850],
          child: ListTile(
            // Leading magic icon.
            leading: const FaIcon(FontAwesomeIcons.magic, color: Color.fromARGB(255, 138, 28, 20)),
            title: Text(
              spellName,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            // Subtitle now shows School, Class, and Range.
            subtitle: Text(
              summary,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Info icon to show full details.
                IconButton(
                  icon: Icon(Icons.info_outline, color: customColor),
                  onPressed: () {
                    _showSpellInfoDialog(context, spellName);
                  },
                ),
                // Toggle selection icon.
                isSelected
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.add_circle_outline, color: Color.fromARGB(255, 138, 28, 20)),
              ],
            ),
            // Tapping toggles the spell selection.
            onTap: () {
              setState(() {
                if (isCantrip) {
                  if (isSelected) {
                    selectedCantrips.remove(spellName);
                  } else {
                    if (selectedCantrips.length < allowedCantrips) {
                      selectedCantrips.add(spellName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You can only select $allowedCantrips cantrips.',
                              style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    }
                  }
                } else {
                  if (isSelected) {
                    selectedSpells.remove(spellName);
                  } else {
                    if (selectedSpells.length < allowedSpells) {
                      selectedSpells.add(spellName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('You can only select $allowedSpells spells.',
                              style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    }
                  }
                }
              });
            },
          ),
        );
      },
    );
  }

  ///////////// SPELL FILTERING SECTION /////////////
  /// Filters spells based on the search query and multi‑selection filters.
  Future<List<String>> filterSpells(List<String> spells) async {
    List<String> filteredSpells = [];
    for (String spell in spells) {
      String description = await _getSpellDescription(spell);
      // Apply search filter.
      if (searchQuery.isNotEmpty && !spell.toLowerCase().contains(searchQuery.toLowerCase())) {
        continue;
      }
      // Apply School filter (if any school is selected).
      if (selectedSchools.isNotEmpty) {
        bool matchesSchool = selectedSchools.any(
          (school) => description.toLowerCase().contains(school.toLowerCase()),
        );
        if (!matchesSchool) continue;
      }
      // Apply Type filter.
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
      // Apply Range filter.
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
  /// Updates parent state from within modal.
  void updateParentState() {
    setState(() {});
  }

  /// Displays a bottom sheet modal with multi‑selection switches for filters.
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
                    ////////////// FILTER HEADER //////////////
                    const Text('Filter Options',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ////////////// SCHOOL FILTERS //////////////
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('School of Magic', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    ...schoolOptions.map((school) {
                      return SwitchListTile(
                        title: Text(school, style: const TextStyle(color: Colors.white)),
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
                    ////////////// TYPE FILTERS //////////////
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Type', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    ...typeOptions.map((type) {
                      return SwitchListTile(
                        title: Text(type, style: const TextStyle(color: Colors.white)),
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
                    ////////////// RANGE FILTERS //////////////
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Range', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    ...rangeOptions.map((range) {
                      return SwitchListTile(
                        title: Text(range, style: const TextStyle(color: Colors.white)),
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
                        backgroundColor: MaterialStateProperty.all<Color>(customColor),
                      ),
                      child: const Text('Done', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    // Update the state after the modal is closed.
    setState(() {});
  }

  ///////////// BUILD METHOD & UI SECTION /////////////
  @override
  Widget build(BuildContext context) {
    final characterClass = ref.watch(characterProvider).characterClass ?? 'Unknown Class';
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('$characterClass Spell Selection', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        actions: [
          // Icon button to open the filter modal.
          IconButton(
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: _showFilterModal,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.white)))
              : Column(
                  children: [
                    ////////////// SEARCH FIELD //////////////
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Spells',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    ////////////// SPELL LISTS //////////////
                    Expanded(
                      child: FutureBuilder<List<String>>(
                        future: filterSpells(availableCantrips),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                          } else {
                            final filteredCantrips = snapshot.data ?? [];
                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ////////////// CANTRIPS SECTION //////////////
                                  Text(
                                    'Cantrips (Select $allowedCantrips)',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Text(
                                    'Selected: ${selectedCantrips.length} / $allowedCantrips',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const Divider(color: Colors.white70),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: filteredCantrips.length,
                                    itemBuilder: (context, index) {
                                      return buildSpellTile(filteredCantrips[index], true);
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  ////////////// 1ST LEVEL SPELLS SECTION //////////////
                                  Text(
                                    '1st Level Spells (Select $allowedSpells)',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Text(
                                    'Selected: ${selectedSpells.length} / $allowedSpells',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const Divider(color: Colors.white70),
                                  FutureBuilder<List<String>>(
                                    future: filterSpells(availableSpells),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                                      } else {
                                        final filteredSpells = snapshot.data ?? [];
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: filteredSpells.length,
                                          itemBuilder: (context, index) {
                                            return buildSpellTile(filteredSpells[index], false);
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  ////////////// CONFIRM SELECTION BUTTON //////////////
                                  Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all<Color>(customColor),
                                      ),
                                      onPressed: (selectedCantrips.length == allowedCantrips &&
                                              selectedSpells.length == allowedSpells)
                                          ? () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                    content: Text('Spell selection confirmed!',
                                                        style: TextStyle(color: Colors.white))),
                                              );
                                              ref.read(characterProvider.notifier).updateSpells({
                                                'cantrips': selectedCantrips.toList(),
                                                'spells': selectedSpells.toList(),
                                              });
                                              Navigator.pop(context);
                                            }
                                          : null,
                                      child: const Text('Confirm Selection', style: TextStyle(color: Colors.white)),
                                    ),
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
