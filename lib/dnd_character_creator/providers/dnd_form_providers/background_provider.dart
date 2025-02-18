import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BackgroundProvider with ChangeNotifier {
  String _selectedBackground = 'Acolyte';

  String get selectedBackground => _selectedBackground;

  void updateBackground(String newBackground) {
    _selectedBackground = newBackground;
    notifyListeners(); // Notify listeners to rebuild widgets that depend on this value
  }

  Future<void> saveBackgroundSelection(int characterID) async {
    final url = Uri.https(
        'dndmobilecharactercreator-default-rtdb.firebaseio.com',
        '$characterID.json');

    // Fetch current data
    final response = await http.get(url);
    if (response.body != 'null') {
      await http.delete(url); // Clear previous data if any
    }

    // Save new data
    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'background': _selectedBackground,
      }),
    );
  }
}
