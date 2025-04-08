import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Model class for a Monster.
class Monster {
  final String name;
  final String challengeRating;
  final List<dynamic> content;
  final String size;
  final String type;
  final double crValue;

  Monster({
    required this.name,
    required this.challengeRating,
    required this.content,
    required this.size,
    required this.type,
    required this.crValue,
  });
}

/// Main widget for the Monster Compendium screen.
class MonsterCompendium extends StatefulWidget {
  const MonsterCompendium({Key? key}) : super(key: key);

  @override
  _MonsterCompendiumState createState() => _MonsterCompendiumState();
}

class _MonsterCompendiumState extends State<MonsterCompendium> {
  bool isLoading = true;
  String errorMessage = '';
  List<Monster> allMonsters = [];
  List<Monster> displayedMonsters = [];
  final TextEditingController _searchController = TextEditingController();

  // Filters for size, type, and challenge rating.
  Set<String> selectedSizes = {};
  Set<String> selectedTypes = {};
  Set<String> selectedChallengeRatings = {};

  // Define some heading keywords (optional).
  final Set<String> headingKeywords = {
    'Armor Class',
    'Hit Points',
    'Speed',
    'STR',
    'DEX',
    'CON',
    'INT',
    'WIS',
    'CHA',
    'Skills',
    'Senses',
    'Languages',
    'Damage Resistances',
    'Damage Immunities',
    'Condition Immunities',
    'Saving Throws',
    'Challenge'
  };

  @override
  void initState() {
    super.initState();
    loadMonsters();
    _searchController.addListener(applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Helper function that returns only the last segment of the full monster name.
  String getLastSegment(String name) {
    if (!name.contains('->')) {
      return name;
    }
    final parts = name.split('->');
    return parts.last.trim();
  }

  /// Recursively processes a monster group map.
  /// [monsterMap] is the current level in the JSON structure.
  /// [prefix] accumulates the nested keys (e.g., "Dragons, Metallic -> Silver Dragon").
  /// [accumulator] collects all the monsters found.
  void processMonsterMap(
      Map<String, dynamic> monsterMap, String prefix, List<Monster> accumulator) {
    monsterMap.forEach((key, value) {
      String fullName = prefix.isEmpty ? key : "$prefix -> $key";
      if (value is Map) {
        // Cast nested map keys to String.
        Map<String, dynamic> nestedMap = Map<String, dynamic>.from(value);
        if (nestedMap.containsKey('content') && nestedMap['content'] is List<dynamic>) {
          List<dynamic> contentList = nestedMap['content'];
          String cr = extractChallengeRating(contentList);
          double crValue = parseCR(cr);
          String size = extractSize(contentList);
          String type = extractType(contentList);
          accumulator.add(Monster(
            name: fullName,
            challengeRating: cr,
            content: contentList,
            size: size,
            type: type,
            crValue: crValue,
          ));
        } else {
          // Recurse into nested groups.
          processMonsterMap(nestedMap, fullName, accumulator);
        }
      }
    });
  }

  /// Loads the monsters JSON, processing each monster group (keys starting with "Monsters (")
  /// while skipping sections like "Legendary Creatures".
  Future<void> loadMonsters() async {
    try {
      String jsonString = await rootBundle.loadString('lib/data/SRD Data/monsters.json');
      Map<String, dynamic> data = json.decode(jsonString);
      Map<String, dynamic> monstersData = Map<String, dynamic>.from(data['Monsters']);
      List<Monster> temp = [];

      // Process only keys that represent monster groups (e.g., "Monsters (A)", "Monsters (B)", etc.)
      monstersData.forEach((groupKey, groupValue) {
        if (groupKey.startsWith("Monsters (") && groupValue is Map) {
          Map<String, dynamic> groupMap = Map<String, dynamic>.from(groupValue);
          processMonsterMap(groupMap, "", temp);
        }
      });

      // Sort monsters by challenge rating (crValue) in ascending order.
      temp.sort((a, b) => a.crValue.compareTo(b.crValue));

      setState(() {
        allMonsters = temp;
        displayedMonsters = List.from(allMonsters);
        isLoading = false;
      });

      // Print the list of all monsters to the console
      for (var monster in allMonsters) {
        print('Name: ${monster.name}, CR: ${monster.challengeRating}, Size: ${monster.size}, Type: ${monster.type}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading monsters: $e';
        isLoading = false;
      });
      print('Error loading monsters: $e');
    }
  }

  /// Searches the content list for a string containing '**Challenge**'
  /// and returns the cleaned challenge rating.
  String extractChallengeRating(List<dynamic> contentList) {
    for (var item in contentList) {
      if (item is String && item.contains('**Challenge**')) {
        String cleaned = item.replaceAll('*', '').trim();
        int index = cleaned.indexOf('Challenge');
        if (index != -1) {
          String crText = cleaned.substring(index + "Challenge".length).trim().split(' ').first;
          return crText;
        }
      }
    }
    return '';
  }

  /// Parses a challenge rating string (handles fractions like "1/4") and returns a double.
  double parseCR(String crText) {
    if (crText.contains('/')) {
      List<String> parts = crText.split('/');
      if (parts.length == 2) {
        double? numerator = double.tryParse(parts[0]);
        double? denominator = double.tryParse(parts[1]);
        if (numerator != null && denominator != null && denominator != 0) {
          return numerator / denominator;
        }
      }
    }
    return double.tryParse(crText) ?? 0.0;
  }

  /// Extracts the size from the first content line.
  String extractSize(List<dynamic> contentList) {
    if (contentList.isNotEmpty && contentList[0] is String) {
      String line = contentList[0].replaceAll('*', '').trim();
      List<String> parts = line.split(' ');
      if (parts.isNotEmpty) return parts[0];
    }
    return '';
  }

  /// Extracts the type from the first content line.
  String extractType(List<dynamic> contentList) {
    if (contentList.isNotEmpty && contentList[0] is String) {
      String line = contentList[0].replaceAll('*', '').trim();
      List<String> parts = line.split(' ');
      if (parts.length >= 2) {
        return parts[1].replaceAll(',', '');
      }
    }
    return '';
  }

  /// Simple function to remove markdown characters like asterisks or inline links.
  String cleanText(String text) {
    return text
        .replaceAll('*', '')
        .replaceAll(RegExp(r'\[.*?\]'), '')
        .trim();
  }

  /// Decide if a line should be styled as a "heading" based on known keywords.
  bool isHeadingLine(String line) {
    for (final keyword in headingKeywords) {
      // If line starts with the keyword, we treat it as a heading.
      if (line.startsWith(keyword)) {
        return true;
      }
    }
    return false;
  }

  /// Main method to build a widget for each content item in the monster's stat block.
  Widget buildContentWidget(dynamic item) {
    // Base text styles:
    const TextStyle defaultStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      height: 1.3, // increases line spacing
    );

    const TextStyle headingStyle = TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.bold,
      height: 1.4,
    );

    if (item is String) {
      // Clean and check if it should be styled as a heading
      final line = cleanText(item);
      final textStyle = isHeadingLine(line) ? headingStyle : defaultStyle;

      return Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Text(line, style: textStyle),
      );
    } 
    else if (item is Map && item.containsKey('table')) {
      // Build a styled table.
      Map<String, dynamic> table = Map<String, dynamic>.from(item['table']);
      List<String> columns = table.keys.toList();

      // Define table text styles
      const TextStyle headerStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 16,
      );
      const TextStyle cellStyle = TextStyle(
        color: Colors.white,
        fontSize: 16,
      );

      // Build rows: one header row + one data row
      List<TableRow> rows = [
        TableRow(
          children: columns.map((col) {
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(col, style: headerStyle),
            );
          }).toList(),
        ),
        TableRow(
          children: columns.map((col) {
            List<dynamic> values = table[col];
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                values.join(', '),
                style: cellStyle,
              ),
            );
          }).toList(),
        )
      ];

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white54),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Table(
          border: TableBorder.all(color: Colors.white54),
          children: rows,
        ),
      );
    }

    // Fallback for other data structures (if any).
    return const SizedBox.shrink();
  }

  /// Shows a dialog with the full stat block for a monster.
  void showMonsterInfo(Monster monster) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            getLastSegment(monster.name),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: monster.content
                  .map<Widget>((item) => buildContentWidget(item))
                  .toList(),
            ),
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

  /// Applies search and filter options to update the displayed monster list.
  void applyFilters() {
    String query = _searchController.text.toLowerCase();
    List<Monster> filtered = allMonsters.where((monster) {
      bool matchesSearch = monster.name.toLowerCase().contains(query) ||
          monster.challengeRating.toLowerCase().contains(query);
      bool matchesSize = selectedSizes.isEmpty || selectedSizes.contains(monster.size);
      bool matchesType = selectedTypes.isEmpty || selectedTypes.contains(monster.type);
      bool matchesCR = selectedChallengeRatings.isEmpty ||
          selectedChallengeRatings.contains(monster.challengeRating);
      return matchesSearch && matchesSize && matchesType && matchesCR;
    }).toList();

    // Sort filtered list in ascending order by challenge rating.
    filtered.sort((a, b) => a.crValue.compareTo(b.crValue));

    setState(() {
      displayedMonsters = filtered;
    });
  }

  /// Opens a filter modal for selecting sizes, types, and challenge ratings.
  Future<void> _showFilterModal() async {
    // Filter out "A" from sizes.
    List<String> availableSizes = allMonsters
        .map((m) => m.size)
        .toSet()
        .where((size) => size != "A")
        .toList()
      ..sort();
    // Filter out blank and "0" challenge ratings.
    List<String> availableCR = allMonsters
        .map((m) => m.challengeRating)
        .toSet()
        .where((cr) => cr.isNotEmpty && cr != "0")
        .toList()
      ..sort((a, b) => parseCR(a).compareTo(parseCR(b)));
    List<String> availableTypes = allMonsters
        .map((m) => m.type)
        .toSet()
        .toList()
      ..sort();

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
                        // "Filter Options" heading
                        const Text(
                          'Filter Options',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Sizes
                        const Text(
                          'Sizes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...availableSizes.map((size) {
                          return CheckboxListTile(
                            activeColor: Colors.deepOrangeAccent,
                            checkColor: Colors.white,
                            title: Text(size, style: const TextStyle(color: Colors.white)),
                            value: selectedSizes.contains(size),
                            onChanged: (bool? value) {
                              modalSetState(() {
                                if (value == true) {
                                  selectedSizes.add(size);
                                } else {
                                  selectedSizes.remove(size);
                                }
                              });
                            },
                          );
                        }).toList(),
                        const Divider(color: Colors.white70),

                        // Types
                        const Text(
                          'Types',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...availableTypes.map((type) {
                          return CheckboxListTile(
                            activeColor: Colors.deepOrangeAccent,
                            checkColor: Colors.white,
                            title: Text(type, style: const TextStyle(color: Colors.white)),
                            value: selectedTypes.contains(type),
                            onChanged: (bool? value) {
                              modalSetState(() {
                                if (value == true) {
                                  selectedTypes.add(type);
                                } else {
                                  selectedTypes.remove(type);
                                }
                              });
                            },
                          );
                        }).toList(),
                        const Divider(color: Colors.white70),

                        // Challenge Ratings
                        const Text(
                          'Challenge Ratings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...availableCR.map((cr) {
                          return CheckboxListTile(
                            activeColor: Colors.deepOrangeAccent,
                            checkColor: Colors.white,
                            title: Text(cr, style: const TextStyle(color: Colors.white)),
                            value: selectedChallengeRatings.contains(cr),
                            onChanged: (bool? value) {
                              modalSetState(() {
                                if (value == true) {
                                  selectedChallengeRatings.add(cr);
                                } else {
                                  selectedChallengeRatings.remove(cr);
                                }
                              });
                            },
                          );
                        }).toList(),
                        const SizedBox(height: 16),

                        // Apply Filters Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              applyFilters();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Apply Filters'),
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
    ).then((_) {
      // Update filters after the modal is closed (in case of dismiss without tapping Apply).
      applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Monster Compendium'),
        backgroundColor: Colors.grey[850],
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
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.white)))
              : Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Monsters',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    // Monster List
                    Expanded(
                      child: ListView.builder(
                        itemCount: displayedMonsters.length,
                        itemBuilder: (context, index) {
                          Monster monster = displayedMonsters[index];
                          return Card(
                            color: Colors.grey[800],
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: ListTile(
                              // Only show the last segment of the monster name.
                              title: Text(
                                getLastSegment(monster.name),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'CR ${monster.challengeRating} - ${monster.size} ${monster.type}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outline, color: Colors.white),
                                onPressed: () => showMonsterInfo(monster),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
