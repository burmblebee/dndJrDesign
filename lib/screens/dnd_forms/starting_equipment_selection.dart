import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/widgets/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/equipment_selection.dart';
import 'package:warlocks_of_the_beach/providers/character_provider.dart';

class StartingEquipmentSelection extends ConsumerStatefulWidget {
  const StartingEquipmentSelection({Key? key}) : super(key: key);

  @override
  _StartingEquipmentSelectionState createState() =>
      _StartingEquipmentSelectionState();
}

class _StartingEquipmentSelectionState extends ConsumerState<StartingEquipmentSelection> {
  // Equipment options based on D&D 2024 starting equipment rules.
  final Map<String, Map<String, List<String>>> equipmentOptions = {
    'Wizard': {
      'A': [
        "2 Daggers",
        "Arcane Focus (Quarterstaff)",
        "Robe",
        "Spellbook",
        "Scholar’s Pack",
        "5 GP"
      ],
      'B': ["55 GP"]
    },
    'Fighter': {
      'A': [
        "Chain Mail",
        "Greatsword",
        "Flail",
        "8 Javelins",
        "Dungeoneer’s Pack",
        "4 GP"
      ],
      'B': [
        "Studded Leather Armor",
        "Scimitar",
        "Shortsword",
        "Longbow",
        "20 Arrows",
        "Quiver",
        "Dungeoneer’s Pack",
        "11 GP"
      ],
      'C': [
        "155 GP"
      ]
    },
    'Cleric': {
      'A': [
        "Scale Mail",
        "Mace",
        "Shield",
        "Priest’s Pack"
      ],
      'B': [
        "Chain Mail",
        "Holy Symbol",
        "5 GP"
      ]
    },
    'Barbarian': {
      'A': [
        "Greataxe",
        "4 Handaxes",
        "Explorer’s Pack",
        "15 GP"
      ],
      'B': [
        "75 GP"
      ]
    },
    'Sorcerer': {
      'A': [
        "Spear",
        "2 Daggers",
        "Arcane Focus (crystal)",
        "Dungeoneer’s Pack",
        "28 GP"
      ],
      'B': [
        "50 GP"
      ]
    },
    'Warlock': {
      'A': [
        "Leather Armor",
        "Sickle",
        "2 Daggers",
        "Arcane Focus (orb)",
        "Book (occult lore)",
        "Scholar’s Pack",
        "15 GP"
      ],
      'B': [
        "100 GP"
      ]
    },
    'Bard': {
      'A': [
        "Leather Armor",
        "2 Daggers",
        // Note: We'll replace the placeholder with the actual instrument chosen.
        "Musical Instrument (of your choice)",
        "Entertainer’s Pack",
        "19 GP"
      ],
      'B': [
        "90 GP"
      ]
    },
    'Monk': {
      'A': [
        "Spear",
        "5 Daggers",
        "Artisan’s Tools or Musical Instrument",
        "Explorer’s Pack",
        "11 GP"
      ],
      'B': [
        "50 GP"
      ]
    },
    'Ranger': {
      'A': [
        "Studded Leather Armor",
        "Scimitar",
        "Shortsword",
        "Longbow",
        "20 Arrows",
        "Quiver",
        "Druidic Focus (sprig of mistletoe)",
        "Explorer’s Pack",
        "7 GP"
      ],
      'B': [
        "150 GP"
      ]
    },
    'Paladin': {
      'A': [
        "Chain Mail",
        "Shield",
        "Longsword",
        "6 Javelins",
        "Holy Symbol",
        "Priest’s Pack",
        "9 GP"
      ],
      'B': [
        "150 GP"
      ]
    },
    'Rogue': {
      'A': [
        "Leather Armor",
        "2 Daggers",
        "Shortsword",
        "Shortbow",
        "20 Arrows",
        "Quiver",
        "Thieves’ Tools",
        "Burglar’s Pack",
        "8 GP"
      ],
      'B': [
        "100 GP"
      ]
    },
  };

  // Descriptions for each pack.
  final Map<String, String> packDescriptions = {
    "Scholar’s Pack":
        "Contains a backpack, book of lore, ink and quill, and a small knife for scholarly pursuits.",
    "Dungeoneer’s Pack":
        "Contains a backpack, crowbar, hammer, 10 pitons, 10 torches, 5 days of rations, and 50 feet of hempen rope; ideal for dungeon exploration.",
    "Explorer’s Pack":
        "Contains a backpack, bedroll, mess kit, tinderbox, 10 torches, 10 days of rations, and 50 feet of hempen rope; perfect for adventurers.",
    "Priest’s Pack":
        "Contains a backpack, prayer book, incense (5 sticks), and vestments for religious ceremonies.",
    "Entertainer’s Pack":
        "Contains a backpack, costume, disguise kit, and musical instrument to perform and entertain.",
    "Burglar’s Pack":
        "Contains a backpack, crowbar, hammer, 10 pitons, 10 torches, and 5 days of rations, designed for sneaky operations."
  };

  String? selectedOption;
  // This list is used only to display the selected option.
  List<String> selectedEquipmentDisplay = [];
  // Instrument selection if applicable.
  String? selectedInstrument;
  // List of available instrument options.
  final List<String> instrumentOptions = [
    "Lute",
    "Flute",
    "Violin",
    "Drum",
    "Harp",
    "Trumpet"
  ];

  @override
  void initState() {
    super.initState();
    _loadEquipmentOptions();
  }

  void _loadEquipmentOptions() {
    final character = ref.read(characterProvider);
    final selectedClass = character.characterClass;
    if (equipmentOptions.containsKey(selectedClass)) {
      // Default to Option A.
      selectedOption = 'A';
      selectedEquipmentDisplay =
          List<String>.from(equipmentOptions[selectedClass]!['A']!);
    }
    setState(() {});
  }

  // Return a list of pack names that are in the currently selected equipment display.
  List<String> _getPacksInEquipment() {
    List<String> packs = [];
    for (var item in selectedEquipmentDisplay) {
      if (packDescriptions.containsKey(item)) {
        packs.add(item);
      }
    }
    return packs;
  }

  // Manually determine weapons based on class and selected option.
  List<String> _getWeaponsManually(String selectedClass, String selectedOption) {
    switch (selectedClass) {
      case 'Wizard':
        return (selectedOption == 'A') ? ["Dagger", "Dagger"] : [];
      case 'Fighter':
        if (selectedOption == 'A') return ["Greatsword", "Flail"];
        if (selectedOption == 'B') return ["Scimitar", "Shortsword", "Longbow"];
        return [];
      case 'Cleric':
        return (selectedOption == 'A') ? ["Mace"] : [];
      case 'Barbarian':
        return (selectedOption == 'A')
            ? ["Greataxe", "Handaxe", "Handaxe", "Handaxe", "Handaxe"]
            : [];
      case 'Sorcerer':
        return (selectedOption == 'A') ? ["Spear", "Dagger", "Dagger"] : [];
      case 'Warlock':
        return (selectedOption == 'A') ? ["Sickle", "Dagger", "Dagger"] : [];
      case 'Bard':
        return (selectedOption == 'A') ? ["Dagger", "Dagger"] : [];
      case 'Monk':
        return (selectedOption == 'A')
            ? ["Spear", "Dagger", "Dagger", "Dagger", "Dagger", "Dagger"]
            : [];
      case 'Ranger':
        return (selectedOption == 'A') ? ["Scimitar", "Shortsword", "Longbow"] : [];
      case 'Paladin':
        return (selectedOption == 'A') ? ["Longsword"] : [];
      case 'Rogue':
        return (selectedOption == 'A') ? ["Dagger", "Dagger", "Shortsword", "Shortbow"] : [];
      default:
        return [];
    }
  }

  // Manually determine starting armor.
  String _getArmorManually(String selectedClass, String selectedOption) {
    switch (selectedClass) {
      case 'Wizard':
        return (selectedOption == 'A') ? "Robe" : "";
      case 'Fighter':
        if (selectedOption == 'A') return "Chain Mail";
        if (selectedOption == 'B') return "Studded Leather Armor";
        return "";
      case 'Cleric':
        return (selectedOption == 'A') ? "Scale Mail" : "Chain Mail";
      case 'Barbarian':
        return ""; // Barbarians typically use unarmored defense.
      case 'Sorcerer':
        return "";
      case 'Warlock':
        return (selectedOption == 'A') ? "Leather Armor" : "";
      case 'Bard':
        return (selectedOption == 'A') ? "Leather Armor" : "";
      case 'Monk':
        return "";
      case 'Ranger':
        return (selectedOption == 'A') ? "Studded Leather Armor" : "";
      case 'Paladin':
        return (selectedOption == 'A') ? "Chain Mail" : "";
      case 'Rogue':
        return (selectedOption == 'A') ? "Leather Armor" : "";
      default:
        return "";
    }
  }

  // Manually determine kit/instrument.
  List<String> _getKitAndInstrumentManually(String selectedClass, String selectedOption) {
    switch (selectedClass) {
      case 'Wizard':
        return (selectedOption == 'A') ? ["Scholar’s Pack"] : [];
      case 'Fighter':
        if (selectedOption == 'A' || selectedOption == 'B') return ["Dungeoneer’s Pack"];
        return [];
      case 'Cleric':
        return (selectedOption == 'A') ? ["Priest’s Pack"] : [];
      case 'Barbarian':
        return (selectedOption == 'A') ? ["Explorer’s Pack"] : [];
      case 'Sorcerer':
        return (selectedOption == 'A') ? ["Dungeoneer’s Pack"] : [];
      case 'Warlock':
        return (selectedOption == 'A') ? ["Scholar’s Pack"] : [];
      case 'Bard':
        // Return both the pack and the placeholder for instrument.
        return (selectedOption == 'A')
            ? ["Entertainer’s Pack", "Musical Instrument (of your choice)"]
            : [];
      case 'Monk':
        return (selectedOption == 'A')
            ? ["Explorer’s Pack", "Artisan’s Tools or Musical Instrument"]
            : [];
      case 'Ranger':
        return (selectedOption == 'A') ? ["Explorer’s Pack", "Druidic Focus (sprig of mistletoe)"] : [];
      case 'Paladin':
        return (selectedOption == 'A') ? ["Priest’s Pack"] : [];
      case 'Rogue':
        return (selectedOption == 'A') ? ["Burglar’s Pack"] : [];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final characterNotifier = ref.read(characterProvider.notifier);
    final character = ref.watch(characterProvider);
    final selectedClass = character.characterClass;
    List<String> packsInEquipment = _getPacksInEquipment();

    final screenHeight = MediaQuery.of(context).size.height;

    // Adjusted height to include 40px buffer above BottomNav
    final availableHeight = screenHeight -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        40;

    // Determine if we need to show an instrument selector.
    bool showInstrumentSelector = false;
    final kitInstrumentManual = _getKitAndInstrumentManually(selectedClass, selectedOption ?? '');
    if (kitInstrumentManual.contains("Musical Instrument (of your choice)") ||
        kitInstrumentManual.contains("Artisan’s Tools or Musical Instrument")) {
      showInstrumentSelector = true;
    }

    return Scaffold(
      appBar: MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      body: Stack(
        children: [
          SizedBox(
            height: availableHeight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Starting Equipment", style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 20),
                  if (equipmentOptions.containsKey(selectedClass)) ...[
                    Text("Choose Starting Equipment", style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    // Build radio buttons for each option.
                    Column(
                      children: equipmentOptions[selectedClass]!.entries.map((entry) {
                        return RadioListTile<String>(
                          title: Text("Option ${entry.key}"),
                          value: entry.key,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                              selectedEquipmentDisplay = List<String>.from(equipmentOptions[selectedClass]![value]!);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Text("Selected Equipment (Display Only):", style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 5),
                    ...selectedEquipmentDisplay.map((item) => Text("- $item")),
                    const SizedBox(height: 20),
                    // Display pack descriptions.
                    if (packsInEquipment.isNotEmpty) ...[
                      Text("Pack Descriptions:", style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 5),
                      ...packsInEquipment.map((pack) => Text("$pack: ${packDescriptions[pack]}", style: const TextStyle(fontSize: 14))),
                    ],
                    const SizedBox(height: 20),
                    // If a musical instrument option is present, show the dropdown.
                    if (showInstrumentSelector) ...[
                      Text("Select an Instrument", style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        value: selectedInstrument,
                        hint: const Text("Choose instrument"),
                        items: instrumentOptions
                            .map((instr) => DropdownMenuItem(
                                  value: instr,
                                  child: Text(instr),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedInstrument = val;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ] else ...[
                    Text("No equipment options available for class: $selectedClass"),
                  ],
                  const SizedBox(height: 100), // Add extra space to prevent overlap
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text("Back"),
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Manually determine each field.
                    final weapons = _getWeaponsManually(selectedClass, selectedOption!);
                    final armor = _getArmorManually(selectedClass, selectedOption!);
                    List<String> kitInstrument = _getKitAndInstrumentManually(selectedClass, selectedOption!);
                    // If an instrument selection is expected, replace the placeholder with the selected instrument.
                    if (showInstrumentSelector) {
                      if (kitInstrument.contains("Musical Instrument (of your choice)") && selectedInstrument != null) {
                        int index = kitInstrument.indexOf("Musical Instrument (of your choice)");
                        kitInstrument[index] = selectedInstrument!;
                      } else if (kitInstrument.contains("Artisan’s Tools or Musical Instrument") && selectedInstrument != null) {
                        int index = kitInstrument.indexOf("Artisan’s Tools or Musical Instrument");
                        kitInstrument[index] = selectedInstrument!;
                      }
                    }
                    // Update provider fields.
                    if (armor.isNotEmpty) {
                      ref.read(characterProvider.notifier).updateSelectedArmor(armor);
                    } else {
                      ref.read(characterProvider.notifier).updateSelectedArmor("Robes");
                    }
                    ref.read(characterProvider.notifier).updateSelectedKit(kitInstrument);

                    // Pass the manually determined weapons as initial values for the EquipmentSelection screen.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EquipmentSelection(initialWeapons: weapons),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text("Next"),
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
