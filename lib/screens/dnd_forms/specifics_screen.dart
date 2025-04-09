import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/widgets/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import '../../screens/dnd_forms/stats_screen.dart';
import '../../widgets/navigation/main_drawer.dart';
import 'package:flutter/material.dart';
import '../../data/character creator data/background_data.dart';
import '../../data/character creator data/class_data.dart';
import '../../data/character creator data/race_data.dart';
import '../../widgets/buttons/navigation_button.dart';
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
  final List<String> proficiencies = [
    'Acrobatics',
    'Animal Handling',
    'Arcana',
    'Athletics',
    'History',
    'Insight',
    'Intimidation',
    'Investigation',
    'Medicine',
    'Nature',
    'Perception',
    'Performance',
    'Persuasion',
    'Religion',
    'Sleight of Hand',
    'Stealth',
    'Survival'
  ];
  List<String> languages = [
    'Undercommon',
    'Primordial',
    'Deep Speech',
    'Celestial',
    'Abyssal',
    'Halfling',
    'Infernal',
    'Dwarvish',
    'Gnomish',
    'Draconic',
    'Elvish',
    'Sylvan',
    'Common',
    'Goblin',
    'Giant',
    'Orc',
  ];
  List<String> _selectedProficiencies = [];
  List<String> _selectedLanguages = [];
  List<String> _givenProficiencies = [];
  List<String> _givenLanguages = [];

  late int numberOfProficiencies = 0;
  late List<String> _possibleProficiencies = [];
  late int numberOfLanguages = 0;

  String _currentSection = 'Proficiency';

  late String characterName;
  late String characterClass;
  late String background;
  late String race;

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(message),
      ),
    );
  }

  void updateSelectedProficiency(String proficiencyName) {
    setState(() {
      if (_givenProficiencies.contains(proficiencyName)) {
        showSnackbar('This proficiency is included in your background!');
      } else if (_selectedProficiencies.contains(proficiencyName)) {
        _selectedProficiencies.remove(proficiencyName);
      } else if (_selectedProficiencies.length >= numberOfProficiencies) {
        showSnackbar('You\'ve already selected all your proficiencies!');
      } else {
        _selectedProficiencies.add(proficiencyName);
      }
    });
  }

  void updateSelectedLanguage(String languageName) {
    setState(() {
      if (_selectedLanguages.contains(languageName)) {
        _selectedLanguages.remove(languageName);
      } else if (_selectedLanguages.length >= numberOfLanguages) {
        showSnackbar('You\'ve already selected all your languages!');
      } else {
        _selectedLanguages.add(languageName);
      }
    });
  }

  List<String> findProficiencies(String skillString) {
    final RegExp numberPattern = RegExp(r'\d+');
    final RegExp skillsPattern = RegExp(r'from (.+)$');

    List<String> proficiencyList = [];
    if (skillsPattern.hasMatch(skillString)) {
      String skillList = skillsPattern.firstMatch(skillString)!.group(1)!;
      proficiencyList =
          skillList.split(',').map((skill) => skill.trim()).toList();
    } else {
      proficiencyList +=
          skillString.split(',').map((skill) => skill.trim()).toList();
    }

    if (numberPattern.hasMatch(skillString)) {
      numberOfProficiencies +=
          int.parse(numberPattern.firstMatch(skillString)!.group(0)!);
    }
    return proficiencyList;
  }

  List<String> findLanguages(String languageString) {
    final RegExp languagePattern = RegExp(r'from (.+)$');

    List<String> languageList = [];
    if (languagePattern.hasMatch(languageString)) {
      String languageOptions =
          languagePattern.firstMatch(languageString)!.group(1)!;
      languageList =
          languageOptions.split(',').map((lang) => lang.trim()).toList();
    } else {
      languageList +=
          languageString.split(',').map((lang) => lang.trim()).toList();
    }

    return languageList;
  }

  void findNumLanguages(String input) {
    final Map<String, int> wordToNumber = {
      'One': 1,
      'Two': 2,
      'Three': 3,
      'Four': 4,
      'Five': 5,
      'Six': 6,
      'Seven': 7,
      'Eight': 8,
      'Nine': 9,
      'Ten': 10,
    };

    final RegExp wordPattern = RegExp(
        r'\b(One|Two|Three|Four|Five|Six|Seven|Eight|Nine|Ten)\b',
        caseSensitive: false);
    if (wordPattern.hasMatch(input)) {
      String word = wordPattern.firstMatch(input)!.group(0)!.toLowerCase();
      String capitalizedWord = word[0].toUpperCase() + word.substring(1);
      setState(() => numberOfLanguages = (wordToNumber[capitalizedWord]!));
    } else {
      setState(() {
        numberOfLanguages = _givenLanguages.length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setMainContent('Proficiency');

    characterName = ref.read(characterProvider).name;
    characterClass = ref.read(characterProvider).characterClass;
    background = ref.read(characterProvider).background;
    race = ref.read(characterProvider).race;

    List<String> proficiencies =
        findProficiencies(ClassData[characterClass]?['skills']?.first ?? '');
    _possibleProficiencies = proficiencies;
    List<String> givenProficiencies = findProficiencies(
        (BackgroundData[background]?['skills'] as List<dynamic>?)
                ?.map((skill) => skill.toString())
                .join(',') ??
            '');

    List<String> givenLanguages = findProficiencies(
        (RaceData[race]?['languages'] as List<dynamic>?)
                ?.map((language) => language.toString())
                .join(',') ??
            '');
    setState(() {
      _selectedProficiencies = [];
      _givenProficiencies = givenProficiencies;
      _selectedLanguages = [];
      _givenLanguages = givenLanguages;
    });

    findNumLanguages(
        (BackgroundData[background]?['languages'] as List<dynamic>?)
                ?.map((skill) => skill.toString())
                .join(',') ??
            '');
  }

  void setMainContent(String type) {
    setState(() {
      _currentSection = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    final elevatedButtonColor = Theme.of(context)
            .elevatedButtonTheme
            .style
            ?.backgroundColor
            ?.resolve({}) ??
        Colors.grey;

    return Scaffold(
      appBar: MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Specifics Selection for $characterName',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                    "Delete me later: $characterClass + $background + $race"), //DELETE ME LATER
                const SizedBox(height: 20),
                SegmentedButton<String>(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return elevatedButtonColor;
                        }
                        return Colors.grey;
                      },
                    ),
                    foregroundColor: const MaterialStatePropertyAll(Colors.white),
                  ),
                  segments: const <ButtonSegment<String>>[
                    ButtonSegment<String>(
                      value: 'Proficiency',
                      label: SizedBox(
                          width: 130, child: Center(child: Text('Proficiencies'))),
                      icon: Icon(Icons.catching_pokemon),
                    ),
                    ButtonSegment<String>(
                      value: 'Language',
                      label: SizedBox(
                          width: 130, child: Center(child: Text('Languages'))),
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
                const SizedBox(height: 15),
                IndexedStack(
                  index: _getIndexForMainContent(),
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 390,
                          child: SingleChildScrollView(
                            child: Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: <Widget>[
                                  for (final proficiency in proficiencies)
                                    ButtonWithPadding(
                                      onPressed: () {
                                        if (_possibleProficiencies
                                                .contains(proficiency) ||
                                            _givenProficiencies
                                                .contains(proficiency)) {
                                          updateSelectedProficiency(proficiency);
                                        } else {
                                          showSnackbar(
                                              'This proficiency is not within your class or background!');
                                        }
                                      },
                                      textContent: proficiency,
                                      color: (_selectedProficiencies
                                                  .contains(proficiency) ||
                                              _givenProficiencies
                                                  .contains(proficiency))
                                          ? elevatedButtonColor
                                          : _possibleProficiencies
                                                  .contains(proficiency)
                                              ? Colors.grey
                                              : Colors.blueGrey[800],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            height: 175,
                            width: 350,
                            child: SingleChildScrollView(
                              child: ProficiencyDataWidget(
                                  backgroundName: background,
                                  className: characterClass),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 400,
                          child: SingleChildScrollView(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: <Widget>[
                                for (final language in languages)
                                  ButtonWithPadding(
                                      onPressed: () {
                                        if (!_givenLanguages.contains(language)) {
                                          updateSelectedLanguage(language);
                                        } else {
                                          showSnackbar(
                                              'This language is included in your race!');
                                        }
                                      },
                                      textContent: language,
                                      color: (_selectedLanguages
                                                  .contains(language) ||
                                              _givenLanguages.contains(language))
                                          ? elevatedButtonColor
                                          : Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            height: 130,
                            width: 350,
                            child: SingleChildScrollView(
                              child: LanguageDataWidget(
                                backgroundName: background,
                                raceName: race,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text("Back"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: elevatedButtonColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(characterProvider.notifier)
                        .updateLanguages(_selectedLanguages + _givenLanguages);
                    ref.read(characterProvider.notifier).updateProficiencies(
                        _selectedProficiencies + _givenProficiencies);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StatsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text("Next"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: elevatedButtonColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getIndexForMainContent() {
    if (_currentSection == 'Proficiency') {
      return 0;
    } else {
      return 1;
    }
  }
}
