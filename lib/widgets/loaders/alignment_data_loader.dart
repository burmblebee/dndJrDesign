import 'package:flutter/material.dart';

import '../../data/character creator data/alignment_data.dart';


class AlignmentDataWidget extends StatefulWidget {
  const AlignmentDataWidget({
    super.key,
    required this.alignment,
  });

  final String alignment;

  @override
  State<AlignmentDataWidget> createState() => _AlignmentDataWidgetState();
}

class _AlignmentDataWidgetState extends State<AlignmentDataWidget> {
  @override
  Widget build(BuildContext context) {
    // Fetch the description for the provided alignment
    final String description = alignments[widget.alignment] ?? "Unknown alignment";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildAttributeRow(
            label: widget.alignment,
            value: description,
            icon: Icons.balance,
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
          Expanded( // Use Expanded to prevent overflow
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