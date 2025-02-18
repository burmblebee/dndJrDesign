import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/character_item.dart';
import '../../screens/dnd_forms/character_loader_screen.dart';
import '../../screens/dnd_forms/character_name.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/character.dart';
import '../../widgets/dnd_form_widgets/main_drawer.dart';

class UserCharacterScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _UserCharacterScreenState createState() => _UserCharacterScreenState();
}

class _UserCharacterScreenState extends State<UserCharacterScreen> {
  List<Character> characters = [];
  var imageURL;
  final Color customColor = const Color.fromARGB(255, 138, 28, 20);

  @override
  void initState() {
    setState(() {});
    super.initState();
    setState(() {});
    fetchCharacters();
  }

  // Method to fetch characters and their imageURL from Firestore
  Future<void> fetchCharacters() async {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('app_user_profiles')
            .doc(currentUserUid)
            .collection('characters')
            .get();

        final List<Character> loadedCharacters = [];
        for (var doc in querySnapshot.docs) {
          final data = doc.data();

          imageURL = data['imageUrl'] ?? '';

          // Add character data including imageURL
          loadedCharacters.add(
            Character.fromMap(data),
          );
        }

        setState(() {
          characters = loadedCharacters;
        });
      } catch (e) {
        print('Error fetching characters: $e');
      }
    }
  }

  // Method to remove a character from Firestore
  void removeCharacter(Character character) {
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      try {
        FirebaseFirestore.instance
            .collection('app_user_profiles')
            .doc(currentUserUid)
            .collection('characters')
            .doc(character.name)
            .delete();

        setState(() {
          characters.remove(character);
        });
      } catch (e) {
        print('Error removing character: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Characters"),
        backgroundColor: customColor,
        foregroundColor: Colors.white,
      ),
      drawer: const MainDrawer(),
      body: characters.isEmpty
          ? const Center(child: Text('Make a character!'))
          : ListView.builder(
              itemCount: characters.length,
              itemBuilder: (ctx, index) => Dismissible(
                key: ValueKey(characters[index].name),
                background: Container(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.75),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onDismissed: (direction) {
                  removeCharacter(characters[index]);
                },
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CharacterLoaderScreen(
                          characterName: characters[index].name,
                          characterBackground: characters[index].background,
                          characterClass: characters[index].characterClass,
                          characterRace: characters[index].race,
                          abilityScores: characters[index].abilityScores,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: characters[index].picture.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.network(
                                characters[index].picture, // Fetching imageURL
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.person, size: 50),
                      title: Text(
                        characters[index].name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${characters[index].race} - ${characters[index].characterClass}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          removeCharacter(characters[index]);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CharacterName()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

