import 'dart:math';
import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/screens/character_sheet/character_sheet.dart';

Future<Map<String, int>?> showDiceRollPopup(
  BuildContext context,
  String attackRollDice, {
  required int modifier,
  required String attackRollDamage,
}) async {
  final match =
      RegExp(r'(\d+)d(\d+)').firstMatch(attackRollDice.replaceAll(' ', ''));
  if (match == null) {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invalid Input"),
        content: const Text('Please use the format "XdY" (e.g., "1d20").'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
    return null;
  }

  final int numDice = int.parse(match.group(1)!);
  final int diceSides = int.parse(match.group(2)!);

  return showDialog<Map<String, int>>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return DiceRollPopup(
        numDice: numDice,
        diceSides: diceSides,
        modifier: modifier,
        attackRollDamage: attackRollDamage,
      );
    },
  );
}

class DiceRollPopup extends StatefulWidget {
  final int numDice;
  final int diceSides;
  final int modifier;
  final String attackRollDamage;

  const DiceRollPopup({
    Key? key,
    required this.numDice,
    required this.diceSides,
    required this.modifier,
    required this.attackRollDamage,
  }) : super(key: key);

  @override
  _DiceRollPopupState createState() => _DiceRollPopupState();
}

class _DiceRollPopupState extends State<DiceRollPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Random _random = Random();
  List<int> diceValues = [];
  List<Offset> dicePositions = [];
  List<double> diceRotations = [];
  bool isRolling = true;

  // State variables for preserving the attack roll result.
  int? attackTotal;
  String? attackBreakdown;

  // State variables to handle damage roll results.
  bool damageRolled = false;
  int? damageTotal;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Initialize dice values and positions for attack roll.
    for (int i = 0; i < widget.numDice; i++) {
      diceValues.add(1); // Placeholder value before rolling
      dicePositions.add(Offset(50.0 + i * 50, 150.0)); // Starting positions
      diceRotations.add(0); // Start rotations at 0
    }

    // Start rolling the attack dice.
    rollDice();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Rolls the attack dice and then saves the result.
  void rollDice() async {
    int rollCount = 10;
    for (int i = 0; i < rollCount; i++) {
      if (!mounted) return;
      setState(() {
        for (int j = 0; j < widget.numDice; j++) {
          diceValues[j] = _random.nextInt(widget.diceSides) + 1;
          dicePositions[j] = Offset(
            _random.nextInt(200).toDouble(),
            _random.nextInt(200).toDouble(),
          );
          diceRotations[j] = _random.nextDouble() * 2 * pi;
        }
      });
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (!mounted) return;
    _animationController.stop();
    setState(() {
      isRolling = false;
      // Save the attack roll result before any damage roll.
      int baseRoll = diceValues.reduce((a, b) => a + b);
      attackTotal = baseRoll + widget.modifier;
      attackBreakdown = diceValues.length > 1
          ? diceValues.join(' + ') + ' = $baseRoll'
          : baseRoll.toString();
    });
  }

  // Rolls damage dice. Notice that we do not update the saved attack result.
  Future<int> rollDamageDice(String damageDice) async {
    final match =
        RegExp(r'(\d+)d(\d+)').firstMatch(damageDice.replaceAll(' ', ''));
    if (match == null) return 0;
    final int numDice = int.parse(match.group(1)!);
    final int diceSides = int.parse(match.group(2)!);

    // Set up new dice values for damage roll.
    diceValues = List.generate(numDice, (_) => 1);
    dicePositions = List.generate(numDice, (_) => const Offset(50.0, 150.0));
    diceRotations = List.generate(numDice, (_) => 0.0);

    setState(() {
      isRolling = true;
    });

    for (int i = 0; i < 10; i++) {
      if (!mounted) return 0;
      setState(() {
        for (int j = 0; j < numDice; j++) {
          diceValues[j] = _random.nextInt(diceSides) + 1;
          dicePositions[j] = Offset(
            _random.nextInt(200).toDouble(),
            _random.nextInt(200).toDouble(),
          );
          diceRotations[j] = _random.nextDouble() * 2 * pi;
        }
      });
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (!mounted) return 0;
    _animationController.stop();
    setState(() {
      isRolling = false;
    });
    return diceValues.reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    // If attackTotal is already saved, use it; otherwise compute from current dice values.
    final int displayedAttackTotal = attackTotal ??
        (diceValues.reduce((a, b) => a + b) + widget.modifier);
    final String displayedAttackBreakdown = attackBreakdown ??
        (diceValues.length > 1
            ? diceValues.join(' + ') + ' = ${diceValues.reduce((a, b) => a + b)}'
            : diceValues[0].toString());

    // Build content based on whether damage has been rolled.
    Widget content;
    if (isRolling) {
      content = SizedBox(
        height: 300,
        width: 300,
        child: Stack(
          children: List.generate(diceValues.length, (index) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              left: dicePositions[index].dx,
              top: dicePositions[index].dy,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: diceRotations[index] +
                        _animationController.value * 2 * pi,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${diceValues[index]}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      );
    } else if (damageRolled && damageTotal != null) {
      // Show combined attack and damage roll results.
      // Use the saved attack roll result.
      final String damageBreakdown = diceValues.length > 1
          ? diceValues.join(' + ') +
              ' = ${diceValues.reduce((a, b) => a + b)}'
          : diceValues[0].toString();
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Attack Roll:\nDice: $displayedAttackBreakdown\nModifier: ${widget.modifier}\nTotal: $displayedAttackTotal",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            "Damage Roll:\nDice: $damageBreakdown\nModifier: ${widget.modifier}\nTotal: $damageTotal",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      );
    } else {
      // Show only the attack roll result.
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Attack Roll:\nDice: $displayedAttackBreakdown\nModifier: ${widget.modifier}\nTotal: $displayedAttackTotal",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      );
    }

    return AlertDialog(
      title: isRolling
          ? const Text("Rolling...")
          : Text(damageRolled ? "Roll Results" : "Attack Roll"),
      content: content,
      actions: [
        if (!isRolling)
          // If damage hasn't been rolled yet, offer two options.
          if (!damageRolled)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    // User chooses to roll for damage.
                    final int damageBaseRoll =
                        await rollDamageDice(widget.attackRollDamage);
                    final int rolledDamage = damageBaseRoll + widget.modifier;
                    setState(() {
                      damageTotal = rolledDamage;
                      damageRolled = true;
                      // No need to restart the animation controller here.
                    });
                  },
                  child: const Text("Roll for Damage"),
                ),
                TextButton(
                  onPressed: () {
                    // User chooses not to roll for damage.
                    Navigator.of(context).pop({
                      "attackRoll": displayedAttackTotal,
                      "damageRoll": 0,
                    });
                  },
                  child: const Text("OK"),
                ),
              ],
            )
          else
            // Once damage is rolled, one OK button dismisses the dialog.
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  "attackRoll": displayedAttackTotal,
                  "damageRoll": damageTotal!,
                });
              },
              child: const Text("OK"),
            ),
      ],
    );
  }
}
