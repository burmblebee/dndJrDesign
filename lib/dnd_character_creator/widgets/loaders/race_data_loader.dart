import 'package:flutter/material.dart';
import '../../Data/race_data.dart';

class RaceDataLoader extends StatelessWidget {
  const RaceDataLoader({super.key, required this.raceName});

  final String raceName;

  @override
  Widget build(BuildContext context) {
    final raceDetails = RaceData[raceName] ?? {};

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
            raceDetails['description'] ?? 'No description available for this race.',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Attributes with labels and icons
          _buildAttributeRow(
            label: 'Speed',
            value: raceDetails['speed'] ?? 'Unknown',
            icon: Icons.directions_run,
          ),
          _buildAttributeRow(
            label: 'Size',
            value: raceDetails['size'] ?? 'Unknown',
            icon: Icons.straighten,
          ),
          _buildAttributeRow(
            label: 'Vision',
            value: raceDetails['vision'] ?? 'Unknown',
            icon: Icons.visibility,
          ),
          _buildAttributeRow(
            label: 'Languages',
            value: (raceDetails['languages'] as List<dynamic>?)?.join(', ') ?? 'None',
            icon: Icons.language,
          ),
          _buildAttributeRow(
            label: 'Traits',
            value: (raceDetails['traits'] as List<dynamic>?)?.join(', ') ?? 'None',
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
