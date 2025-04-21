import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/background_selection.dart';
import 'package:warlocks_of_the_beach/widgets/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import '../../screens/dnd_forms/stats_screen.dart';
import '../../widgets/navigation/main_drawer.dart';
import 'package:flutter/material.dart';
import '../../data/character creator data/background_data.dart';
import '../../data/character creator data/class_data.dart';
import '../../data/character creator data/race_data.dart';
import '../../widgets/buttons/button_with_padding.dart';
import '../../widgets/loaders/language_data_loader.dart';
import '../../widgets/loaders/proficiency_data_loader.dart';
import 'package:warlocks_of_the_beach/providers/character_provider.dart';

class SpecificsScreen extends ConsumerStatefulWidget {
  const SpecificsScreen({super.key});

  @override
  _SpecificsScreenState createState() => _SpecificsScreenState();
}

class _SpecificsScreenState extends ConsumerState<SpecificsScreen> {
  // Full list of possible skills
  final List<String> allProficiencies = [
    'Acrobatics', 'Animal Handling', 'Arcana', 'Athletics', 'Deception',
    'History', 'Insight', 'Intimidation', 'Investigation', 'Medicine',
    'Nature', 'Perception', 'Performance', 'Persuasion', 'Religion',
    'Sleight of Hand', 'Stealth', 'Survival'
  ];
  final List<String> languages = [
    'Undercommon', 'Primordial', 'Deep Speech', 'Celestial', 'Abyssal',
    'Halfling', 'Infernal', 'Dwarvish', 'Gnomish', 'Draconic',
    'Elvish', 'Sylvan', 'Common', 'Goblin', 'Giant', 'Orc',
  ];

  List<String> _possibleProficiencies = [];
  List<String> _selectedProficiencies = [];
  List<String> _givenProficiencies = [];
  List<String> _selectedLanguages = [];
  List<String> _givenLanguages = [];

  late int numberOfProficiencies = 0;
  late int numberOfLanguages = 0;
  String _currentSection = 'Proficiency';

  late String characterName;
  late String characterClass;
  late String background;
  late String race;

  @override
  void initState() {
    super.initState();
    // Read character details
    characterName = ref.read(characterProvider).name;
    characterClass = ref.read(characterProvider).characterClass;
    background = ref.read(characterProvider).background;
    race = ref.read(characterProvider).race;

    // Hard-code for Bard and Barbarian
    if (characterClass == 'Bard') {
      numberOfProficiencies = 3;
      _possibleProficiencies = allProficiencies;
    } else if (characterClass == 'Barbarian') {
      numberOfProficiencies = 2;
      _possibleProficiencies = [
        'Athletics', 'Animal Handling', 'Intimidation',
        'Nature', 'Perception', 'Survival'
      ];
    } else {
      // Default: dynamic based on ClassData
      final classSkills =
          ClassData[characterClass]?['skills']?.first.toString() ?? '';
      final found = _findItemsAndCount(classSkills);
      _possibleProficiencies = found.itemList;
      numberOfProficiencies = found.count;
    }

    // Given proficiencies from background
    final bgSkills = (BackgroundData[background]?['skills'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .join(',') ?? '';
    final foundBg = _findItemsAndCount(bgSkills);
    _givenProficiencies = foundBg.itemList;

    // Given languages from background and race
    final bgLangs = (BackgroundData[background]?['languages'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .join(',') ?? '';
    _givenLanguages = _parseList(bgLangs);

    final raceLangs = (RaceData[race]?['languages'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .join(',') ?? '';
    _givenLanguages += _parseList(raceLangs);

    // Determine number of selectable languages (from background text)
    final bgLangText = (BackgroundData[background]?['languages'] as List<dynamic>?)
        ?.join(',') ?? '';
    numberOfLanguages = _extractNumber(bgLangText, _givenLanguages.length);

    // If no languages are provided by the background, set numberOfLanguages to 0
    if (bgLangText.isEmpty) {
      numberOfLanguages = 0;
    }

    setState(() {});
  }

  // Helper to parse comma lists
  List<String> _parseList(String input) {
    if (input.isEmpty) return [];
    return input.split(',').map((s) => s.trim()).toList();
  }

  // Helper to extract items and count
  _FoundItems _findItemsAndCount(String input) {
    final numPattern = RegExp(r'(\d+)');
    final fromPattern = RegExp(r'from (.+)$'); // Fixed regex to match the full list
    List<String> items = [];
    int count = 0;

    if (fromPattern.hasMatch(input)) {
      items = fromPattern
          .firstMatch(input)!
          .group(1)!
          .split(',')
          .map((s) => s.trim())
          .toList();
    } else if (input.isNotEmpty) {
      items = input.split(',').map((s) => s.trim()).toList();
    }

    if (numPattern.hasMatch(input)) {
      count = int.parse(numPattern.firstMatch(input)!.group(1)!);
    }

    // Debugging: Log the parsed items and count
    print('Parsed Items: $items, Count: $count');

    return _FoundItems(items, count);
  }

  // Helper to extract number words or default
  int _extractNumber(String text, int defaultVal) {
    final words = {
      'One': 1, 'Two': 2, 'Three': 3, 'Four': 4, 'Five': 5,
      'Six': 6, 'Seven': 7, 'Eight': 8, 'Nine': 9, 'Ten': 10,
    };
    for (var entry in words.entries) {
      if (text.toLowerCase().contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return defaultVal;
  }

  void showSnackbar(String msg) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(msg), duration: Duration(seconds: 2)));
  }

  void updateSelectedProficiency(String name) {
    setState(() {
      if (_givenProficiencies.contains(name)) {
        showSnackbar('Included by background');
      } else if (_selectedProficiencies.contains(name)) {
        _selectedProficiencies.remove(name);
      } else if (_selectedProficiencies.length >= numberOfProficiencies) {
        showSnackbar('Already selected $numberOfProficiencies');
      } else {
        _selectedProficiencies.add(name);
      }
    });
  }

  void updateSelectedLanguage(String name) {
    if (numberOfLanguages == 0) {
      showSnackbar('No languages available to select.');
      return;
    }

    setState(() {
      if (_selectedLanguages.contains(name)) {
        _selectedLanguages.remove(name);
      } else if (_selectedLanguages.length >= numberOfLanguages) {
        showSnackbar('Already selected $numberOfLanguages');
      } else {
        _selectedLanguages.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context)
        .elevatedButtonTheme
        .style
        ?.backgroundColor
        ?.resolve({}) ?? Colors.grey;
    return Scaffold(
      appBar: MainAppbar(),
      drawer: MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                SegmentedButton<String>(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) {
                        if (states.contains(MaterialState.selected)) {
                          return bgColor; // Use your button color for selected state
                        }
                        return Colors.grey; // Default color for unselected state
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.white; // Text color for selected state
                        }
                        return Colors.black; // Text color for unselected state
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(
                      value: 'Proficiency',
                      label: SizedBox(
                        width: 130, // Ensure consistent width
                        child: Center(child: Text('Proficiencies')),
                      ),
                      icon: Icon(Icons.catching_pokemon),
                    ),
                    ButtonSegment<String>(
                      value: 'Language',
                      label: SizedBox(
                        width: 130, // Ensure consistent width
                        child: Center(child: Text('Languages')),
                      ),
                      icon: Icon(Icons.language),
                    ),
                  ],
                  selected: {_currentSection},
                  emptySelectionAllowed: false,
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _currentSection = newSelection.first;
                    });
                  },
                ),
                IndexedStack(
                  index: _currentSection == 'Proficiency' ? 0 : 1,
                  children: [
                    _buildProficiencySection(bgColor),
                    _buildLanguageSection(bgColor),
                  ],
                ),
                SizedBox(height: 120),
              ],
            ),
          ),
          Positioned(
            bottom: 40, left: 16, right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => BackgroundScreen())),
                  icon: Icon(Icons.arrow_back), label: Text('Back'),
                  style: ElevatedButton.styleFrom(backgroundColor: bgColor),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(characterProvider.notifier)
                      ..updateLanguages(_selectedLanguages + _givenLanguages)
                      ..updateProficiencies(_selectedProficiencies + _givenProficiencies);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => StatsScreen()));
                  },
                  icon: Icon(Icons.arrow_forward), label: Text('Next'),
                  style: ElevatedButton.styleFrom(backgroundColor: bgColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProficiencySection(Color bgColor) {
    return Column(
      children: [
        SizedBox(height: 10),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: allProficiencies.map((prof) {
            final isSelectable = _possibleProficiencies.contains(prof);
            final isSelected = _selectedProficiencies.contains(prof) || _givenProficiencies.contains(prof);
            return ButtonWithPadding(
              textContent: prof,
              color: isSelected ? bgColor : (isSelectable ? Colors.grey : Colors.blueGrey[800]!),
              onPressed: isSelectable ? () => updateSelectedProficiency(prof)
                  : () => showSnackbar('Not available'),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            height: 175, width: 350,
            child: ProficiencyDataWidget(backgroundName: background, className: characterClass),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(Color bgColor) {
    return Column(
      children: [
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: languages.map((lang) {
            final isSelected = _selectedLanguages.contains(lang) || _givenLanguages.contains(lang);
            final isSelectable = numberOfLanguages > 0 && !_givenLanguages.contains(lang);

            return ButtonWithPadding(
              textContent: lang,
              color: isSelected ? bgColor : (isSelectable ? Colors.grey : Colors.blueGrey[800]!),
              onPressed: isSelectable
                  ? () => updateSelectedLanguage(lang)
                  : () => showSnackbar('No languages available to select.'),
            );
          }).toList(),
        ),
        SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            height: 130,
            width: 350,
            child: LanguageDataWidget(backgroundName: background, raceName: race),
          ),
        ),
      ],
    );
  }
}

class _FoundItems {
  final List<String> itemList;
  final int count;
  _FoundItems(this.itemList, this.count);
}