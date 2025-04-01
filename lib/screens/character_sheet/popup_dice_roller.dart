import 'dart:math';
import 'package:flutter/material.dart';

Future<int?> showDiceRollPopup(BuildContext context, String diceInput) async {
  // this parses the funny input ("2d6" -> 2 dice with 6 sides)
  final match = RegExp(r'(\d+)d(\d+)').firstMatch(diceInput);
  if (match == null) {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invalid Input"),
        content: const Text('Please use the format "XdY" (e.g., "2d6").'),
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

  return showDialog<int>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return DiceRollPopup(numDice: numDice, diceSides: diceSides);
    },
  );
}

class DiceRollPopup extends StatefulWidget {
  final int numDice;
  final int diceSides;

  const DiceRollPopup({Key? key, required this.numDice, required this.diceSides})
      : super(key: key);

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

    _animationController.stop(); // Stop animation
    setState(() {
      isRolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rolling Dice..."),
      content: SizedBox(
        height: 300,
        width: 300,
        child: Stack(
          children: List.generate(widget.numDice, (index) {
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
      ),
      actions: [
        if (!isRolling)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(diceValues.reduce((a, b) => a + b));
            },
            child: const Text("OK"),
          ),
      ],
    );
  }
}