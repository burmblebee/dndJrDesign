import 'package:flutter/material.dart';

class ButtonWithPadding extends StatefulWidget {
  const ButtonWithPadding({
    super.key,
    required this.onPressed,
    required this.textContent,
    this.color,
  });

  final Function onPressed;
  final String textContent;
  final Color? color;

  @override
  _ButtonWithPaddingState createState() => _ButtonWithPaddingState();
}

class _ButtonWithPaddingState extends State<ButtonWithPadding> {
  @override
  Widget build(BuildContext context) {
    Color customColor = const Color.fromARGB(255, 138, 28, 20);
    Color textColor = Colors.white;
    if (widget.color != null) {
      customColor = widget.color!;
    }
    if (widget.color == Colors.blueGrey[800]) {
      textColor = Colors.blueGrey;
    }
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: FilledButton(
        onPressed: () {
          widget.onPressed();
        },
        style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
          shadowColor: WidgetStateProperty.all(Colors.black),
          minimumSize: WidgetStateProperty.all(const Size(110, 50)),
          backgroundColor: WidgetStateProperty.all(customColor),
          elevation: WidgetStateProperty.all(5), // Add shadow with elevation
        ),
        child: Text(
          widget.textContent,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}