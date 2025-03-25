import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:warlocks_of_the_beach/die.dart';
import '../npc/npc.dart';

class PremadeAttack extends StatefulWidget {
  PremadeAttack({required this.campaignId, required this.attackOptions, required this.onRollComplete, super.key});

  final String campaignId;
  final List<AttackOption> attackOptions;
  final void Function(int total) onRollComplete;

  @override
  _PremadeAttackState createState() => _PremadeAttackState();
}

class _PremadeAttackState extends State<PremadeAttack>
    with TickerProviderStateMixin {
  final Random _random = Random();
  List<int> diceValues = [];
  List<Offset> dicePositions = [const Offset(50, 300), const Offset(200, 300)];
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
  late int width;
  late int height;
  late AttackOption attackOption;

  List<int> doubleRoll = [0, 0];

  late AnimationController _animationController;
  List<double> diceRotations = [];

  bool showDice = false;
  bool advantage = false;
  bool disadvantage = false;
  Color advantageButtonColor = const Color(0xFF25291C);
  Color disadvantageButtonColor = const Color(0xFF25291C);
  Color diceColor = const Color.fromARGB(255, 243, 241, 230);
  Color onDiceColor = const Color(0xFF464538);

  String? get campaignId => widget.campaignId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Keep it animating while rolling
    (widget.attackOptions.isNotEmpty) ? attackOption = widget.attackOptions[0] : attackOption = AttackOption(name: 'Default', diceConfig: [0, 0, 0, 0, 0, 0, 0]);
    diceToRoll = attackOption.diceConfig;
  }

  void rollDice() {
    setState(() {
      activeDice.clear();
      diceValues.clear();
      dicePositions.clear();
      diceRotations.clear();
      doubleRoll = [0, 0];

      for (int i = 0; i < diceToRoll.length; i++) {
        if (diceToRoll[i] > 0) {
          for (int j = 0; j < diceToRoll[i]; j++) {
            int sides = [4, 6, 8, 10, 12, 20, 100][i];
            activeDice.add(Die(sides));
            diceValues.add(1); // Placeholder before rolling
            dicePositions
                .add(Offset(100 + j * 50, 300)); // Random start positions
            diceRotations.add(0); // Start rotations at 0
          }
        }
      }

      if (activeDice.isNotEmpty) {
        showDice = true;
        roll();
      }
    });
  }

  void roll() async {
    Random random = Random();
    int rollCount = 10;

    for (int i = 0; i < rollCount; i++) {
      setState(() {
        for (int j = 0; j < activeDice.length; j++) {
          diceValues[j] = random.nextInt(activeDice[j].sides) + 1;
          dicePositions[j] = Offset(
            random.nextInt(width - 50).toDouble(),
            random.nextInt(height - 150).toDouble() + 20,
          );
          diceRotations[j] = random.nextDouble() * 2 * pi;
        }
      });

      await Future.delayed(const Duration(milliseconds: 100));
    }

    _animationController.stop(); // Stop animation
    int total = diceValues.fold(0, (sum, value) => sum + value);

    if (advantage || disadvantage) {
      if (doubleRoll[0] == 0) {
        doubleRoll[0] = total; // Store first roll
        await Future.delayed(const Duration(milliseconds: 500));
        _animationController.repeat(); // Start animation again
        roll(); // Trigger second roll
        return; // Prevent the dialog from showing yet
      } else {
        doubleRoll[1] = total; // Store second roll
        sendToCampaign();
        showAdvantageDialog();
      }
    } else {
      sendToCampaign();
      showRollResultDialog(total);
    }
  }

  void sendToCampaign() async {
    if (widget.campaignId != '') {
      //  final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
      //    if (currentUserUid != null) {
      final docRef = FirebaseFirestore.instance
          .collection('campaigns')
          .doc(campaignId)
          .collection('rolls');

      try {
        await docRef.add(
          {
            'Rolls': diceValues,
            'Total': diceValues.reduce((value, element) => value + element),
            'timestamp': FieldValue.serverTimestamp(), // Add timestamp
            //      'userId': currentUserUid,
          },
        );

        print('Rolls successfully sent to campaign: $campaignId');
      } catch (e) {
        print('Error saving dice rolls: $e');
      }
      // }
    }
  }

  void showAdvantageDialog() {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: (advantage)
              ? const Text("Roll with Advantage")
              : const Text("Roll with Disadvantage"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Rolls: ${doubleRoll.join(', ')}"),
              (advantage)
                  ? Text("Total: ${doubleRoll.reduce(max)}")
                  : Text("Total: ${doubleRoll.reduce(min)}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                sendToCampaign();
                setState(() {
                  showDice = false;
                });
                widget.onRollComplete(
                    advantage ? doubleRoll.reduce(max) : doubleRoll.reduce(min));

              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showRollResultDialog(int total) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Dice Roll Result"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Rolls: ${diceValues.join(', ')}"),
              Text("Total: $total"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  showDice = false;
                });
                widget.onRollComplete(total);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void advantageToggle() {
    setState(() {
      advantage = !advantage;
      disadvantage = false;
      advantageButtonColor = advantage ? Colors.green : const Color(0xFF25291C);
      disadvantageButtonColor = const Color(0xFF25291C);
    });
  }

  void disadvantageToggle() {
    setState(() {
      disadvantage = !disadvantage;
      advantage = false;
      disadvantageButtonColor =
          disadvantage ? Colors.red : const Color(0xFF25291C);
      advantageButtonColor = const Color(0xFF25291C);
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
                painter: TrianglePainter(diceColor), size: const Size(50, 50));
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

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
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
                        color: onDiceColor,
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
    width = MediaQuery.of(context).size.width.toInt();
    height = MediaQuery.of(context).size.height.toInt();
    if (widget.attackOptions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('No Attack Options')),
        body: const Center(child: Text('No attack options available.')),
      );
    }
    if (!showDice) {
      return Scaffold(
        appBar: AppBar(title: const Text('Premade Attack')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              DropdownButton(
                  items: widget.attackOptions.map((AttackOption option) {
                    return DropdownMenuItem<AttackOption>(
                      value: option,
                      child: Text(option.name),
                    );
                  }).toList(),
                  onChanged: (AttackOption? selectedOption) {
                    if (selectedOption != null) {
                      setState(() {
                        attackOption = selectedOption;
                        diceToRoll = attackOption.diceConfig;
                      });
                    }
                  },
                  value: attackOption,
                  hint: const Text("Select Attack Option")),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: advantageToggle,
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(advantageButtonColor)),
                    child: Text("Advantage",
                        style: TextStyle(
                            color: ((advantage)
                                ? const Color(0xFF25291C)
                                : Colors.white))),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        debugPrint("Dice to roll: $diceToRoll");
                        rollDice();
                      },
                      child: const Text("Roll Dice",
                          style: TextStyle(color: Colors.white))),
                  ElevatedButton(
                    onPressed: disadvantageToggle,
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(disadvantageButtonColor)),
                    child: Text("Advantage",
                        style: TextStyle(
                            color: ((disadvantage)
                                ? const Color(0xFF25291C)
                                : Colors.white))),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text("Premade Attack")),
        body: Center(
          child: rollDiceWidget(),
        ),
      );
    }
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
