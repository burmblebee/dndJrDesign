import 'package:flutter/material.dart';

class ButtonWithPadding extends StatefulWidget {

  const ButtonWithPadding({
    super.key,
    required this.onPressed,
    required this.textContent,
    
  });

  final Function onPressed;
  final String textContent;

  @override
  _ButtonWithPaddingState createState() => _ButtonWithPaddingState();
}

class _ButtonWithPaddingState extends State<ButtonWithPadding> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilledButton(
        onPressed: () {
          widget.onPressed();
        },
        child: Text(widget.textContent),
        style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.all(10)),
          minimumSize: WidgetStateProperty.all(Size(120, 50)),
          backgroundColor:
              WidgetStateProperty.all(const Color(0xFF25291C)), //the new gray color
        ),
      ),
    );
  }
}
