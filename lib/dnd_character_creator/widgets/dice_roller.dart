import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/buttons/button_with_padding.dart';

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key, required this.customColor});
  final Color customColor;

  @override
  _DiceRollerState createState() => _DiceRollerState();
}

class _DiceRollerState extends State<DiceRoller> {

  @override
  void initState() {
    super.initState();
    update();
  }

  int dice_no1 = 1;
  int dice_no2 = 1;
  int dice_no3 = 1;
  int dice_no4 = 1;
  int dice_no5 = 1;
  int dice_no6 = 1;

  List<String> _pickedAbilities = [];

  final Map<String, int> abilityScores = {
    'Strength': 0,
    'Dexterity': 0,
    'Constitution': 0,
    'Wisdom': 0,
    'Intelligence': 0,
    'Charisma': 0,
  };

  String _chosenAbility = 'Strength';
  int currentRoll = 0;

  void update() {
    setState(() {
      dice_no1 = Random().nextInt(6) + 1;
      dice_no2 = Random().nextInt(6) + 1;
      dice_no4 = Random().nextInt(6) + 1;
      dice_no5 = Random().nextInt(6) + 1;
      currentRoll = scoreForRoll();
    });
  }

  int scoreForRoll() {
    int least = min(dice_no1, min(dice_no2, min(dice_no4, dice_no5)));
    return dice_no1 + dice_no2 + dice_no4 + dice_no5 - least;
  }

  void saveSelection() {
    setState(() {
      abilityScores[_chosenAbility] = currentRoll;
      _pickedAbilities.add(_chosenAbility);
    });
  }

  Widget loadRow(String ability, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8.0),
          Icon(icon, size: 24.0),
          const SizedBox(width: 8.0),
          Text(
            ability,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              "." * 50, // Adjust the number of dots
              style: const TextStyle(fontSize: 16),
              maxLines: 1, // Ensure it stays on a single line
              overflow: TextOverflow.ellipsis, // Optional: This ensures dots don't overflow the container
            ),
          ),
          Text(
            abilityScores[ability].toString(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getDropdownItems() {
    return abilityScores.keys.map((ability) =>
        DropdownMenuItem<String>(value: ability, child: Text(ability)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Column(
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
                      color: widget.customColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'assets/dice$dice_no2.png',
                      width: 100,
                      height: 100,
                      color: widget.customColor,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/dice$dice_no4.png',
                      width: 100,
                      height: 100,
                      color: widget.customColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Image.asset(
                      'assets/dice$dice_no5.png',
                      width: 100,
                      height: 100,
                      color: widget.customColor,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ButtonWithPadding(onPressed: update, textContent: 'Roll'),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: _chosenAbility,
                  items: getDropdownItems(),
                  onChanged: (value) {
                    setState(() {
                      _chosenAbility = value!;
                    });
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  width: 50,
                  child: Text(
                    currentRoll.toString(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                ButtonWithPadding(
                    onPressed: saveSelection, textContent: 'Save Selection'),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: 200,
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      loadRow('Strength', Icons.add),
                      loadRow('Dexterity', Icons.import_contacts),
                      loadRow('Constitution', Icons.image_aspect_ratio_rounded),
                      loadRow('Wisdom', Icons.add_ic_call),
                      loadRow('Intelligence', Icons.ice_skating),
                      loadRow('Charisma', Icons.accessibility_new),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
