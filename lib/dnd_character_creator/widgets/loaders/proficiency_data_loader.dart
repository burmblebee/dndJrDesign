import 'package:flutter/material.dart';
import '../../Data/background_data.dart';
import '../../Data/class_data.dart';

class ProficiencyDataWidget extends StatefulWidget {
  const ProficiencyDataWidget(
      {super.key,
        required this.className,
        required this.backgroundName});
  final String className;
  final String backgroundName;

  @override
  State<ProficiencyDataWidget> createState() => _ProficiencyDataWidgetState();
}

class _ProficiencyDataWidgetState extends State<ProficiencyDataWidget> {
  @override
  Widget build(BuildContext context) {
    final classInfo = ClassData[widget.className] ?? {};
    final backgroundInfo = BackgroundData[widget.backgroundName] ?? {};

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildAttributeRow(
            label: 'Skills from Class',
            value: (classInfo['skills'] as List<dynamic>?)?.join(', ') ?? '',
            icon: Icons.security,
          ),
          _buildAttributeRow(
            label: 'Skills from Background',
            value: (backgroundInfo['skills'] as List<dynamic>?)?.join(', ') ?? '',
            icon: Icons.security,
          ),
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
