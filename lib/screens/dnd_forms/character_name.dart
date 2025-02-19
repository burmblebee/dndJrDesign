import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warlocks_of_the_beach/widgets/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/main_drawer.dart';
import '../../screens/dnd_forms/race_selection.dart';

class CharacterName extends StatefulWidget {
  const CharacterName({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CharacterNameState();
  }
}

class _CharacterNameState extends State<CharacterName> {
  final TextEditingController _characterNameController = TextEditingController();

  @override
  void dispose() {
    _characterNameController.dispose();
    super.dispose();
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
      final docRef = FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(user.uid)
          .collection('characters')
          .doc(_characterNameController.text);

      await docRef.set({
        'character name': _characterNameController.text,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving character name: $e');
    }
  }

  // Set up save character name to send a map with the character name to Firestore
  final customColor = const Color.fromARGB(255, 138, 28, 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(),
      bottomNavigationBar: MainBottomNavBar(),
      drawer: MainDrawer(),
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
              controller: _characterNameController,
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
                    if (_characterNameController.text.isNotEmpty) {
                      try {
                        // Save the character name to Firestore
                        await saveCharacterName();

                        // Navigate to the next screen with characterID as characterName
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RaceSelection(
                              characterName: _characterNameController.text, // Pass character name
                            ),
                          ),
                        );
                      } catch (e) {
                        print('Error navigating to RaceSelection: $e');
                      }
                    } else {
                      // Show an error message if the character name is empty
                      print('Character name cannot be empty!');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Character name cannot be empty!'),
                        ),
                      );
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