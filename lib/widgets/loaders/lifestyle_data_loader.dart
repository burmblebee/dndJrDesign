import 'package:flutter/material.dart';
import '../../data/lifestyle_data.dart';


class LifestyleDataWidget extends StatefulWidget {
  const LifestyleDataWidget({
    super.key,
    required this.lifestyle,
  });

  final String lifestyle;

  @override
  State<LifestyleDataWidget> createState() => _LifestyleDataWidgetState();
}

class _LifestyleDataWidgetState extends State<LifestyleDataWidget> {
  @override
  Widget build(BuildContext context) {
    final String description = lifestyles[widget.lifestyle] ?? "Unknown alignment";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildAttributeRow(
            label: widget.lifestyle,
            value: description,
            icon: Icons.home,
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
                const SizedBox(height: 4.0), // Add spacing between label and value
                Text(
                  value,
                  softWrap: true,
                  style: const TextStyle(fontSize: 14.0), // Adjust text size for readability
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}