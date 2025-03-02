import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  int allowedSpells = 0;
  int allowedCantrips = 0;

  List<String> availableSpells = [];
  List<String> availableCantrips = [];

  Set<String> selectedSpells = {};
  Set<String> selectedCantrips = {};

  bool isLoading = true;
  String errorMessage = '';

  // Custom color for icons and accents.
  final Color customColor = const Color.fromARGB(255, 138, 28, 20);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// Loads allowed counts from the class table and the available spells.
  Future<void> loadData() async {
    try {
      // Use characterClass from the provider.
      final characterClass = ref.read(characterProvider).characterClass;
      if (characterClass == null) {
        setState(() {
          errorMessage = 'No class selected.';
          isLoading = false;
        });
        return;
      }

      // Load class data from classes.json.
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

      // Assume the table is stored under "The <characterClass>" (e.g. "The Sorcerer").
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
      // For a 1st-level character, use index 0.
      allowedSpells = int.tryParse((table["Spells Known"]?[0] ?? "0").toString()) ?? 0;
      allowedCantrips = int.tryParse((table["Cantrips Known"]?[0] ?? "0").toString()) ?? 0;

      // Explicitly load cantrips and 1st-level spells.
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

  /// Fetches the full spell description from the "Spell Descriptions" section.
  Future<String> _getSpellDescription(String spellName) async {
    String? desc = await SpellService.getSpellDescription(spellName);
    return desc ?? 'No description available.';
  }

  /// Shows a nicely formatted dialog with full spell details.
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

  /// Formats the spell description:
  /// - Removes all asterisks.
  /// - Splits lines and, if a line contains a colon, formats the header bold and a bit larger.
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

  /// Builds a styled spell tile with an info icon.
  Widget buildSpellTile(String spellName, bool isCantrip) {
    bool isSelected = isCantrip
        ? selectedCantrips.contains(spellName)
        : selectedSpells.contains(spellName);
    return FutureBuilder<String>(
      future: _getSpellDescription(spellName),
      builder: (context, snapshot) {
        String summary = snapshot.hasData
            ? snapshot.data!.split('\n').take(3).join('\n')
            : 'Loading description...';
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          color: Colors.grey[850],
          child: ListTile(
            leading: const FaIcon(FontAwesomeIcons.magic, color: Color.fromARGB(255, 138, 28, 20)),
            title: Text(
              spellName,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            subtitle: Text(
              summary,
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.info_outline, color: customColor),
                  onPressed: () {
                    _showSpellInfoDialog(context, spellName);
                  },
                ),
                isSelected
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.add_circle_outline, color: Color.fromARGB(255, 138, 28, 20)),
              ],
            ),
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
                        SnackBar(content: Text('You can only select $allowedCantrips cantrips.', style: const TextStyle(color: Colors.white))),
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
                        SnackBar(content: Text('You can only select $allowedSpells spells.', style: const TextStyle(color: Colors.white))),
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

  @override
  Widget build(BuildContext context) {
    final characterClass = ref.watch(characterProvider).characterClass ?? 'Unknown Class';
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('$characterClass Spell Selection', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.white)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cantrips Section.
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
                        itemCount: availableCantrips.length,
                        itemBuilder: (context, index) {
                          return buildSpellTile(availableCantrips[index], true);
                        },
                      ),
                      const SizedBox(height: 20),
                      // 1st Level Spells Section.
                      Text(
                        '1st Level Spells (Select $allowedSpells)',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'Selected: ${selectedSpells.length} / $allowedSpells',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Divider(color: Colors.white70),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: availableSpells.length,
                        itemBuilder: (context, index) {
                          return buildSpellTile(availableSpells[index], false);
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            
                          ),
                          onPressed: (selectedCantrips.length == allowedCantrips &&
                                  selectedSpells.length == allowedSpells)
                              ? () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Spell selection confirmed!', style: TextStyle(color: Colors.white))),
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
                ),
    );
  }
}

