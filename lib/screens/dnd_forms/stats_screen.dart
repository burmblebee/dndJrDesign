import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/providers/character_provider.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_appbar.dart';
import '../../screens/dnd_forms/equipment_selection.dart';
import 'package:flutter/material.dart';
import '../../widgets/buttons/button_with_padding.dart';
import 'dart:math';
import '../../widgets/buttons/navigation_button.dart';
import '../../widgets/buttons/expandable_fab.dart';
import '../../data/character creator data/race_data.dart';
import '../../widgets/navigation/main_drawer.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  late String _selectedRace;

  late Map<String, int> abilityScores = {
    'Strength': 8,
    'Dexterity': 8,
    'Constitution': 8,
    'Wisdom': 8,
    'Intelligence': 8,
    'Charisma': 8,
  }; // to save_
  int index = 0;

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

  Future<void> pushCharacterToFirebase(String userId) async {
    try {
      final character =
          ref.read(characterProvider); // Retrieve character data from provider
      final docRef = FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(userId)
          .collection('characters')
          .doc(character.name); // Use character.name instead of state.name

      await docRef.set(
          character.toMap(),
          SetOptions(
              merge: true)); // Use character.toMap() instead of state.toMap()
      print('Character data pushed to Firebase successfully.');
    } catch (e) {
      print('Error pushing character data to Firebase: $e');
    }
  }

  Map<String, int> _applyRaceBonuses(Map<String, int> scores) {
    // Fetch race data
    final raceData = RaceData[_selectedRace];
    if (raceData == null) return scores;

    // Get the ability score increases for the selected race
    final Map<String, int> bonuses = raceData['abilityScoreIncrease'] ?? {};

    // Apply the bonuses to the scores
    return scores
        .map((key, value) => MapEntry(key, value + (bonuses[key] ?? 0)));
  }

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

  void _decrementSkill(String skill) {
    final score = baseScores[skill]! - 1;
    final cost = (baseScores[skill]! < 14) ? 1 : 2;

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
    _selectedRace = ref
        .read(characterProvider)
        .race; // Initialize _selectedRace in initState
    _rollDice();
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
              // Navigate to EquipmentSelection
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EquipmentSelection(),
                ),
              );
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
      appBar: MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      // bottomNavigationBar: Row(
      //   children: [
      //     NavigationButton(
      //       textContent: "Back",
      //       onPressed: () => Navigator.pop(context),
      //     ),
      //     const SizedBox(width: 30),
      //     NavigationButton(
      //       onPressed: (index == 2 &&
      //               !(readyStatuses[0] &&
      //                   readyStatuses[1] &&
      //                   readyStatuses[2] &&
      //                   readyStatuses[3] &&
      //                   readyStatuses[4] &&
      //                   readyStatuses[5]))
      //           ? () {
      //               showSnackbar(
      //                   'You haven\'t picked a skill for each option!');
      //             }
      //           : _showFinalScores,
      //       textContent: 'Next',
      //     ),
      //   ],
      // ),
      floatingActionButton: ExpandableFab(
        distance: 116,
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
                        border: Border.all(color: Theme.of(context).iconTheme.color!, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        color: (readyStatuses[0])
                            ? Colors.white
                            : Theme.of(context).iconTheme.color!.withAlpha(180),
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
                        border: Border.all(color: Theme.of(context).iconTheme.color!, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        color: (readyStatuses[1])
                            ? Colors.white
                            : Theme.of(context).iconTheme.color!.withAlpha(180),
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
                        border: Border.all(color: Theme.of(context).iconTheme.color!, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        color: (readyStatuses[2])
                            ? Colors.white
                            : Theme.of(context).iconTheme.color!.withAlpha(180),
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
                        border: Border.all(color: Theme.of(context).iconTheme.color!, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        color: (readyStatuses[3])
                            ? Colors.white
                            : Theme.of(context).iconTheme.color!.withAlpha(180),
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
                        border: Border.all(color: Theme.of(context).iconTheme.color!, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        color: (readyStatuses[4])
                            ? Colors.white
                            : Theme.of(context).iconTheme.color!.withAlpha(180),
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
                        border: Border.all(color: Theme.of(context).iconTheme.color!, width: 5),
                        borderRadius: BorderRadius.circular(10),
                        color: (readyStatuses[5])
                            ? Colors.white
                            : Theme.of(context).iconTheme.color!.withAlpha(180),
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
                      // you left your laptop open again
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
    final elevatedButtonColor = Theme.of(context)
            .elevatedButtonTheme
            .style
            ?.backgroundColor
            ?.resolve({}) ??
        Colors.grey;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...[
              "Strength",
              "Dexterity",
              "Constitution",
              "Wisdom",
              "Intelligence",
              "Charisma"
            ].map((label) {
              int baseScore = baseScores[label]!;
              int racialBonus =
                  (RaceData[_selectedRace]!['abilityScoreIncrease'][label] ?? 0)
                      .toInt();
              int finalScore = baseScore + racialBonus;

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(label, style: const TextStyle(fontSize: 18)),
                  subtitle: Text("Base: $baseScore  |  Racial: +$racialBonus"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _decrementSkill(label),
                        icon: Icon(Icons.remove_circle, color: Theme.of(context).iconTheme.color!),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).iconTheme.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "$finalScore",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _incrementSkill(label),
                        icon: Icon(Icons.add_circle, color: Theme.of(context).iconTheme.color),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title:
                    const Text("Points Left", style: TextStyle(fontSize: 20)),
                trailing: Text(
                  "$pointsLeft",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Final Ability Scores:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...[
                      "Strength",
                      "Dexterity",
                      "Constitution",
                      "Wisdom",
                      "Intelligence",
                      "Charisma"
                    ].map(
                      (attr) {
                        num finalScore = baseScores[attr]! +
                            (RaceData[_selectedRace]!['abilityScoreIncrease']
                                    [attr] ??
                                0);
                        return ListTile(
                          title: Text(attr),
                          trailing: Text(
                            "$finalScore",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                const SizedBox(width: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    // pushCharacterToFirebase('12345');
                    if (pointsLeft > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "You still have $pointsLeft points left to allocate!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                    ref.read(characterProvider.notifier).updateAbilityScores({
                      for (var attr in [
                        "Strength",
                        "Dexterity",
                        "Constitution",
                        "Wisdom",
                        "Intelligence",
                        "Charisma"
                      ])
                        attr: baseScores[attr]! +
                            (RaceData[_selectedRace]!['abilityScoreIncrease']
                                        [attr] ??
                                    0)
                                .toInt()
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EquipmentSelection(),
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
          ],
        ),
      ),
    );
  }

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
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 20),
            Image.asset(
              'assets/dice$dice_no2.png',
              width: 100,
              height: 100,
              color: Theme.of(context).iconTheme.color,
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
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 20),
            Image.asset(
              'assets/dice$dice_no4.png',
              width: 100,
              height: 100,
              color: Theme.of(context).iconTheme.color,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).iconTheme.color!, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "$currentRoll",
              style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).iconTheme.color,
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
