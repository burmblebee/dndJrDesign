import 'package:flutter/material.dart';

class EditableTextField extends StatefulWidget {
  final String initialText;
  final TextStyle style;
  final void Function(String)? onChanged;

  const EditableTextField({
    super.key,
    required this.initialText,
    required this.style,
    this.onChanged,
  });

  @override
  State<EditableTextField> createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  late TextEditingController _controller;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _enableEditing() {
    setState(() {
      _editing = true;
    });
  }

  void _disableEditing() {
    setState(() {
      _editing = false;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _editing
        ? Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) _disableEditing();
            },
            child: TextField(
              controller: _controller,
              style: widget.style,
              autofocus: true,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _disableEditing(),
            ),
          )
        : GestureDetector(
            onTap: _enableEditing,
            child: Text(
              _controller.text,
              style: widget.style,
            ),
          );
  }
}
