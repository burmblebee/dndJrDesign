import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
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

  // State variable to track current dice sides used in the roll.
  late int currentDiceSides;

  @override
  void initState() {
    super.initState();
    currentDiceSides = widget.diceSides; // Initialize with attack dice type.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Initialize dice values and positions for attack roll.
    for (int i = 0; i < widget.numDice; i++) {
      diceValues.add(1); // Placeholder value before rolling.
      dicePositions.add(Offset(50.0 + i * 50, 150.0)); // Starting positions.
      diceRotations.add(0); // Start rotations at 0.
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
      // Save the attack roll result.
      int baseRoll = diceValues.reduce((a, b) => a + b);
      attackTotal = baseRoll + widget.modifier;
      attackBreakdown = diceValues.length > 1
          ? diceValues.join(' + ') + ' = $baseRoll'
          : baseRoll.toString();
    });
  }

  // Rolls damage dice and updates the currentDiceSides accordingly.
  Future<int> rollDamageDice(String damageDice) async {
    final match =
        RegExp(r'(\d+)d(\d+)').firstMatch(damageDice.replaceAll(' ', ''));
    if (match == null) return 0;
    final int numDice = int.parse(match.group(1)!);
    final int damageDiceSides = int.parse(match.group(2)!);

    // Update currentDiceSides for damage roll.
    setState(() {
      currentDiceSides = damageDiceSides;
    });

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
          diceValues[j] = _random.nextInt(damageDiceSides) + 1;
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

  /// Returns a widget representing the shape of the die based on current dice sides.
  Widget _buildDieShape() {
    int diceType = currentDiceSides;
    Color diceColor = Colors.blue;
    Widget shapeWidget;
    switch (diceType) {
      case 4:
        shapeWidget = CustomPaint(
            painter: TrianglePainter(diceColor), size: const Size(50, 50));
        break;
      case 6:
        shapeWidget = Container(color: diceColor, width: 50, height: 50);
        break;
      case 8:
        // Use OctagonPainter for d8.
        shapeWidget = CustomPaint(
            painter: OctagonPainter(diceColor), size: const Size(50, 50));
        break;
      case 10:
      case 100:
        shapeWidget = CustomPaint(
            painter: DecagonPainter(diceColor), size: const Size(55, 55));
        break;
      case 12:
        shapeWidget = CustomPaint(
            painter: PentagonPainter(diceColor), size: const Size(55, 55));
        break;
      case 20:
        shapeWidget = HexagonWidget.pointy(width: 55, color: diceColor);
        break;
      default:
        shapeWidget = Container();
    }
    return shapeWidget;
  }

  @override
  Widget build(BuildContext context) {
    // Use saved attack roll values if available.
    final int displayedAttackTotal =
        attackTotal ?? (diceValues.reduce((a, b) => a + b) + widget.modifier);
    final String displayedAttackBreakdown = attackBreakdown ??
        (diceValues.length > 1
            ? diceValues.join(' + ') +
                ' = ${diceValues.reduce((a, b) => a + b)}'
            : diceValues[0].toString());

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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildDieShape(),
                        Text(
                          '${diceValues[index]}',
                          style: const TextStyle(
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
        ),
      );
    } else if (damageRolled && damageTotal != null) {
      final String damageBreakdown = diceValues.length > 1
          ? diceValues.join(' + ') + ' = ${diceValues.reduce((a, b) => a + b)}'
          : diceValues[0].toString();
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Attack Roll Total: $displayedAttackTotal",
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
          if (!damageRolled)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    final int damageBaseRoll =
                        await rollDamageDice(widget.attackRollDamage);
                    final int rolledDamage = damageBaseRoll + widget.modifier;
                    setState(() {
                      damageTotal = rolledDamage;
                      damageRolled = true;
                    });
                  },
                  child: const Text("Roll for Damage"),
                ),
                TextButton(
                  onPressed: () {
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

/// Custom painter for a triangle (d4).
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

/// Custom painter for an octagon (d8).
class OctagonPainter extends CustomPainter {
  final Color color;
  OctagonPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();
    final int sides = 8;
    final double angleStep = 2 * pi / sides;
    final double radius = size.width / 2;
    for (int i = 0; i < sides; i++) {
      double angle = angleStep * i;
      double x = size.width / 2 + radius * cos(angle);
      double y = size.height / 2 + radius * sin(angle);
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
  bool shouldRepaint(covariant OctagonPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

/// Custom painter for a decagon (d10/d100).
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

/// Custom painter for a pentagon (d12).
class PentagonPainter extends CustomPainter {
  final Color color;
  PentagonPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();
    for (int i = 0; i < 5; i++) {
      double angle = (2 * pi / 5) * i - pi / 2;
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
