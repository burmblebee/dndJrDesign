import 'package:flutter/material.dart';

class WeaponDataLoader extends StatelessWidget {
  const WeaponDataLoader({
    Key? key,
    required this.weaponName,
    required this.weaponType,
    required this.details,
  }) : super(key: key);

  final String weaponName;
  final String weaponType;
  final Map<String, dynamic> details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weaponName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          _buildAttributeRow(
            label: 'Damage Die',
            value: details['damage_die'] ?? 'N/A',
            icon: Icons.opacity,
          ),
          _buildAttributeRow(
            label: 'Gold Cost',
            value: details['gold_cost'] ?? 'N/A',
            icon: Icons.monetization_on,
          ),
          _buildAttributeRow(
            label: 'Damage Type',
            value: details['damage_type'] ?? 'N/A',
            icon: Icons.flash_on,
          ),
          _buildAttributeRow(
            label: 'Properties',
            value: _listToString(details['properties']),
            icon: Icons.info_outline,
          ),
          _buildAttributeRow(
            label: 'Weight',
            value: details['weight'] ?? 'N/A',
            icon: Icons.line_weight,
          ),
        ],
      ),
    );
  }

  String _listToString(dynamic value) {
    if (value != null) {
      if (value is List && value.isNotEmpty) {
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
