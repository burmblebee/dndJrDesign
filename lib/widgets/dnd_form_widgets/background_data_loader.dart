import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/data/background_data.dart';


class BackgroundDataLoader extends StatelessWidget {
  const BackgroundDataLoader({super.key, required this.backgroundName});

  final String backgroundName;

  @override
  Widget build(BuildContext context) {
    final backgroundData = BackgroundData[backgroundName];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            backgroundName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          _buildAttributeRow(
            label: 'Description',
            value: backgroundData!['description'] ?? 'N/A',
          ),
          _buildAttributeRow(
            label: 'Skills',
            value: _listToString(backgroundData['skills']),
            icon: Icons.lightbulb
          ),
          _buildAttributeRow(
            label: 'Languages',
            value: _listToString(backgroundData['languages']),
            icon: Icons.language
          ),
          _buildAttributeRow(
            label: 'Tools',
            value: _listToString(backgroundData['tools']),
            icon: Icons.construction
          ),
          _buildAttributeRow(
            label: 'Equipment',
            value: _listToString(backgroundData['equipment']),
            icon: Icons.shopping_bag
          ),
          _buildAttributeRow(
            label: 'Feature',
            value: backgroundData['feature'] ?? 'N/A',
            icon: Icons.auto_awesome
          ),
        ],
      ),
    );
  }
String _listToString(dynamic value) {

    if (value.isNotEmpty) {
      if(value is List) {
        return value.join(', ');
      }
      return value.toString();
    }
    return 'N/A';
  }



  Widget _buildAttributeRow({
    required String label,
    required String value,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, size: 24.0),
          if (icon != null) const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(label != 'Description')
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  value,
                  softWrap: true,
                  style: const TextStyle(fontSize: 16),
                ),
],
            ),
          ),
        ],
      ),
    );
  }
}