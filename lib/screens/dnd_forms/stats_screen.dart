import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/dnd_forms/equipment_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/buttons/button_with_padding.dart';
import 'dart:math';
import '../../widgets/buttons/navigation_button.dart';

import '../../widgets/buttons/expandable_fab.dart';
import '../../data/race_data.dart';
import '../../widgets/main_drawer.dart';
class StatsScreen extends StatefulWidget {
  const StatsScreen(
      {super.key, required this.characterName, required this.selectedRace});

  final characterName;
  final selectedRace;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late String _selectedRace; // Declare _selectedRace as late
  late Map<String, int> abilityScores = {
    'Strength': 8,
    'Dexterity': 8,
    'Constitution': 8,
    'Wisdom': 8,
    'Intelligence': 8,
    'Charisma': 8,
  }; // to save
  int index = 0;
  final Color customColor = const Color.fromARGB(255, 138, 28, 20);
  int pointsLeft = 27; // For PointBuy
  final Map<String, int> baseScores = {
    'Strength': 8,
    'Dexterity': 8,
    'Constitution': 8,
    'Wisdom': 8,
    'Intelligence': 8,
    'Charisma': 8,
  }; // point buy

  final Map<String, int> rolledScores = {
    'Strength': 0,
    'Dexterity': 0,
    'Constitution': 0,
    'Wisdom': 0,
    'Intelligence': 0,
    'Charisma': 0,
  }; //rolling

  final Map<String, int> standardScores = {
    'Strength': 15,
    'Dexterity': 14,
    'Constitution': 13,
    'Wisdom': 12,
    'Intelligence': 10,
    'Charisma': 8,
  }; //standard array

  //for standard array
  List<int> standardArray = [15, 14, 13, 12, 10, 8];
  List<String> standardAbilities = [
    'Strength',
    'Dexterity',
    'Constitution',
    'Wisdom',
    'Intelligence',
    'Charisma'
  ];
  List<bool> readyStatuses = [true, true, true, true, true, true];

  final List<String> _pickedAbilities = []; // rolling
  String _chosenAbility = 'Strength'; // rolling
  int dice_no1 = 1, dice_no2 = 1, dice_no3 = 1, dice_no4 = 1;
  int currentRoll = 0;

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(message),
      ),
    );
  }

  void _updateScores(String key, int value) {
    setState(() {
      abilityScores[key] = value;
    });
  }

  void _incrementSkill(String skill) {
    final score = baseScores[skill]! + 1;
    final cost = (score <= 13) ? 1 : 2;

    setState(() {
      if (pointsLeft >= cost && baseScores[skill]! < 15) {
        baseScores[skill] = score;
        pointsLeft -= cost;
        _updateScores(skill, baseScores[skill]!);
      } else {
        showSnackbar('You do not have enough points left to increase $skill!');
      }
    });
  }

  Future<void> _getRace() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated');
      return;
    }
    final userId = user.uid;

    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore
          .collection('app_user_profiles')
          .doc(userId)
          .collection('characters')
          .doc(widget.characterName);

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('race')) {
          final race = data['race'];
          setState(() {
            _selectedRace = race;
          });
        } else {
          print('Race field does not exist in the document');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error getting race: $e');
    }
  }

  void _decrementSkill(String skill) {
    final score = baseScores[skill]! - 1;
    final cost = (baseScores[skill]! <= 14) ? 1 : 2;

    setState(() {
      if (score >= 8) {
        baseScores[skill] = score;
        pointsLeft += cost;
        _updateScores(skill, baseScores[skill]!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedRace = widget.selectedRace; // Initialize _selectedRace in initState
    _rollDice();
    _getRace();
  }

  void _rollDice() {
    setState(() {
      dice_no1 = Random().nextInt(6) + 1;
      dice_no2 = Random().nextInt(6) + 1;
      dice_no3 = Random().nextInt(6) + 1;
      dice_no4 = Random().nextInt(6) + 1;

      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          dice_no1 = Random().nextInt(6) + 1;
          dice_no2 = Random().nextInt(6) + 1;
          dice_no3 = Random().nextInt(6) + 1;
          dice_no4 = Random().nextInt(6) + 1;
          currentRoll = dice_no1 + dice_no2 + dice_no3 + dice_no4;
        });
      });

      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          dice_no1 = Random().nextInt(6) + 1;
          dice_no2 = Random().nextInt(6) + 1;
          dice_no3 = Random().nextInt(6) + 1;
          dice_no4 = Random().nextInt(6) + 1;
          currentRoll = dice_no1 + dice_no2 + dice_no3 + dice_no4;
        });
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          dice_no1 = Random().nextInt(6) + 1;
          dice_no2 = Random().nextInt(6) + 1;
          dice_no3 = Random().nextInt(6) + 1;
          dice_no4 = Random().nextInt(6) + 1;
          currentRoll = dice_no1 + dice_no2 + dice_no3 + dice_no4;
        });
      });

      Future.delayed(const Duration(milliseconds: 400), () {
        setState(() {
          dice_no1 = Random().nextInt(6) + 1;
          dice_no2 = Random().nextInt(6) + 1;
          dice_no3 = Random().nextInt(6) + 1;
          dice_no4 = Random().nextInt(6) + 1;
          currentRoll = dice_no1 + dice_no2 + dice_no3 + dice_no4;
        });
      });
    });
  }

  void _saveRoll() {
    if (!_pickedAbilities.contains(_chosenAbility)) {
      setState(() {
        rolledScores[_chosenAbility] = currentRoll;
        _pickedAbilities.add(_chosenAbility);
      });
    } else {
      showSnackbar("Ability already assigned!");
    }
  }

  Map<String, int> _applyRaceBonuses(Map<String, int> scores) {
    // Fetch race data
    final raceData = RaceData[_selectedRace];
    if (raceData == null) return scores;

    // Default bonuses for Human
    Map<String, int> bonuses = raceData['abilityScoreIncrease'] ?? {};
    if (_selectedRace == 'Human') {
      bonuses = {
        'Strength': 1,
        'Dexterity': 1,
        'Constitution': 1,
        'Wisdom': 1,
        'Intelligence': 1,
        'Charisma': 1,
      };
    }

    // Apply bonuses
    return scores
        .map((key, value) => MapEntry(key, value + (bonuses[key] ?? 0)));
  }

  void _showFinalScores() {
    final scoresToUse = index == 0
        ? baseScores
        : index == 1
        ? rolledScores
        : standardScores;
    final finalScores = _applyRaceBonuses(scoresToUse);

    // Display the final scores
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Final Scores"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: finalScores.entries
              .map((entry) => Text("${entry.key}: ${entry.value}"))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              //TODO: Send final scores to firestore
              _saveSelections();
              //TODO: Push next screen
              // Navigator.push(context, MaterialPageRoute(builder: (context) => EquipmentSelection(characterName: widget.characterName, selectedRace: widget.selectedRace, abilityScores: finalScores)));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EquipmentSelection(
                          characterName: widget.characterName)));
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stats"), backgroundColor: customColor,foregroundColor: Colors.white,),
      drawer: const MainDrawer(),
      bottomNavigationBar: Row(
        children: [
          NavigationButton(
            textContent: "Back",
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 30),
          NavigationButton(
            onPressed: (index == 2 &&
                !(readyStatuses[0] &&
                    readyStatuses[1] &&
                    readyStatuses[2] &&
                    readyStatuses[3] &&
                    readyStatuses[4] &&
                    readyStatuses[5]))
                ? () {
              showSnackbar(
                  'You haven\'t picked a skill for each option!');
            }
                : _showFinalScores,
            textContent: 'Next',
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => setState(() => index = 0),
            icon: const Icon(Icons.edit_note),
          ),
          ActionButton(
            onPressed: () => setState(() => index = 1),
            icon: const Icon(Icons.casino_outlined),
          ),
          ActionButton(
            onPressed: () => setState(() => index = 2),
            icon: const Icon(Icons.check_box_outlined),
          ),
        ],
      ),
      body: IndexedStack(
        index: index,
        children: [
          buildPointBuy(),
          buildDiceRoller(),
          buildStandardArray(),
        ],
      ),
    );
  }

  void updateReadyStatus() {
    for (int i = 0; i < standardAbilities.length; i++) {
      // Get the current ability at this index
      String currentAbility = standardAbilities[i];

      // Check if the ability is unique (not present elsewhere)
      bool isUnique = true;
      for (int j = 0; j < standardAbilities.length; j++) {
        if (i != j && currentAbility == standardAbilities[j]) {
          isUnique = false;
          break;
        }
      }

      // Check if the corresponding score is valid
      bool hasValidScore = standardScores[currentAbility] != null &&
          standardScores[currentAbility]! >= 0;

      // Update the readiness status for this index
      readyStatuses[i] = isUnique && hasValidScore;
    }
  }

  Widget buildStandardArray() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: customColor, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        color: (readyStatuses[0])
                            ? Colors.white
                            : customColor.withOpacity(0.75),
                      ),
                      width: 100,
                      height: 100,
                      child: const Center(
                        child: Text('15',
                            style:
                            TextStyle(color: Colors.black, fontSize: 50)),
                      ),
                    ),
                    DropdownButton(
                      value: standardAbilities[0],
                      items: const [
                        DropdownMenuItem(
                          child: Text('Strength'),
                          value: 'Strength',
                        ),
                        DropdownMenuItem(
                          child: Text('Dexterity'),
                          value: 'Dexterity',
                        ),
                        DropdownMenuItem(
                          child: Text('Constitution'),
                          value: 'Constitution',
                        ),
                        DropdownMenuItem(
                          child: Text('Wisdom'),
                          value: 'Wisdom',
                        ),
                        DropdownMenuItem(
                          child: Text('Intelligence'),
                          value: 'Intelligence',
                        ),
                        DropdownMenuItem(
                          child: Text('Charisma'),
                          value: 'Charisma',
                        ),
                      ],
                      onChanged: (ability) {
                        setState(() {
                          // Find the ability currently assigned to this score and remove it
                          String previousAbility = standardAbilities[0];
                          if (standardScores.containsKey(previousAbility)) {
                            standardScores.remove(previousAbility);
                          }

                          // Assign the new ability to this score
                          standardAbilities[0] = ability!;
                          standardScores[ability] = standardArray[0];

                          // Ensure UI updates correctly
                          updateReadyStatus();
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: customColor, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        color: (readyStatuses[1])
                            ? Colors.white
                            : customColor.withOpacity(0.75),
                      ),
                      width: 100,
                      height: 100,
                      child: const Center(
                        child: Text('14',
                            style:
                            TextStyle(color: Colors.black, fontSize: 50)),
                      ),
                    ),
                    DropdownButton(
                      value: standardAbilities[1],
                      items: const [
                        DropdownMenuItem(
                          child: Text('Strength'),
                          value: 'Strength',
                        ),
                        DropdownMenuItem(
                          child: Text('Dexterity'),
                          value: 'Dexterity',
                        ),
                        DropdownMenuItem(
                          child: Text('Constitution'),
                          value: 'Constitution',
                        ),
                        DropdownMenuItem(
                          child: Text('Wisdom'),
                          value: 'Wisdom',
                        ),
                        DropdownMenuItem(
                          child: Text('Intelligence'),
                          value: 'Intelligence',
                        ),
                        DropdownMenuItem(
                          child: Text('Charisma'),
                          value: 'Charisma',
                        ),
                      ],
                      onChanged: (ability) {
                        setState(() {
                          // Find the ability currently assigned to this score and remove it
                          String previousAbility = standardAbilities[1];
                          if (standardScores.containsKey(previousAbility)) {
                            standardScores.remove(previousAbility);
                          }

                          // Assign the new ability to this score
                          standardAbilities[1] = ability!;
                          standardScores[ability] = standardArray[1];

                          // Ensure UI updates correctly
                          updateReadyStatus();
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: customColor, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        color: (readyStatuses[2])
                            ? Colors.white
                            : customColor.withOpacity(0.75),
                      ),
                      width: 100,
                      height: 100,
                      child: const Center(
                        child: Text('13',
                            style:
                            TextStyle(color: Colors.black, fontSize: 50)),
                      ),
                    ),
                    DropdownButton(
                      value: standardAbilities[2],
                      items: const [
                        DropdownMenuItem(
                          child: Text('Strength'),
                          value: 'Strength',
                        ),
                        DropdownMenuItem(
                          child: Text('Dexterity'),
                          value: 'Dexterity',
                        ),
                        DropdownMenuItem(
                          child: Text('Constitution'),
                          value: 'Constitution',
                        ),
                        DropdownMenuItem(
                          child: Text('Wisdom'),
                          value: 'Wisdom',
                        ),
                        DropdownMenuItem(
                          child: Text('Intelligence'),
                          value: 'Intelligence',
                        ),
                        DropdownMenuItem(
                          child: Text('Charisma'),
                          value: 'Charisma',
                        ),
                      ],
                      onChanged: (ability) {
                        setState(() {
                          // Find the ability currently assigned to this score and remove it
                          String previousAbility = standardAbilities[2];
                          if (standardScores.containsKey(previousAbility)) {
                            standardScores.remove(previousAbility);
                          }

                          // Assign the new ability to this score
                          standardAbilities[2] = ability!;
                          standardScores[ability] = standardArray[2];

                          // Ensure UI updates correctly
                          updateReadyStatus();
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: customColor, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        color: (readyStatuses[3])
                            ? Colors.white
                            : customColor.withOpacity(0.75),
                      ),
                      width: 100,
                      height: 100,
                      child: const Center(
                        child: Text('12',
                            style:
                            TextStyle(color: Colors.black, fontSize: 50)),
                      ),
                    ),
                    DropdownButton(
                      value: standardAbilities[3],
                      items: const [
                        DropdownMenuItem(
                          child: Text('Strength'),
                          value: 'Strength',
                        ),
                        DropdownMenuItem(
                          child: Text('Dexterity'),
                          value: 'Dexterity',
                        ),
                        DropdownMenuItem(
                          child: Text('Constitution'),
                          value: 'Constitution',
                        ),
                        DropdownMenuItem(
                          child: Text('Wisdom'),
                          value: 'Wisdom',
                        ),
                        DropdownMenuItem(
                          child: Text('Intelligence'),
                          value: 'Intelligence',
                        ),
                        DropdownMenuItem(
                          child: Text('Charisma'),
                          value: 'Charisma',
                        ),
                      ],
                      onChanged: (ability) {
                        setState(() {
                          // Find the ability currently assigned to this score and remove it
                          String previousAbility = standardAbilities[3];
                          if (standardScores.containsKey(previousAbility)) {
                            standardScores.remove(previousAbility);
                          }

                          // Assign the new ability to this score
                          standardAbilities[3] = ability!;
                          standardScores[ability] = standardArray[3];

                          // Ensure UI updates correctly
                          updateReadyStatus();
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: customColor, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        color: (readyStatuses[4])
                            ? Colors.white
                            : customColor.withOpacity(0.75),
                      ),
                      width: 100,
                      height: 100,
                      child: const Center(
                        child: Text('10',
                            style:
                            TextStyle(color: Colors.black, fontSize: 50)),
                      ),
                    ),
                    DropdownButton(
                      value: standardAbilities[4],
                      items: const [
                        DropdownMenuItem(
                          child: Text('Strength'),
                          value: 'Strength',
                        ),
                        DropdownMenuItem(
                          child: Text('Dexterity'),
                          value: 'Dexterity',
                        ),
                        DropdownMenuItem(
                          child: Text('Constitution'),
                          value: 'Constitution',
                        ),
                        DropdownMenuItem(
                          child: Text('Wisdom'),
                          value: 'Wisdom',
                        ),
                        DropdownMenuItem(
                          child: Text('Intelligence'),
                          value: 'Intelligence',
                        ),
                        DropdownMenuItem(
                          child: Text('Charisma'),
                          value: 'Charisma',
                        ),
                      ],
                      onChanged: (ability) {
                        setState(() {
                          // Find the ability currently assigned to this score and remove it
                          String previousAbility = standardAbilities[4];
                          if (standardScores.containsKey(previousAbility)) {
                            standardScores.remove(previousAbility);
                          }

                          // Assign the new ability to this score
                          standardAbilities[4] = ability!;
                          standardScores[ability] = standardArray[4];

                          // Ensure UI updates correctly
                          updateReadyStatus();
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: customColor, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        color: (readyStatuses[5])
                            ? Colors.white
                            : customColor.withOpacity(0.75),
                      ),
                      width: 100,
                      height: 100,
                      child: const Center(
                        child: Text('8',
                            style:
                            TextStyle(color: Colors.black, fontSize: 50)),
                      ),
                    ),
                    DropdownButton(
                      value: standardAbilities[5],
                      items: const [
                        DropdownMenuItem(
                          child: Text('Strength'),
                          value: 'Strength',
                        ),
                        DropdownMenuItem(
                          child: Text('Dexterity'),
                          value: 'Dexterity',
                        ),
                        DropdownMenuItem(
                          child: Text('Constitution'),
                          value: 'Constitution',
                        ),
                        DropdownMenuItem(
                          child: Text('Wisdom'),
                          value: 'Wisdom',
                        ),
                        DropdownMenuItem(
                          child: Text('Intelligence'),
                          value: 'Intelligence',
                        ),
                        DropdownMenuItem(
                          child: Text('Charisma'),
                          value: 'Charisma',
                        ),
                      ],
                      onChanged: (ability) {
                        setState(() {
                          // Find the ability currently assigned to this score and remove it
                          String previousAbility = standardAbilities[5];
                          if (standardScores.containsKey(previousAbility)) {
                            standardScores[previousAbility] = -12;
                          }

                          // Assign the new ability to this score
                          standardAbilities[5] = ability!;
                          standardScores[ability] = standardArray[5];

                          // Ensure UI updates correctly
                          updateReadyStatus();
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPointBuy() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var row in [
              ["Strength", "Dexterity"],
              ["Constitution", "Wisdom"],
              ["Intelligence", "Charisma"],
            ])
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map((label) {
                  return Column(
                    children: [
                      Text(label,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _decrementSkill(label),
                            icon: Icon(Icons.arrow_downward_sharp,
                                color: customColor),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: customColor,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                            ),
                            height: 100,
                            width: 100,
                            child: Center(
                              child: Text(
                                "${baseScores[label]!}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 50),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _incrementSkill(label),
                            icon: Icon(Icons.arrow_upward_sharp,
                                color: customColor),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),
            Text(
              "Points Left: $pointsLeft",
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(height: 75),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSelections() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated');
      return;
    }
    final userId = user.uid;

    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore
          .collection('app_user_profiles')
          .doc(userId)
          .collection('characters')
          .doc(widget.characterName);

      // Define all ability scores and default them to 0 if not set
      final Map<String, int> defaultAbilityScores = {
        'Strength': 8,
        'Dexterity': 8,
        'Constitution': 8,
        'Intelligence': 8,
        'Wisdom': 8,
        'Charisma': 8,
      };

    //   buildPointBuy(),
    // buildDiceRoller(),
    // buildStandardArray(),

      if(index == 0) {
        abilityScores = baseScores;
      } else if(index == 1) {
        abilityScores = rolledScores;
      } else {
        abilityScores = standardScores;
      }


      // Merge current abilityScores with defaults (ensures every score is included)
      final updatedAbilityScores = {
        for (final key in defaultAbilityScores.keys)
          key: (abilityScores[key] ?? defaultAbilityScores[key])! +
              ((RaceData[widget.selectedRace]?['abilityScoreIncrease']?[key]) ??
                  0),
      };

      // Save to Firestore
      await docRef.set(
        {'abilityScores': updatedAbilityScores},
        SetOptions(merge: true),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save data: $e")),
      );
    }
  }


  // Future<void> _saveSelections() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     print('User not authenticated');
  //     return;
  //   }
  //   final userId = user.uid;

  //   try {
  //     final firestore = FirebaseFirestore.instance;
  //     final docRef = firestore
  //         .collection('app_user_profiles')
  //         .doc(userId)
  //         .collection('characters')
  //         .doc(widget.characterName);

  //     // Save the scores with race bonuses applied
  //     final raceData = RaceData[widget.selectedRace];
  //     final Map<String, int> bonuses = raceData?['abilityScoreIncrease'] ?? {};
  //     final Map<String, int> scoresToSave = abilityScores.map((key, value) {
  //       final bonus = bonuses[key] ?? 0;
  //       return MapEntry(key, value + bonus);
  //     });

  //     await docRef.set(
  //       {'abilityScores': scoresToSave},
  //       SetOptions(merge: true),
  //     );

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Data saved successfully!")),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to save data: $e")),
  //     );
  //   }
  // }

  Widget buildDiceRoller() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/dice$dice_no1.png',
              width: 100,
              height: 100,
              color: customColor,
            ),
            const SizedBox(width: 20),
            Image.asset(
              'assets/dice$dice_no2.png',
              width: 100,
              height: 100,
              color: customColor,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/dice$dice_no3.png',
              width: 100,
              height: 100,
              color: customColor,
            ),
            const SizedBox(width: 20),
            Image.asset(
              'assets/dice$dice_no4.png',
              width: 100,
              height: 100,
              color: customColor,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: customColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "$currentRoll",
              style: TextStyle(
                  fontSize: 20,
                  color: customColor,
                  fontWeight: FontWeight.bold),
            )),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(width: 5),
            ButtonWithPadding(
              onPressed: _rollDice,
              textContent: 'Roll Dice',
            ),
            const Spacer(),
            DropdownButton<String>(
              value: _chosenAbility,
              items: rolledScores.keys
                  .map((key) => DropdownMenuItem(
                value: key,
                child: Text(key),
              ))
                  .toList(),
              onChanged: (value) => setState(() => _chosenAbility = value!),
            ),
            const Spacer(),
            ButtonWithPadding(
              onPressed: _saveRoll,
              textContent: 'Save Roll',
            ),
            const SizedBox(width: 5),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          width: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Text("Assigned Abilities:"),
              for (var key in rolledScores.keys)
                Text("$key: ${rolledScores[key]!}"),
            ],
          ),
        ),
      ],
    );
  }
}








// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dnd_character_creator/screens/dnd_forms/equipment_selection.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:dnd_character_creator/widgets/buttons/button_with_padding.dart';
// import 'dart:math';
// import 'package:dnd_character_creator/widgets/buttons/navigation_button.dart';

// import 'package:dnd_character_creator/widgets/buttons/expandable_fab.dart';
// import 'package:dnd_character_creator/data/race_data.dart';
// import 'package:dnd_character_creator/widgets/dnd_form_widgets/main_drawer.dart';

// class StatsScreen extends StatefulWidget {
//   const StatsScreen(
//       {super.key, required this.characterName, required this.selectedRace});

//   final characterName;
//   final selectedRace;

//   @override
//   State<StatsScreen> createState() => _StatsScreenState();
// }

// class _StatsScreenState extends State<StatsScreen> {
//   late String _selectedRace; // TODO: Fetch from firestore
//   final Map<String, int> abilityScores = {};
//   int index = 0;
//   final Color customColor = const Color.fromARGB(255, 138, 28, 20);
//   int pointsLeft = 27; // For PointBuy
//   final Map<String, int> baseScores = {
//     'Strength': 8,
//     'Dexterity': 8,
//     'Constitution': 8,
//     'Wisdom': 8,
//     'Intelligence': 8,
//     'Charisma': 8,
//   }; // point buy

//   final Map<String, int> rolledScores = {
//     'Strength': 0,
//     'Dexterity': 0,
//     'Constitution': 0,
//     'Wisdom': 0,
//     'Intelligence': 0,
//     'Charisma': 0,
//   }; //rolling

//   final Map<String, int> standardScores = {
//     'Strength': 15,
//     'Dexterity': 14,
//     'Constitution': 13,
//     'Wisdom': 12,
//     'Intelligence': 10,
//     'Charisma': 8,
//   }; //standard array

//   //for standard array
//   List<int> standardArray = [15, 14, 13, 12, 10, 8];
//   List<String> standardAbilities = [
//     'Strength',
//     'Dexterity',
//     'Constitution',
//     'Wisdom',
//     'Intelligence',
//     'Charisma'
//   ];
//   List<bool> readyStatuses = [true, true, true, true, true, true];

//   final List<String> _pickedAbilities = []; // rolling
//   String _chosenAbility = 'Strength'; // rolling
//   int dice_no1 = 1, dice_no2 = 1, dice_no3 = 1, dice_no4 = 1;
//   int currentRoll = 0;

//   void showSnackbar(String message) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         duration: const Duration(seconds: 3),
//         content: Text(message),
//       ),
//     );
//   }

//   void _updateScores(String key, int value) {
//     setState(() {
//       abilityScores[key] = value;
//     });
//   }

//   void _incrementSkill(String skill) {
//     final score = baseScores[skill]! + 1;
//     final cost = (score <= 13) ? 1 : 2;

//     setState(() {
//       if (pointsLeft >= cost && baseScores[skill]! < 15) {
//         baseScores[skill] = score;
//         pointsLeft -= cost;
//         _updateScores(skill, baseScores[skill]!);
//       } else {
//         showSnackbar('You do not have enough points left to increase $skill!');
//       }
//     });
//   }

//   Future<void> _getRace() async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     print('User not authenticated');
//     return;
//   }
//   final userId = user.uid;

//   try {
//     final firestore = FirebaseFirestore.instance;
//     final docRef = firestore
//         .collection('app_user_profiles')
//         .doc(userId)
//         .collection('characters')
//         .doc(widget.characterName);

//     final docSnapshot = await docRef.get();
//     if (docSnapshot.exists) {
//       final data = docSnapshot.data();
//       if (data != null && data.containsKey('race')) {
//         final race = data['race'];
//         setState(() {
//           _selectedRace = race;
//         });
//       } else {
//         print('Race field does not exist in the document');
//       }
//     } else {
//       print('Document does not exist');
//     }
//   } catch (e) {
//     print('Error getting race: $e');
//   }
// }

//   void _decrementSkill(String skill) {
//     final score = baseScores[skill]! - 1;
//     final cost = (baseScores[skill]! <= 14) ? 1 : 2;

//     setState(() {
//       if (score >= 8) {
//         baseScores[skill] = score;
//         pointsLeft += cost;
//         _updateScores(skill, baseScores[skill]!);
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _rollDice();
//     _getRace();
//   }

//   void _rollDice() {
//     setState(() {
//       dice_no1 = Random().nextInt(6) + 1;
//       dice_no2 = Random().nextInt(6) + 1;
//       dice_no3 = Random().nextInt(6) + 1;
//       dice_no4 = Random().nextInt(6) + 1;

//       Future.delayed(const Duration(milliseconds: 100), () {
//         setState(() {
//           dice_no1 = Random().nextInt(6) + 1;
//           dice_no2 = Random().nextInt(6) + 1;
//           dice_no3 = Random().nextInt(6) + 1;
//           dice_no4 = Random().nextInt(6) + 1;
//           currentRoll = dice_no1 + dice_no2 + dice_no3 + dice_no4;
//         });
//       });

//       Future.delayed(const Duration(milliseconds: 200), () {
//         setState(() {
//           dice_no1 = Random().nextInt(6) + 1;
//           dice_no2 = Random().nextInt(6) + 1;
//           dice_no3 = Random().nextInt(6) + 1;
//           dice_no4 = Random().nextInt(6) + 1;
//           currentRoll = dice_no1 + dice_no2 + dice_no3 + dice_no4;
//         });
//       });

//       Future.delayed(const Duration(milliseconds: 300), () {
//         setState(() {
//           dice_no1 = Random().nextInt(6) + 1;
//           dice_no2 = Random().nextInt(6) + 1;
//           dice_no3 = Random().nextInt(6) + 1;
//           dice_no4 = Random().nextInt(6) + 1;
//           currentRoll = dice_no1 + dice_no2 + dice_no3 + dice_no4;
//         });
//       });

//       Future.delayed(const Duration(milliseconds: 400), () {
//         setState(() {
//           dice_no1 = Random().nextInt(6) + 1;
//           dice_no2 = Random().nextInt(6) + 1;
//           dice_no3 = Random().nextInt(6) + 1;
//           dice_no4 = Random().nextInt(6) + 1;
//           currentRoll = dice_no1 + dice_no2 + dice_no3 + dice_no4;
//         });
//       });
//     });
//   }

//   void _saveRoll() {
//     if (!_pickedAbilities.contains(_chosenAbility)) {
//       setState(() {
//         rolledScores[_chosenAbility] = currentRoll;
//         _pickedAbilities.add(_chosenAbility);
//       });
//     } else {
//       showSnackbar("Ability already assigned!");
//     }
//   }

//   Map<String, int> _applyRaceBonuses(Map<String, int> scores) {
//     // Fetch race data
//     final raceData = RaceData[_selectedRace];
//     if (raceData == null) return scores;

//     // Default bonuses for Human
//     Map<String, int> bonuses = raceData['abilityScoreIncrease'] ?? {};
//     if (_selectedRace == 'Human') {
//       bonuses = {
//         'Strength': 1,
//         'Dexterity': 1,
//         'Constitution': 1,
//         'Wisdom': 1,
//         'Intelligence': 1,
//         'Charisma': 1,
//       };
//     }

//     // Apply bonuses
//     return scores
//         .map((key, value) => MapEntry(key, value + (bonuses[key] ?? 0)));
//   }

//   void _showFinalScores() {
//     final scoresToUse = index == 0
//         ? baseScores
//         : index == 1
//             ? rolledScores
//             : standardScores;
//     final finalScores = _applyRaceBonuses(scoresToUse);

//     // Display the final scores
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Final Scores"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: finalScores.entries
//               .map((entry) => Text("${entry.key}: ${entry.value}"))
//               .toList(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               //TODO: Send final scores to firestore
//               _saveSelections();
//               //TODO: Push next screen
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => EquipmentSelection(characterName: widget.characterName, selectedRace: widget.selectedRace, abilityScores: finalScores)));
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => EquipmentSelection(
//                           characterName: widget.characterName)));
//             },
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Stats")),
//       drawer: const MainDrawer(),
//       bottomNavigationBar: Row(
//         children: [
//           NavigationButton(
//             textContent: "Back",
//             onPressed: () => Navigator.pop(context),
//           ),
//           const SizedBox(width: 30),
//           NavigationButton(
//             onPressed: (index == 2 &&
//                     !(readyStatuses[0] &&
//                         readyStatuses[1] &&
//                         readyStatuses[2] &&
//                         readyStatuses[3] &&
//                         readyStatuses[4] &&
//                         readyStatuses[5]))
//                 ? () {
//                     showSnackbar(
//                         'You haven\'t picked a skill for each option!');
//                   }
//                 : _showFinalScores,
//             textContent: 'Next',
//           ),
//         ],
//       ),
//       floatingActionButton: ExpandableFab(
//         distance: 112,
//         children: [
//           ActionButton(
//             onPressed: () => setState(() => index = 0),
//             icon: const Icon(Icons.edit_note),
//           ),
//           ActionButton(
//             onPressed: () => setState(() => index = 1),
//             icon: const Icon(Icons.casino_outlined),
//           ),
//           ActionButton(
//             onPressed: () => setState(() => index = 2),
//             icon: const Icon(Icons.check_box_outlined),
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: index,
//         children: [
//           buildPointBuy(),
//           buildDiceRoller(),
//           buildStandardArray(),
//         ],
//       ),
//     );
//   }

//   void updateReadyStatus() {
//     for (int i = 0; i < standardAbilities.length; i++) {
//       // Get the current ability at this index
//       String currentAbility = standardAbilities[i];

//       // Check if the ability is unique (not present elsewhere)
//       bool isUnique = true;
//       for (int j = 0; j < standardAbilities.length; j++) {
//         if (i != j && currentAbility == standardAbilities[j]) {
//           isUnique = false;
//           break;
//         }
//       }

//       // Check if the corresponding score is valid
//       bool hasValidScore = standardScores[currentAbility] != null &&
//           standardScores[currentAbility]! >= 0;

//       // Update the readiness status for this index
//       readyStatuses[i] = isUnique && hasValidScore;
//     }
//   }

//   Widget buildStandardArray() {
//     return Center(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: customColor, width: 5),
//                         borderRadius: BorderRadius.circular(10),
//                         color: (readyStatuses[0])
//                             ? Colors.white
//                             : customColor.withOpacity(0.75),
//                       ),
//                       width: 100,
//                       height: 100,
//                       child: const Center(
//                         child: Text('15',
//                             style:
//                                 TextStyle(color: Colors.black, fontSize: 50)),
//                       ),
//                     ),
//                     DropdownButton(
//                       value: standardAbilities[0],
//                       items: const [
//                         DropdownMenuItem(
//                           child: Text('Strength'),
//                           value: 'Strength',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Dexterity'),
//                           value: 'Dexterity',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Constitution'),
//                           value: 'Constitution',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Wisdom'),
//                           value: 'Wisdom',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Intelligence'),
//                           value: 'Intelligence',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Charisma'),
//                           value: 'Charisma',
//                         ),
//                       ],
//                       onChanged: (ability) {
//                         setState(() {
//                           // Find the ability currently assigned to this score and remove it
//                           String previousAbility = standardAbilities[0];
//                           if (standardScores.containsKey(previousAbility)) {
//                             standardScores.remove(previousAbility);
//                           }

//                           // Assign the new ability to this score
//                           standardAbilities[0] = ability!;
//                           standardScores[ability] = standardArray[0];

//                           // Ensure UI updates correctly
//                           updateReadyStatus();
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: customColor, width: 5),
//                         borderRadius: BorderRadius.circular(10),
//                         color: (readyStatuses[1])
//                             ? Colors.white
//                             : customColor.withOpacity(0.75),
//                       ),
//                       width: 100,
//                       height: 100,
//                       child: const Center(
//                         child: Text('14',
//                             style:
//                                 TextStyle(color: Colors.black, fontSize: 50)),
//                       ),
//                     ),
//                     DropdownButton(
//                       value: standardAbilities[1],
//                       items: const [
//                         DropdownMenuItem(
//                           child: Text('Strength'),
//                           value: 'Strength',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Dexterity'),
//                           value: 'Dexterity',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Constitution'),
//                           value: 'Constitution',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Wisdom'),
//                           value: 'Wisdom',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Intelligence'),
//                           value: 'Intelligence',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Charisma'),
//                           value: 'Charisma',
//                         ),
//                       ],
//                       onChanged: (ability) {
//                         setState(() {
//                           // Find the ability currently assigned to this score and remove it
//                           String previousAbility = standardAbilities[1];
//                           if (standardScores.containsKey(previousAbility)) {
//                             standardScores.remove(previousAbility);
//                           }

//                           // Assign the new ability to this score
//                           standardAbilities[1] = ability!;
//                           standardScores[ability] = standardArray[1];

//                           // Ensure UI updates correctly
//                           updateReadyStatus();
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: customColor, width: 5),
//                         borderRadius: BorderRadius.circular(10),
//                         color: (readyStatuses[2])
//                             ? Colors.white
//                             : customColor.withOpacity(0.75),
//                       ),
//                       width: 100,
//                       height: 100,
//                       child: const Center(
//                         child: Text('13',
//                             style:
//                                 TextStyle(color: Colors.black, fontSize: 50)),
//                       ),
//                     ),
//                     DropdownButton(
//                       value: standardAbilities[2],
//                       items: const [
//                         DropdownMenuItem(
//                           child: Text('Strength'),
//                           value: 'Strength',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Dexterity'),
//                           value: 'Dexterity',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Constitution'),
//                           value: 'Constitution',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Wisdom'),
//                           value: 'Wisdom',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Intelligence'),
//                           value: 'Intelligence',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Charisma'),
//                           value: 'Charisma',
//                         ),
//                       ],
//                       onChanged: (ability) {
//                         setState(() {
//                           // Find the ability currently assigned to this score and remove it
//                           String previousAbility = standardAbilities[2];
//                           if (standardScores.containsKey(previousAbility)) {
//                             standardScores.remove(previousAbility);
//                           }

//                           // Assign the new ability to this score
//                           standardAbilities[2] = ability!;
//                           standardScores[ability] = standardArray[2];

//                           // Ensure UI updates correctly
//                           updateReadyStatus();
//                         });
//                       },
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: customColor, width: 5),
//                         borderRadius: BorderRadius.circular(10),
//                         color: (readyStatuses[3])
//                             ? Colors.white
//                             : customColor.withOpacity(0.75),
//                       ),
//                       width: 100,
//                       height: 100,
//                       child: const Center(
//                         child: Text('12',
//                             style:
//                                 TextStyle(color: Colors.black, fontSize: 50)),
//                       ),
//                     ),
//                     DropdownButton(
//                       value: standardAbilities[3],
//                       items: const [
//                         DropdownMenuItem(
//                           child: Text('Strength'),
//                           value: 'Strength',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Dexterity'),
//                           value: 'Dexterity',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Constitution'),
//                           value: 'Constitution',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Wisdom'),
//                           value: 'Wisdom',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Intelligence'),
//                           value: 'Intelligence',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Charisma'),
//                           value: 'Charisma',
//                         ),
//                       ],
//                       onChanged: (ability) {
//                         setState(() {
//                           // Find the ability currently assigned to this score and remove it
//                           String previousAbility = standardAbilities[3];
//                           if (standardScores.containsKey(previousAbility)) {
//                             standardScores.remove(previousAbility);
//                           }

//                           // Assign the new ability to this score
//                           standardAbilities[3] = ability!;
//                           standardScores[ability] = standardArray[3];

//                           // Ensure UI updates correctly
//                           updateReadyStatus();
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: customColor, width: 5),
//                         borderRadius: BorderRadius.circular(10),
//                         color: (readyStatuses[4])
//                             ? Colors.white
//                             : customColor.withOpacity(0.75),
//                       ),
//                       width: 100,
//                       height: 100,
//                       child: const Center(
//                         child: Text('10',
//                             style:
//                                 TextStyle(color: Colors.black, fontSize: 50)),
//                       ),
//                     ),
//                     DropdownButton(
//                       value: standardAbilities[4],
//                       items: const [
//                         DropdownMenuItem(
//                           child: Text('Strength'),
//                           value: 'Strength',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Dexterity'),
//                           value: 'Dexterity',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Constitution'),
//                           value: 'Constitution',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Wisdom'),
//                           value: 'Wisdom',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Intelligence'),
//                           value: 'Intelligence',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Charisma'),
//                           value: 'Charisma',
//                         ),
//                       ],
//                       onChanged: (ability) {
//                         setState(() {
//                           // Find the ability currently assigned to this score and remove it
//                           String previousAbility = standardAbilities[4];
//                           if (standardScores.containsKey(previousAbility)) {
//                             standardScores.remove(previousAbility);
//                           }

//                           // Assign the new ability to this score
//                           standardAbilities[4] = ability!;
//                           standardScores[ability] = standardArray[4];

//                           // Ensure UI updates correctly
//                           updateReadyStatus();
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: customColor, width: 5),
//                         borderRadius: BorderRadius.circular(10),
//                         color: (readyStatuses[5])
//                             ? Colors.white
//                             : customColor.withOpacity(0.75),
//                       ),
//                       width: 100,
//                       height: 100,
//                       child: const Center(
//                         child: Text('8',
//                             style:
//                                 TextStyle(color: Colors.black, fontSize: 50)),
//                       ),
//                     ),
//                     DropdownButton(
//                       value: standardAbilities[5],
//                       items: const [
//                         DropdownMenuItem(
//                           child: Text('Strength'),
//                           value: 'Strength',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Dexterity'),
//                           value: 'Dexterity',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Constitution'),
//                           value: 'Constitution',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Wisdom'),
//                           value: 'Wisdom',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Intelligence'),
//                           value: 'Intelligence',
//                         ),
//                         DropdownMenuItem(
//                           child: Text('Charisma'),
//                           value: 'Charisma',
//                         ),
//                       ],
//                       onChanged: (ability) {
//                         setState(() {
//                           // Find the ability currently assigned to this score and remove it
//                           String previousAbility = standardAbilities[5];
//                           if (standardScores.containsKey(previousAbility)) {
//                             standardScores[previousAbility] = -12;
//                           }

//                           // Assign the new ability to this score
//                           standardAbilities[5] = ability!;
//                           standardScores[ability] = standardArray[5];

//                           // Ensure UI updates correctly
//                           updateReadyStatus();
//                         });
//                       },
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildPointBuy() {
//     return Center(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             for (var row in [
//               ["Strength", "Dexterity"],
//               ["Constitution", "Wisdom"],
//               ["Intelligence", "Charisma"],
//             ])
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: row.map((label) {
//                   return Column(
//                     children: [
//                       Text(label,
//                           style: const TextStyle(
//                               color: Colors.black, fontSize: 18)),
//                       Row(
//                         children: [
//                           IconButton(
//                             onPressed: () => _decrementSkill(label),
//                             icon: Icon(Icons.arrow_downward_sharp,
//                                 color: customColor),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               color: customColor,
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(10)),
//                             ),
//                             height: 100,
//                             width: 100,
//                             child: Center(
//                               child: Text(
//                                 "${baseScores[label]!}",
//                                 style: const TextStyle(
//                                     color: Colors.white, fontSize: 50),
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () => _incrementSkill(label),
//                             icon: Icon(Icons.arrow_upward_sharp,
//                                 color: customColor),
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             const SizedBox(height: 16),
//             Text(
//               "Points Left: $pointsLeft",
//               style: const TextStyle(color: Colors.black, fontSize: 20),
//             ),
//             const SizedBox(height: 75),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _saveSelections() async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     print('User not authenticated');
//     return;
//   }
//   final userId = user.uid;

//   try {
//     final firestore = FirebaseFirestore.instance;
//     final docRef = firestore
//         .collection('app_user_profiles')
//         .doc(userId)
//         .collection('characters')
//         .doc(widget.characterName);

//     // Define all ability scores and default them to 0 if not set
//     final Map<String, int> defaultAbilityScores = {
//       'Strength': 8,
//       'Dexterity': 8,
//       'Constitution': 8,
//       'Intelligence': 8,
//       'Wisdom': 8,
//       'Charisma': 8,
//     };

//     // Merge current abilityScores with defaults (ensures every score is included)
//     final updatedAbilityScores = {
//       for (final key in defaultAbilityScores.keys)
//         key: (abilityScores[key] ?? defaultAbilityScores[key])! +
//             ((RaceData[widget.selectedRace]?['abilityScoreIncrease']?[key]) ??
//                 0),
//     };

//     // Save to Firestore
//     await docRef.set(
//       {'abilityScores': updatedAbilityScores},
//       SetOptions(merge: true),
//     );

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Data saved successfully!")),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Failed to save data: $e")),
//     );
//   }
// }


//   // Future<void> _saveSelections() async {
//   //   final user = FirebaseAuth.instance.currentUser;
//   //   if (user == null) {
//   //     print('User not authenticated');
//   //     return;
//   //   }
//   //   final userId = user.uid;

//   //   try {
//   //     final firestore = FirebaseFirestore.instance;
//   //     final docRef = firestore
//   //         .collection('app_user_profiles')
//   //         .doc(userId)
//   //         .collection('characters')
//   //         .doc(widget.characterName);

//   //     // Save the scores with race bonuses applied
//   //     final raceData = RaceData[widget.selectedRace];
//   //     final Map<String, int> bonuses = raceData?['abilityScoreIncrease'] ?? {};
//   //     final Map<String, int> scoresToSave = abilityScores.map((key, value) {
//   //       final bonus = bonuses[key] ?? 0;
//   //       return MapEntry(key, value + bonus);
//   //     });

//   //     await docRef.set(
//   //       {'abilityScores': scoresToSave},
//   //       SetOptions(merge: true),
//   //     );

//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text("Data saved successfully!")),
//   //     );
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text("Failed to save data: $e")),
//   //     );
//   //   }
//   // }

//   Widget buildDiceRoller() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/dice$dice_no1.png',
//               width: 100,
//               height: 100,
//               color: customColor,
//             ),
//             const SizedBox(width: 20),
//             Image.asset(
//               'assets/dice$dice_no2.png',
//               width: 100,
//               height: 100,
//               color: customColor,
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/dice$dice_no3.png',
//               width: 100,
//               height: 100,
//               color: customColor,
//             ),
//             const SizedBox(width: 20),
//             Image.asset(
//               'assets/dice$dice_no4.png',
//               width: 100,
//               height: 100,
//               color: customColor,
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         Container(
//             alignment: Alignment.center,
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               border: Border.all(color: customColor, width: 2),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               "$currentRoll",
//               style: TextStyle(
//                   fontSize: 20,
//                   color: customColor,
//                   fontWeight: FontWeight.bold),
//             )),
//         const SizedBox(height: 20),
//         Row(
//           children: [
//             const SizedBox(width: 5),
//             ButtonWithPadding(
//               onPressed: _rollDice,
//               textContent: 'Roll Dice',
//             ),
//             const Spacer(),
//             DropdownButton<String>(
//               value: _chosenAbility,
//               items: rolledScores.keys
//                   .map((key) => DropdownMenuItem(
//                         value: key,
//                         child: Text(key),
//                       ))
//                   .toList(),
//               onChanged: (value) => setState(() => _chosenAbility = value!),
//             ),
//             const Spacer(),
//             ButtonWithPadding(
//               onPressed: _saveRoll,
//               textContent: 'Save Roll',
//             ),
//             const SizedBox(width: 5),
//           ],
//         ),
//         const SizedBox(height: 20),
//         Container(
//           padding: const EdgeInsets.all(8),
//           alignment: Alignment.center,
//           width: 300,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.black),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Column(
//             children: [
//               const Text("Assigned Abilities:"),
//               for (var key in rolledScores.keys)
//                 Text("$key: ${rolledScores[key]!}"),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }




