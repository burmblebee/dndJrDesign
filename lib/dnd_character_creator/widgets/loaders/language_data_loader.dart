import 'package:flutter/material.dart';
import '../../Data/background_data.dart';
import '../../Data/race_data.dart';

class LanguageDataWidget extends StatefulWidget {
  const LanguageDataWidget(
      {super.key,
        required this.raceName,
        required this.backgroundName});
  final String raceName;
  final String backgroundName;

  @override
  State<LanguageDataWidget> createState() => _ProficiencyDataWidgetState();
}

class _ProficiencyDataWidgetState extends State<LanguageDataWidget> {
  @override
  Widget build(BuildContext context) {
    final raceInfo = RaceData[widget.raceName] ?? {};
    final backgroundInfo = BackgroundData[widget.backgroundName] ?? {};

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildAttributeRow(
            label: 'Languages from Race',
            value: (raceInfo['languages'] as List<dynamic>?)?.join(', ') ?? '',
            icon: Icons.language,
          ),
          _buildAttributeRow(
            label: 'Languages from Background',
            value: (backgroundInfo['languages'] as List<dynamic>?)?.join(', ') ?? '',
            icon: Icons.language,
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
