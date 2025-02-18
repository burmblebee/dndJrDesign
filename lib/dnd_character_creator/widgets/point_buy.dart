import 'package:flutter/material.dart';

import '../Data/race_data.dart';

class PointBuy extends StatefulWidget {
  PointBuy({super.key, required this.customColor, required this.showSnackbar, required this.selectedRace});

  final Color customColor;
  final String selectedRace;

  final Function(String) showSnackbar;


  @override
  State<PointBuy> createState() => _PointBuyState();
}

class _PointBuyState extends State<PointBuy> {
  final Map<String, int> abilityScores = {
    'Strength': 8,
    'Dexterity': 8,
    'Constitution': 8,
    'Wisdom': 8,
    'Intelligence': 8,
    'Charisma': 8,
  };

  final Map<String, int> maxAbilityScores = {
    'Strength': 15,
    'Dexterity': 15,
    'Constitution': 15,
    'Wisdom': 15,
    'Intelligence': 15,
    'Charisma': 15,
  };

  Map<String, int> originalAbilityScores = {};

  Map<int, int> incrementCost = {
    8: 0,
    9: 1,
    10: 1,
    11: 1,
    12: 1,
    13: 1,
    14: 2,
    15: 2,
  };

  Map<String, int> increases = {
    'Strength': 0,
    'Dexterity': 0,
    'Constitution': 0,
    'Wisdom': 0,
    'Intelligence': 0,
    'Charisma': 0,
  };

  int pointsLeft = 27;
  @override
  void initState() {
    super.initState();
    findGivenStats();
    originalAbilityScores = Map.from(abilityScores);
  }

  void incrementSkill(String skill) {
    int? score = abilityScores[skill]! + 1;
    int cost = incrementCost[score! - increases[skill]!]!;

    setState(() {
      if (pointsLeft >= cost! && abilityScores[skill]! < maxAbilityScores[skill]!) {
        abilityScores[skill] = abilityScores[skill]! + 1;
        pointsLeft -= cost;
      }
      else{
        widget.showSnackbar('You do not have enough points left to increase $skill!');
      }
    });
  }
  void findGivenStats() {
    final Map<String, dynamic>? raceData = RaceData[widget.selectedRace];
    final Map<String, dynamic>? abilityScoreIncrease = raceData?['abilityScoreIncrease'];

    for (String ability in abilityScoreIncrease!.keys) {
      int increaseValue = abilityScoreIncrease[ability];

      if (ability == 'All') {
        abilityScores.updateAll((key, value) => value + increaseValue);
        maxAbilityScores.updateAll((key, value) => value + increaseValue);
        increases.updateAll((key, value) => value + increaseValue);
      } else if (abilityScores.containsKey(ability)) {
        abilityScores[ability] = abilityScores[ability]! + increaseValue;
        maxAbilityScores[ability] = maxAbilityScores[ability]! + increaseValue;
        increases[ability] = increases[ability]! + increaseValue;
      }
    }
  }

  void decrementSkill(String skill) {
    int? currentScore = abilityScores[skill];
    int? cost = incrementCost[currentScore!]! - increases[skill]!;

    setState(() {
      if (abilityScores[skill]! > originalAbilityScores[skill]!) {
        abilityScores[skill] = abilityScores[skill]! - 1;
        pointsLeft += cost!;
      }
    });
  }

  Widget buildSkillRow(
      String label, int skillValue, Function increment, Function decrement) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 18)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                decrement();
              },
              icon: Icon(Icons.arrow_downward_sharp, color: widget.customColor),
            ),
            Container(
              decoration: BoxDecoration(
                color: widget.customColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              height: 100,
              width: 100,
              child: Center(
                child: Text(
                  "$skillValue",
                  style: const TextStyle(color: Colors.white, fontSize: 50),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                increment();
              },
              icon: Icon(Icons.arrow_upward_sharp, color: widget.customColor),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              buildSkillRow(
                "Strength",
                abilityScores['Strength']!,
                    () => incrementSkill("Strength"),
                    () => decrementSkill("Strength"),
              ),
              const SizedBox(width: 8),
              buildSkillRow(
                "Dexterity",
                abilityScores['Dexterity']!,
                    () => incrementSkill("Dexterity"),
                    () => decrementSkill("Dexterity"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              buildSkillRow(
                "Constitution",
                abilityScores['Constitution']!,
                    () => incrementSkill("Constitution"),
                    () => decrementSkill("Constitution"),
              ),
              const SizedBox(width: 8),
              buildSkillRow(
                "Wisdom",
                abilityScores['Wisdom']!,
                    () => incrementSkill("Wisdom"),
                    () => decrementSkill("Wisdom"),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              buildSkillRow(
                "Intelligence",
                abilityScores['Intelligence']!,
                    () => incrementSkill("Intelligence"),
                    () => decrementSkill("Intelligence"),
              ),
              const SizedBox(width: 8),
              buildSkillRow(
                "Charisma",
                abilityScores['Charisma']!,
                    () => incrementSkill("Charisma"),
                    () => decrementSkill("Charisma"),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.customColor,
                width: 3,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            height: 50,
            width: 300,
            child: Center(
              child: Text(
                "Points Left: $pointsLeft",
                style: TextStyle(color: widget.customColor, fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}