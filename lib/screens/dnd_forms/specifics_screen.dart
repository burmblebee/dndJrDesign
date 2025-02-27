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

  final Color customColor = const Color.fromARGB(255, 138, 28, 20);
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
    return Scaffold(
      appBar: MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Specifics Selection for $characterName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Delete me later: $characterClass + $background + $race"), //DELETE ME LATER
            const SizedBox(height: 20),
            SegmentedButton<String>(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return customColor;
                    }
                    return Colors.grey;
                  },
                ),
                foregroundColor: const WidgetStatePropertyAll(Colors.white),
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
                                        _givenProficiencies.contains(proficiency)) {
                                      updateSelectedProficiency(proficiency);
                                    } else {
                                      showSnackbar(
                                          'This proficiency is not within your class or background!');
                                    }
                                  },
                                  textContent: proficiency,
                                  color: (_selectedProficiencies
                                              .contains(proficiency) ||
                                          _givenProficiencies.contains(proficiency))
                                      ? customColor
                                      : _possibleProficiencies.contains(proficiency)
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
                                  color: (_selectedLanguages.contains(language) ||
                                          _givenLanguages.contains(language))
                                      ? customColor
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text("Back"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    var languages = _selectedLanguages + _givenLanguages;
                    var proficiencies = _selectedProficiencies + _givenProficiencies;
                    ref.read(characterProvider.notifier).updateLanguages(languages);
                    ref.read(characterProvider.notifier).updateProficiencies(proficiencies);
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
                    backgroundColor: customColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
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





// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:warlocks_of_the_beach/widgets/main_appbar.dart';
// import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
// import '../../screens/dnd_forms/stats_screen.dart';
// import '../../widgets/navigation/main_drawer.dart';
// import 'package:flutter/material.dart';
// import '../../data/character creator data/background_data.dart';
// import '../../data/character creator data/class_data.dart';
// import '../../data/character creator data/race_data.dart';
// import '../../widgets/buttons/navigation_button.dart';
// import '../../widgets/buttons/button_with_padding.dart';
// import '../../widgets/loaders/language_data_loader.dart';
// import '../../widgets/loaders/proficiency_data_loader.dart';
// import 'package:warlocks_of_the_beach/providers/character_provider.dart';

// class SpecificsScreen extends ConsumerStatefulWidget {
//   const SpecificsScreen({super.key});

//   @override
//   _SpecificsScreenState createState() => _SpecificsScreenState();
// }

// class _SpecificsScreenState extends ConsumerState<SpecificsScreen> {
//   final List<String> proficiencies = [
//     'Acrobatics',
//     'Animal Handling',
//     'Arcana',
//     'Athletics',
//     'History',
//     'Insight',
//     'Intimidation',
//     'Investigation',
//     'Medicine',
//     'Nature',
//     'Perception',
//     'Performance',
//     'Persuasion',
//     'Religion',
//     'Sleight of Hand',
//     'Stealth',
//     'Survival'
//   ];
//   List<String> languages = [
//     'Undercommon',
//     'Primordial',
//     'Deep Speech',
//     'Celestial',
//     'Abyssal',
//     'Halfling',
//     'Infernal',
//     'Dwarvish',
//     'Gnomish',
//     'Draconic',
//     'Elvish',
//     'Sylvan',
//     'Common',
//     'Goblin',
//     'Giant',
//     'Orc',
//   ];
//   List<String> _selectedProficiencies = [];
//   List<String> _selectedLanguages = [];
//   List<String> _givenProficiencies = [];
//   List<String> _givenLanguages = [];

//   late int numberOfProficiencies = 0;
//   late List<String> _possibleProficiencies = [];
//   late int numberOfLanguages = 0;

//   final Color customColor = const Color.fromARGB(255, 138, 28, 20);
//   String _currentSection = 'Proficiency';

//   void showSnackbar(String message) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         duration: const Duration(seconds: 3),
//         content: Text(message),
//       ),
//     );
//   }

//   void updateSelectedProficiency(String proficiencyName) {
//     setState(() {
//       if (_givenProficiencies.contains(proficiencyName)) {
//         showSnackbar('This proficiency is included in your background!');
//       } else if (_selectedProficiencies.contains(proficiencyName)) {
//         _selectedProficiencies.remove(proficiencyName);
//       } else if (_selectedProficiencies.length >= numberOfProficiencies) {
//         showSnackbar('You\'ve already selected all your proficiencies!');
//       } else {
//         _selectedProficiencies.add(proficiencyName);
//       }
//     });
//   }

//   void updateSelectedLanguage(String languageName) {
//     setState(() {
//       if (_selectedLanguages.contains(languageName)) {
//         _selectedLanguages.remove(languageName);
//       } else if (_selectedLanguages.length >= numberOfLanguages) {
//         showSnackbar('You\'ve already selected all your languages!');
//       } else {
//         _selectedLanguages.add(languageName);
//       }
//     });
//   }

//   List<String> findProficiencies(String skillString) {
//     final RegExp numberPattern = RegExp(r'\d+');
//     final RegExp skillsPattern = RegExp(r'from (.+)$');

//     List<String> proficiencyList = [];
//     if (skillsPattern.hasMatch(skillString)) {
//       String skillList = skillsPattern.firstMatch(skillString)!.group(1)!;
//       proficiencyList =
//           skillList.split(',').map((skill) => skill.trim()).toList();
//     } else {
//       proficiencyList +=
//           skillString.split(',').map((skill) => skill.trim()).toList();
//     }

//     if (numberPattern.hasMatch(skillString)) {
//       numberOfProficiencies +=
//           int.parse(numberPattern.firstMatch(skillString)!.group(0)!);
//     }
//     return proficiencyList;
//   }

//   List<String> findLanguages(String languageString) {
//     final RegExp languagePattern = RegExp(r'from (.+)$');

//     List<String> languageList = [];
//     if (languagePattern.hasMatch(languageString)) {
//       String languageOptions =
//           languagePattern.firstMatch(languageString)!.group(1)!;
//       languageList =
//           languageOptions.split(',').map((lang) => lang.trim()).toList();
//     } else {
//       languageList +=
//           languageString.split(',').map((lang) => lang.trim()).toList();
//     }

//     return languageList;
//   }

//   void findNumLanguages(String input) {
//     final Map<String, int> wordToNumber = {
//       'One': 1,
//       'Two': 2,
//       'Three': 3,
//       'Four': 4,
//       'Five': 5,
//       'Six': 6,
//       'Seven': 7,
//       'Eight': 8,
//       'Nine': 9,
//       'Ten': 10,
//     };

//     final RegExp wordPattern = RegExp(
//         r'\b(One|Two|Three|Four|Five|Six|Seven|Eight|Nine|Ten)\b',
//         caseSensitive: false);
//     if (wordPattern.hasMatch(input)) {
//       String word = wordPattern.firstMatch(input)!.group(0)!.toLowerCase();
//       String capitalizedWord = word[0].toUpperCase() + word.substring(1);
//       setState(() => numberOfLanguages = (wordToNumber[capitalizedWord]!));
//     } else {
//       setState(() {
//         numberOfLanguages = _givenLanguages.length;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     setMainContent('Proficiency');

//     final characterClass = ref.read(characterProvider).characterClass;
//     final background = ref.read(characterProvider).background;
//     final race = ref.read(characterProvider).race;

//     List<String> proficiencies =
//         findProficiencies(ClassData[characterClass]?['skills']?.first ?? '');
//     _possibleProficiencies = proficiencies;
//     List<String> givenProficiencies = findProficiencies(
//         (BackgroundData[background]?['skills'] as List<dynamic>?)
//                 ?.map((skill) => skill.toString())
//                 .join(',') ??
//             '');

//     List<String> givenLanguages = findProficiencies(
//         (RaceData[race]?['languages'] as List<dynamic>?)
//                 ?.map((language) => language.toString())
//                 .join(',') ??
//             '');
//     setState(() {
//       _selectedProficiencies = [];
//       _givenProficiencies = givenProficiencies;
//       _selectedLanguages = [];
//       _givenLanguages = givenLanguages;
//     });

//     findNumLanguages(
//         (BackgroundData[background]?['languages'] as List<dynamic>?)
//                 ?.map((skill) => skill.toString())
//                 .join(',') ??
//             '');
//   }

//   void setMainContent(String type) {
//     setState(() {
//       _currentSection = type;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final characterName = ref.watch(characterProvider).name;
//     final race = ref.watch(characterProvider).race;
//     final characterClass = ref.watch(characterProvider).characterClass;
//     final background = ref.watch(characterProvider).background;

//     return Scaffold(
//       appBar: MainAppbar(),
//       drawer: const MainDrawer(),
//       bottomNavigationBar: MainBottomNavBar(),
//       // bottomNavigationBar: Row(
//       //   children: [
//       //     NavigationButton(
//       //       onPressed: () {
//       //         Navigator.pop(context);
//       //       },
//       //       textContent: 'Back',
//       //     ),
//       //     const SizedBox(width: 30),
//       //     NavigationButton(
//       //       textContent: "Next",
//       //       onPressed: () {
//       //         // if (_selectedProficiencies.length != numberOfProficiencies ||
//       //         //     _selectedLanguages.length != numberOfLanguages) {
//       //         //   showSnackbar(
//       //         //       'You haven\'t chosen all your proficiencies or languages!');
//       //         // } else {
//       //         //   Navigator.push(
//       //         //     context,
//       //         //     MaterialPageRoute(
//       //         //       builder: (context) => StatsScreen(),
//       //         //     ),
//       //         //   );
//       //         // }
//       //         Navigator.push(
//       //             context,
//       //             MaterialPageRoute(
//       //               builder: (context) => StatsScreen(),
//       //             ),
//       //           );
//       //       },
//       //     ),
//       //   ],
//       // ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Text(
//                 'Specifics Selection for $characterName',
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               Text("Delete me later: $characterClass + $background + $race"), //DELETE ME LATER
//             const SizedBox(height: 20),
//             SegmentedButton<String>(
//               style: ButtonStyle(
//                 backgroundColor: WidgetStateProperty.resolveWith<Color>(
//                   (states) {
//                     if (states.contains(WidgetState.selected)) {
//                       return customColor;
//                     }
//                     return Colors.grey;
//                   },
//                 ),
//                 foregroundColor: const WidgetStatePropertyAll(Colors.white),
//               ),
//               segments: const <ButtonSegment<String>>[
                
//                 ButtonSegment<String>(
//                   value: 'Proficiency',
//                   label: SizedBox(
//                       width: 130, child: Center(child: Text('Proficiencies'))),
//                   icon: Icon(Icons.catching_pokemon),
                  
//                 ),
//                 ButtonSegment<String>(
//                   value: 'Language',
//                   label: SizedBox(
//                       width: 130, child: Center(child: Text('Languages'))),
//                   icon: Icon(Icons.language),
//                 ),
//               ],
//               selected: {_currentSection},
//               emptySelectionAllowed: false,
//               onSelectionChanged: (Set<String> newSelection) {
//                 setState(() {
//                   _currentSection = newSelection.first;
//                 });
//               },
//             ),
//             const SizedBox(height: 15),
//             IndexedStack(
//               index: _getIndexForMainContent(),
//               alignment: Alignment.topCenter,
//               children: [
//                 Column(
//                   children: [
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       height: 390,
//                       child: SingleChildScrollView(
//                         child: Center(
//                           child: Wrap(
//                             alignment: WrapAlignment.center,
//                             children: <Widget>[
//                               for (final proficiency in proficiencies)
//                                 ButtonWithPadding(
//                                   onPressed: () {
//                                     if (_possibleProficiencies
//                                             .contains(proficiency) ||
//                                         _givenProficiencies.contains(proficiency)) {
//                                       updateSelectedProficiency(proficiency);
//                                     } else {
//                                       showSnackbar(
//                                           'This proficiency is not within your class or background!');
//                                     }
//                                   },
//                                   textContent: proficiency,
//                                   color: (_selectedProficiencies
//                                               .contains(proficiency) ||
//                                           _givenProficiencies.contains(proficiency))
//                                       ? customColor
//                                       : _possibleProficiencies.contains(proficiency)
//                                           ? Colors.grey
//                                           : Colors.blueGrey[800],
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 25),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: SizedBox(
//                         height: 175,
//                         width: 350,
//                         child: SingleChildScrollView(
//                           child: ProficiencyDataWidget(
//                               backgroundName: background,
//                               className: characterClass),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     SizedBox(
//                       height: 400,
//                       child: SingleChildScrollView(
//                         child: Wrap(
//                           alignment: WrapAlignment.center,
//                           children: <Widget>[
//                             for (final language in languages)
//                               ButtonWithPadding(
//                                   onPressed: () {
//                                     if (!_givenLanguages.contains(language)) {
//                                       updateSelectedLanguage(language);
//                                     } else {
//                                       showSnackbar(
//                                           'This language is included in your race!');
//                                     }
//                                   },
//                                   textContent: language,
//                                   color: (_selectedLanguages.contains(language) ||
//                                           _givenLanguages.contains(language))
//                                       ? customColor
//                                       : Colors.grey),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.black),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: SizedBox(
//                         height: 130,
//                         width: 350,
//                         child: SingleChildScrollView(
//                           child: LanguageDataWidget(
//                             backgroundName: background,
//                             raceName: race,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   int _getIndexForMainContent() {
//     if (_currentSection == 'Proficiency') {
//       return 0;
//     } else {
//       return 1;
//     }
//   }
// }