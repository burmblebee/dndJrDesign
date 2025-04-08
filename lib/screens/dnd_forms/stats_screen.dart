import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/providers/character_provider.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/specifics_screen.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/starting_equipment_selection.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_appbar.dart';
import '../../screens/dnd_forms/equipment_selection.dart';
import 'package:flutter/material.dart';
import '../../widgets/buttons/button_with_padding.dart';
import 'dart:math';
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
  }; // To save ability scores
  int pointsLeft = 27; // For PointBuy

  final Map<String, int> baseScores = {
    'Strength': 8,
    'Dexterity': 8,
    'Constitution': 8,
    'Wisdom': 8,
    'Intelligence': 8,
    'Charisma': 8,
  }; // Point buy base scores

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
    _selectedRace =
        ref.read(characterProvider).race; // Initialize _selectedRace
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
          buildPointBuy(),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SpecificsScreen())),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text("Back"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: elevatedButtonColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Update the provider with the final ability scores
                    ref.read(characterProvider.notifier).updateAbilityScores(
                          _applyRaceBonuses(baseScores),
                        );

                    // Show the final scores popup
                    _showFinalScores();
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

  void _showFinalScores() {
    final finalScores = _applyRaceBonuses(baseScores);

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

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StartingEquipmentSelection(),
                ),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget buildPointBuy() {
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
                        icon: Icon(Icons.remove_circle,
                            color: Theme.of(context).iconTheme.color!),
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
                        icon: Icon(Icons.add_circle,
                            color: Theme.of(context).iconTheme.color),
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
            SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}
