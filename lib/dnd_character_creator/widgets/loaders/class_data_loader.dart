import 'package:flutter/material.dart';
import '../../Data/class_data.dart';

class ClassDataWidget extends StatefulWidget {
  final String className;

  ClassDataWidget({Key? key, required this.className}) : super(key: key);

  @override
  State<ClassDataWidget> createState() => _ClassDataWidgetState();
}

class _ClassDataWidgetState extends State<ClassDataWidget> {
  @override
  Widget build(BuildContext context) {
    final classInfo = ClassData[widget.className] ?? {};

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.className,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            classInfo['description'] ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 30, color: Colors.grey),

          Text(
            'Hit Die: ${classInfo['hitDie'] ?? ''}, plus ${classInfo['hitDie'] ?? ''} per ${widget.className.toLowerCase()} level after 1st',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const Divider(height: 30, color: Colors.grey),

          _buildAttributeRow(
            label: 'Armor Proficiencies',
            value: (classInfo['armors'] as List<dynamic>?)?.join(', ') ?? '',
            icon: Icons.shield,
          ),
          _buildAttributeRow(
            label: 'Weapons',
            value: (classInfo['weapons'] as List<dynamic>?)?.join(', ') ?? '',
            icon: Icons.flashlight_on_sharp,
          ),
          _buildAttributeRow(
            label: 'Tool Proficiencies',
            value: (classInfo['tools'] as List<dynamic>?)?.join(', ') ?? '',
            icon: Icons.pan_tool_sharp,
          ),
          _buildAttributeRow(
            label: 'Saving Throws',
            value: (classInfo['savingThrows'] as List<dynamic>?)?.join(', ') ?? '',
            icon: Icons.security,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Skills:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            "${ClassData[widget.className]?['skills'].join(', ') ?? ''}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 30, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildAttributeRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24.0),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
