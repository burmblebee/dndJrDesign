import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Function to save character name to Firestore
  Future<void> saveCharacterName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If no user is signed in, print an error
        print('No user is signed in!');
        return;
      }
    } catch (e) {
      print('Error saving character name: $e');
    }
  }

  //set up save character name to send a map with the character name to the firestore
  final customColor = const Color.fromARGB(255, 138, 28, 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColor,foregroundColor: Colors.white,
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

                      // Navigate to the next screen with characterID as characterName
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RaceSelection(
                            characterName: _characterName, // Pass character name
                          ),
                        ),
                      );
                    } else {
                      // Show an error message if the character name is empty
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
