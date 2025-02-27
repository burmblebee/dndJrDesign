import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/data/character%20creator%20data/class_data.dart';

class ClassDataWidget extends StatefulWidget {
  final String className;

  const ClassDataWidget({Key? key, required this.className}) : super(key: key);

  @override
  State<ClassDataWidget> createState() => _ClassDataWidgetState();
}

class _ClassDataWidgetState extends State<ClassDataWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme; // Fetch theme styles
    final classInfo = ClassData[widget.className] ?? {};

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.className,
            style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Text(
            classInfo['description'] ?? '',
            style: theme.bodyMedium, // Use body text style
          ),
          const Divider(height: 30, color: Colors.grey),

          Text(
            'Hit Die: ${classInfo['hitDie'] ?? ''}, plus ${classInfo['hitDie'] ?? ''} per ${widget.className.toLowerCase()} level after 1st',
            style: theme.bodyMedium,
          ),
          const Divider(height: 30, color: Colors.grey),

          _buildAttributeRow(
            label: 'Armor Proficiencies',
            value: (classInfo['armors'] as List<dynamic>?)?.join(', ') ?? '',
            icon: Icons.shield,
            textStyle: theme.bodyMedium,
          ),
          _buildAttributeRow(
            label: 'Weapons',
            value: (classInfo['weapons'] as List<dynamic>?)?.join(', ') ?? '',
            icon: Icons.flashlight_on_sharp,
            textStyle: theme.bodyMedium,
          ),
          _buildAttributeRow(
            label: 'Tool Proficiencies',
            value: (classInfo['tools'] as List<dynamic>?)?.join(', ') ?? '',
            icon: Icons.pan_tool_sharp,
            textStyle: theme.bodyMedium,
          ),
          _buildAttributeRow(
            label: 'Saving Throws',
            value: (classInfo['savingThrows'] as List<dynamic>?)?.join(', ') ?? '',
            icon: Icons.security,
            textStyle: theme.bodyMedium,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Skills:',
              style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            (classInfo['skills'] as List<dynamic>?)?.join(', ') ?? '',
            style: theme.bodyMedium,
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
    required TextStyle? textStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24.0, color: Theme.of(context).iconTheme.color), // Use theme color for icons
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textStyle?.copyWith(fontWeight: FontWeight.bold)),
                Text(value, style: textStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
