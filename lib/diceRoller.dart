import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

import 'die.dart';

class DiceRollScreen extends StatefulWidget {
  @override
  _DiceRollScreenState createState() => _DiceRollScreenState();
}

class _DiceRollScreenState extends State<DiceRollScreen>
    with TickerProviderStateMixin {
  final Random _random = Random();
  List<int> diceValues = [];
  List<Offset> dicePositions = [Offset(50, 300), Offset(200, 300)];
  Timer? _timer;
  List<Die> activeDice = [];
  List<int> diceToRoll = [
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; // d4, d6, d8, d10, d12, d20, d100

  List<int> doubleRoll = [0, 0];

  late AnimationController _animationController;
  List<double> diceRotations = [];

  bool showDice = false;
  bool advantage = false;
  bool disadvantage = false;
  Color advantageButtonColor = Colors.white;
  Color disadvantageButtonColor = Colors.white;
  Color diceColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true); // Keep it animating while rolling
  }

  void rollDice() {
    if (diceToRoll.every((element) => element == 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select at least one die to roll")));
      return;
    }
    _timer?.cancel();

    setState(() {
      showDice = true;
      diceValues.clear();
      activeDice.clear();
      diceRotations.clear();
    });

    int flashCount = 0;
    const int totalFlashes = 10;

    for (int i = 0; i < diceToRoll.length; i++) {
      int sides = [4, 6, 8, 10, 12, 20, 100][i];
      for (int j = 0; j < diceToRoll[i]; j++) {
        activeDice.add(Die(sides));
        diceRotations
            .add(Random().nextDouble() * 2 * pi); // Random rotation angle
      }
    }

    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        diceValues =
            activeDice.map((die) => _random.nextInt(die.sides) + 1).toList();
        diceRotations = List.generate(
            diceValues.length, (_) => Random().nextDouble() * 2 * pi);
        dicePositions = List.generate(
            diceValues.length,
            (_) =>
                Offset(_random.nextDouble() * 300, _random.nextDouble() * 500));
      });

      flashCount++;
      if (flashCount >= totalFlashes) {
        _timer?.cancel();
        _animationController.stop();
        setState(() {
          diceValues =
              activeDice.map((die) => _random.nextInt(die.sides) + 1).toList();
        });

        showRollResultDialog(diceValues.reduce((a, b) => a + b));
      }
    });
  }

  void showRollResultDialog(int total) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Dice Roll Result"),
          content: Text("Total: $total", style: const TextStyle(fontSize: 24)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => showDice = false);
                diceValues.clear();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget buildDice(String label, Widget shape, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 150,
          width: 150,
          child: Column(
            children: [
              Spacer(),
              Stack(
                alignment: Alignment.center, // Centers the text
                children: [
                  shape, // Draws the dice shape
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Ensure contrast
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      if (diceToRoll[index] > 0) {
                        setState(() {
                          diceToRoll[index]--;
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_downward),
                  ),
                  Text(
                    diceToRoll[index].toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        diceToRoll[index]++;
                      });
                    },
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  Spacer()
                ],
              ),
              Spacer()
            ],
          ),
        ),
      ],
    );
  }

  void advantageToggle() {
    setState(() {
      advantage = !advantage;
      disadvantage = false;
      advantageButtonColor = advantage ? Colors.green : Colors.white;
      disadvantageButtonColor = Colors.white;
    });
  }

  void disadvantageToggle() {
    setState(() {
      disadvantage = !disadvantage;
      advantage = false;
      disadvantageButtonColor = disadvantage ? Colors.red : Colors.white;
      advantageButtonColor = Colors.white;
    });
  }



  Widget rollDiceWidget() {
    return Stack(
      children: List.generate(diceValues.length, (index) {
        int value = diceValues[index];
        int diceType = activeDice.isNotEmpty ? activeDice[index].sides : 6;

        Widget shapeWidget;
        switch (diceType) {
          case 4:
            shapeWidget = CustomPaint(
                painter: TrianglePainter(diceColor), size: Size(50, 50));
            break;
          case 6:
            shapeWidget = Container(color: diceColor, width: 50, height: 50);
            break;
          case 8:
            shapeWidget = Transform.rotate(
                angle: pi / 4,
                child: Container(color: diceColor, width: 50, height: 50));
            break;
          case 10:
          case 100:
            shapeWidget = CustomPaint(
                painter: DecagonPainter(diceColor), size: Size(55, 55));
            break;
          case 12:
            shapeWidget = CustomPaint(
                painter: PentagonPainter(diceColor), size: Size(55, 55));
            break;
          case 20:
            shapeWidget = HexagonWidget.pointy(width: 55, color: diceColor);
            break;
          default:
            shapeWidget = Container();
        }

        return AnimatedPositioned(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeOut,
          left: dicePositions[index].dx,
          top: dicePositions[index].dy,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle:
                    diceRotations[index] + _animationController.value * 2 * pi,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    shapeWidget,
                    Text(
                      '$value',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dice Roller")),
      body: Stack(
        children: [
          if (showDice) rollDiceWidget(),
          if (!showDice)
            Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Prevents unnecessary expansion
                children: [
                  SizedBox(height: 15), // Added spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildDice(
                          "d4",
                          CustomPaint(
                              painter: TrianglePainter(diceColor),
                              size: Size(75, 75)),
                          0),
                      buildDice(
                          "d6",
                          Container(color: diceColor, width: 75, height: 75),
                          1),
                    ],
                  ),
                  SizedBox(height: 15), // Added spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildDice(
                          "d8",
                          Transform.rotate(
                              angle: pi / 4,
                              child: Container(
                                  color: diceColor, width: 65, height: 65)),
                          2),
                      buildDice(
                          "d10",
                          CustomPaint(
                              painter: DecagonPainter(diceColor),
                              size: Size(80, 80)),
                          3),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildDice(
                          "d12",
                          CustomPaint(
                              painter: PentagonPainter(diceColor),
                              size: Size(75, 75)),
                          4),
                      buildDice(
                          "d20",
                          HexagonWidget.pointy(
                            width: 60,
                            color: diceColor,
                          ),
                          5),
                    ],
                  ),
                  SizedBox(height: 15),
                  buildDice(
                      "d100",
                      CustomPaint(
                          painter: DecagonPainter(diceColor),
                          size: Size(80, 80)),
                      6),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: advantageToggle,
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(advantageButtonColor)),
                        child: Text("Advantage"),
                      ),
                      ElevatedButton(
                          onPressed: () {
                              rollDice();
                          },
                          child: const Text("Roll Dice")),
                      ElevatedButton(
                        onPressed: disadvantageToggle,
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                disadvantageButtonColor)),
                        child: Text("Disadvantage"),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class DecagonPainter extends CustomPainter {
  final Color color;
  DecagonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();
    for (int i = 0; i < 10; i++) {
      double angle = (pi / 5) * i;
      double x = size.width / 2 + cos(angle) * size.width / 2;
      double y = size.height / 2 + sin(angle) * size.height / 2;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DecagonPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class PentagonPainter extends CustomPainter {
  final Color color;
  PentagonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();
    for (int i = 0; i < 5; i++) {
      double angle = (pi * 2 / 5) * i - pi / 2;
      double x = size.width / 2 + cos(angle) * size.width / 2;
      double y = size.height / 2 + sin(angle) * size.height / 2;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant PentagonPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
