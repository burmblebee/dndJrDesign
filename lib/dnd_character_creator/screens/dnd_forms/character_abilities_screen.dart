import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class CharacterAbilities extends StatefulWidget {

  @override
  State<CharacterAbilities> createState() => _CharacterAbilitiesState();
}

class _CharacterAbilitiesState extends State<CharacterAbilities> {
  @override
  void initState() {
    super.initState();
    setModifiers();
    abilityLabels = abilityScores.keys.toList();
    abilityValues = abilityScores.values.map((value) => value.toDouble()).toList();

  }

  final int proficiencyBonus = 2;
  Color customColor = const Color.fromARGB(255, 138, 28, 20);

  late var abilityLabels;
  late var abilityValues;

//TODO: snag all this from firestore pretty please thank you very much
  final Map<String, int> abilityScores = {
    // 'Strength': 8,
    // 'Dexterity': 16,
    // 'Constitution': 14,
    // 'Intelligence': 10,
    // 'Wisdom': 14,
    // 'Charisma': 12
  };
  final List<String> chosenProficiencies = [
    // "Acrobatics",
    // "Perception",
    // "Stealth",
    // "Persuasion",
    // "Investigation",
  ];
  final Map<String, int> modifiers = {
    'Strength': 0,
    'Dexterity': 0,
    'Constitution': 0,
    'Intelligence': 0,
    'Wisdom': 0,
    'Charisma': 0
  };

  final Map<String, String> skills = {
    'Acrobatics': 'Dexterity',
    'Animal Handling': 'Wisdom',
    'Arcana': 'Intelligence',
    'Athletics': 'Strength',
    'History': 'Intelligence',
    'Insight': 'Wisdom',
    'Intimidation': 'Charisma',
    'Investigation': 'Intelligence',
    'Medicine': 'Wisdom',
    'Nature': 'Intelligence',
    'Perception': 'Wisdom',
    'Performance': 'Charisma',
    'Persuasion': 'Charisma',
    'Religion': 'Intelligence',
    'Sleight of Hand': 'Dexterity',
    'Stealth': 'Dexterity',
    'Survival': 'Wisdom',
  };

  void setModifiers() {
    setState(() {
      modifiers['Strength'] = (abilityScores['Strength']! - 10) ~/ 2;
      modifiers['Dexterity'] = (abilityScores['Dexterity']! - 10) ~/ 2;
      modifiers['Constitution'] = (abilityScores['Constitution']! - 10) ~/ 2;
      modifiers['Intelligence'] = (abilityScores['Intelligence']! - 10) ~/ 2;
      modifiers['Wisdom'] = (abilityScores['Wisdom']! - 10) ~/ 2;
      modifiers['Charisma'] = (abilityScores['Charisma']! - 10) ~/ 2;
    });
  }

  Widget showStats(int skillValue, String skillName) {
    return Column(
      children: [
        Text(skillName,
            style: const TextStyle(color: Colors.black, fontSize: 20)),
        Container(
          decoration: BoxDecoration(
            color: customColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          height: 100,
          width: 100,
          child: Center(
            child: Column(
              children: [
                Text(
                  "$skillValue",
                  style: const TextStyle(color: Colors.white, fontSize: 40),
                ),
                if (modifiers[skillName]! >= 0)
                  Text(
                    "+${modifiers[skillName]}",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                if (modifiers[skillName]! < 0)
                  Text(
                    "${modifiers[skillName]}",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProficiencies() {
    const TextStyle textStyle = TextStyle(fontWeight: FontWeight.bold);
    return Column(
      children: [
        const Text(
          "Proficiencies",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 5,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: skills.keys.length,
          itemBuilder: (context, index) {
            String proficiency = skills.keys.elementAt(index);
            String ability = skills[proficiency]!;
            int abilityModifier = modifiers[ability]!;
            bool isProficient = chosenProficiencies.contains(proficiency);
            int totalModifier =
                abilityModifier + (isProficient ? proficiencyBonus : 0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    proficiency,
                    style: isProficient ? textStyle : null,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    " ${totalModifier >= 0 ? '+' : ''}$totalModifier",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Abilities",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 25),
            showStats(abilityScores['Strength']!, 'Strength'),
            const Spacer(),
            showStats(abilityScores['Dexterity']!, 'Dexterity'),
            const Spacer(),
            showStats(abilityScores['Constitution']!, 'Constitution'),
            const SizedBox(width: 25),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 25),
            showStats(abilityScores['Intelligence']!, 'Intelligence'),
            const Spacer(),
            showStats(abilityScores['Wisdom']!, 'Wisdom'),
            const Spacer(),
            showStats(abilityScores['Charisma']!, 'Charisma'),
            const SizedBox(width: 25),
          ],
        ),
        const SizedBox(height: 20),
        buildProficiencies(),
        const SizedBox(height: 20),
        Container(
          height: 300,
          width: 300,
          child: RadarChart(
            ticks: const [5, 10, 15, 20], // Set your tick levels
            features: abilityLabels,
            data: [abilityValues], // Single data set for one character
            graphColors: [customColor],
            outlineColor: Colors.black, // Outline for the radar chart
          ),
        ),

      ],
    );
  }
}