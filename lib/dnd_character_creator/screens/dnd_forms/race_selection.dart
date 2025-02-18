import '../../Widgets/buttons/navigation_button.dart';
import '../../Widgets/dnd_form_widgets/race_data_loader.dart';
import '../../widgets/dnd_form_widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import '../../Widgets/buttons/button_with_padding.dart';
import '../../Screens/dnd_forms/class_selection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RaceSelection extends StatefulWidget {
  final String characterName;

  const RaceSelection({super.key, required this.characterName});

  @override
  _RaceSelectionState createState() => _RaceSelectionState();
}

class _RaceSelectionState extends State<RaceSelection> {
  String _selectedRace = 'Elf'; // Default race
  final Color customColor = const Color.fromARGB(255, 138, 28, 20);

  Future<void> _saveSelections() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final docRef = firestore.collection('characters').doc(widget.characterName);

      await docRef.set({
        'race': _selectedRace,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save data: $e")),
      );
    }
  }

  void _updateSelectedRace(String raceName) {
    setState(() {
      _selectedRace = raceName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        children: [
          NavigationButton(
            textContent: "Back",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 30),
          NavigationButton(
            textContent: "Next",
            onPressed: () {
              _saveSelections();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassSelection(
                    characterName: widget.characterName,
                    race: _selectedRace,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: customColor,
        foregroundColor: Colors.white,
        title: Text(
          'Race Selection for ${widget.characterName}',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Pick your race',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var race in [
                'Aasimar', 'Dragonborn', 'Dwarf', 'Elf', 'Gnome', 'Halfling',
                'Human', 'Orc', 'Tiefling'
              ])
                ButtonWithPadding(
                  onPressed: () => _updateSelectedRace(race),
                  textContent: race,
                ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              height: 350,
              width: 350,
              child: SingleChildScrollView(
                child: RaceDataLoader(raceName: _selectedRace),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
