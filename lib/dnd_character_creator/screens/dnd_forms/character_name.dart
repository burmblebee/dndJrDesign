import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Screens/dnd_forms/race_selection.dart';

class CharacterName extends StatefulWidget {
  const CharacterName({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CharacterNameState();
  }
}

class _CharacterNameState extends State<CharacterName> {
  String _characterName = '';

  // Update character name as user types
  void updateCharacterName(String name) {
    setState(() {
      _characterName = name;
    });
  }

  // Function to save character name to Firestore under the character's name as the document ID
  Future<void> saveCharacterName() async {
    try {
      if (_characterName.isEmpty) {
        print('Character name cannot be empty!');
        return;
      }

      // Save character data under the character's name
      await FirebaseFirestore.instance
          .collection('characters') // Firestore collection
          .doc(_characterName) // Use character name as the document ID
          .set({
        'name': _characterName, // Store name explicitly
        'created_at': Timestamp.now(), // Optional timestamp
      });

      print('Character "$_characterName" saved to Firestore!');
    } catch (e) {
      print('Error saving character name: $e');
    }
  }

  final customColor = const Color.fromARGB(255, 138, 28, 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColor,
        foregroundColor: Colors.white,
        title: const Text('Character Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/dragon.png', height: 244), // Fixed usage
            const SizedBox(height: 20),
            const Text(
              'Enter your character name:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: updateCharacterName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Character Name',
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back
                  },
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_characterName.isNotEmpty) {
                      // Save the character name to Firestore
                      await saveCharacterName();

                      // Navigate to the next screen with character name
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RaceSelection(
                            characterName: _characterName, // Pass character name
                          ),
                        ),
                      );
                    } else {
                      print('Character name cannot be empty!');
                    }
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
