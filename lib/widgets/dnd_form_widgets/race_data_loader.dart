import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/data/race_data.dart';



class RaceDataLoader extends StatelessWidget {
  RaceDataLoader({super.key, required this.raceName});

  final String raceName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            raceName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          // Description
          Text(
            RaceData[raceName]?['description'] ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Attributes with labels and icons
          _buildAttributeRow(
            label: 'Speed',
            value: RaceData[raceName]?['speed'] ?? '',
            icon: Icons.directions_run,
          ),
          _buildAttributeRow(
            label: 'Size',
            value: RaceData[raceName]?['size'] ?? '',
            icon: Icons.straighten,
          ),
          _buildAttributeRow(
            label: 'Vision',
            value: RaceData[raceName]?['vision'] ?? '',
            icon: Icons.visibility,
          ),
          _buildAttributeRow(
            label: 'Languages',
            value: (RaceData[raceName]?['languages'] as List<dynamic>?)
                    ?.join(', ') ??
                '',
            icon: Icons.language,
          ),
          _buildAttributeRow(
            label: 'Traits',
            value: (RaceData[raceName]?['traits'] as List<dynamic>?)
                    ?.join(', ') ??
                '',
            icon: Icons.star,
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
