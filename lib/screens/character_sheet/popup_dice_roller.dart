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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Initialize dice values and positions
    for (int i = 0; i < widget.numDice; i++) {
      diceValues.add(1); // Placeholder value before rolling
      dicePositions.add(Offset(50.0 + i * 50, 150.0)); // Random start positions
      diceRotations.add(0); // Start rotations at 0
    }

    // Start rolling the dice
    rollDice();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void rollDice() async {
    int rollCount = 10;

    for (int i = 0; i < rollCount; i++) {
      if (!mounted) return; // Exit if widget is no longer in the tree

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
    });
  }

  Future<int> rollDamageDice(String damageDice) async {
    final match =
        RegExp(r'(\d+)d(\d+)').firstMatch(damageDice.replaceAll(' ', ''));
    if (match == null) return 0;

    final int numDice = int.parse(match.group(1)!);
    final int diceSides = int.parse(match.group(2)!);

    diceValues = List.generate(numDice, (_) => 1);
    dicePositions = List.generate(numDice, (_) => Offset(50.0, 150.0));
    diceRotations = List.generate(numDice, (_) => 0.0);

    setState(() {
      isRolling = true;
    });

    for (int i = 0; i < 10; i++) {
      if (!mounted) return 0; // Exit if widget is disposed

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
    final int baseRoll = diceValues.reduce((a, b) => a + b);
    final int totalRoll = baseRoll + widget.modifier;
    final String diceBreakdown = diceValues.length > 1
        ? diceValues.join(' + ') + ' = $baseRoll'
        : baseRoll.toString(); // Show breakdown only if more than one die

    return AlertDialog(
      title: isRolling ? const Text("Rolling...") : const Text("Attack Roll"),
      content: isRolling
          ? SizedBox(
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
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Attack Roll:\nDice: $diceBreakdown\nModifier: ${widget.modifier}\nTotal: $totalRoll",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
      actions: [
        if (!isRolling)
          TextButton(
            onPressed: () async {
              // Ask if the user wants to roll for damage
              final bool rollDamage = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Roll for Damage?"),
                      content: const Text("Do you want to roll for damage?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("No"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  ) ??
                  false;

              if (rollDamage) {
                // Reroll for damage with animation
                final int damageBaseRoll =
                    await rollDamageDice(widget.attackRollDamage);
                final int damageTotal = damageBaseRoll + widget.modifier;
                final String damageBreakdown = diceValues.length > 1
                    ? diceValues.join(' + ') + ' = $damageBaseRoll'
                    : damageBaseRoll
                        .toString(); // Show breakdown only if more than one die

                // Show the results screen with both attack and damage rolls
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Roll Results"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Attack Roll: $totalRoll",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Damage Roll:\nDice: $damageBreakdown\nModifier: ${widget.modifier}\nTotal: $damageTotal",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Dismiss the damage roll popup
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              } else {
                // Show only the attack roll results
                if (mounted) {
                  Navigator.of(context).pop({
                    "attackRoll": totalRoll,
                    "damageRoll": 0,
                  });
                }
              }
            },
            child: const Text("OK"),
          ),
      ],
    );
  }
}
