import '../../screens/dnd_forms/background_selection.dart';
import '../../screens/dnd_forms/specifics_screen.dart';
import '../../Widgets/dnd_form_widgets/class_data_loader.dart';
import '../../Widgets/buttons/navigation_button.dart';
import '../../widgets/dnd_form_widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import '../../widgets/buttons/button_with_padding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassSelection extends StatefulWidget {
  final String characterName;
  final String race; // Add characterName parameter

  const ClassSelection({Key? key, required this.characterName, required this.race}) : super(key: key); // Update constructor

  @override
  _ClassSelectionState createState() => _ClassSelectionState();
}

class _ClassSelectionState extends State<ClassSelection> {
  String selectedClassName = 'Sorcerer'; // Default class

  // Method to save the selected class to Firebase
  void _saveSelections() async {
    final docRef = FirebaseFirestore.instance
        .collection('characters')
        .doc(widget.characterName); // Use character name as document ID

    try {
      await docRef.set({
        'class': selectedClassName,
        'name': widget.characterName,
      }, SetOptions(merge: true)); // Merge ensures only this field is updated
    } catch (e) {
      print('Error saving class: $e');
    }
  }

  // Updates the selected class and calls setState
  void updateSelectedClass(String className) {
    setState(() {
      selectedClassName = className;
    });
  }

  final customColor = const Color.fromARGB(255, 138, 28, 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0, ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavigationButton(
              textContent: "Back",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            NavigationButton(
              textContent: 'Next',
              onPressed: () {
                _saveSelections(); // Save class selection before navigating
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BackgroundScreen(
                      // Pass characterName, className, and raceName
                      characterName: widget.characterName, 
                      className: selectedClassName, 
                      raceName: widget.race,      // Pass selected class name
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: customColor, 
        foregroundColor: Colors.white,
        title: Text(
          'Class Selection for ${widget.characterName}', // Use characterName here
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      drawer: MainDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          const Text(
            'Pick your class',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10, // Space between buttons
            runSpacing: 10, // Space between rows
            children: <Widget>[
              ButtonWithPadding(
                onPressed: () => updateSelectedClass('Barbarian'),
                textContent: 'Barbarian',
              ),
              ButtonWithPadding(
                onPressed: () => updateSelectedClass('Bard'),
                textContent: 'Bard',
              ),
              ButtonWithPadding(
                onPressed: () => updateSelectedClass('Cleric'),
                textContent: 'Cleric',
              ),
              ButtonWithPadding(
                onPressed: () => updateSelectedClass('Druid'),
                textContent: 'Druid',
              ),
              ButtonWithPadding(
                onPressed: () => updateSelectedClass('Fighter'),
                textContent: 'Fighter',
              ),
              ButtonWithPadding(
                onPressed: () => updateSelectedClass('Monk'),
                textContent: 'Monk',
              ),
              ButtonWithPadding(
                onPressed: () => updateSelectedClass('Paladin'),
                textContent: 'Paladin',
              ),
              ButtonWithPadding(
                onPressed: () => updateSelectedClass('Ranger'),
                textContent: 'Ranger',
              ),
              ButtonWithPadding(
                onPressed: () => updateSelectedClass('Rogue'),
                textContent: 'Rogue',
              ),
              ButtonWithPadding(
                onPressed: () => updateSelectedClass('Sorcerer'),
                textContent: 'Sorcerer',
              ),
              ButtonWithPadding(
                onPressed: () => updateSelectedClass('Warlock'),
                textContent: 'Warlock',
              ),
              ButtonWithPadding(
                onPressed: () => updateSelectedClass('Wizard'),
                textContent: 'Wizard',
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
              height: 325,
              width: 325,
              child: SingleChildScrollView(
                child: ClassDataWidget(className: selectedClassName),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
