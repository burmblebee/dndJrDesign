import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import 'character_sheet.dart';

class CharacterList extends StatefulWidget {
  const CharacterList({Key? key}) : super(key: key);

  @override
  _CharacterListState createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  List<Map<String, dynamic>> characters = [];
  List<String> characterIDs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<void> _fetchCharacters() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return;
      } else {
        final User user = FirebaseAuth.instance.currentUser!;
        final uuid = user.uid;

        // Fetch all characters from Firestore
        QuerySnapshot characterSnapshot = await FirebaseFirestore.instance
            .collection('app_user_profiles')
            .doc(uuid)
            .collection('characters')
            .get();

        setState(() {
          characters = characterSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          characterIDs = characterSnapshot.docs.map((doc) => doc.id).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching characters: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch characters: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      appBar: AppBar(
        title: const Text('Character List'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : characters.isEmpty
              ? const Center(
                  child: Text(
                    'No characters found.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    final character = characters[index];
                    final characterID = characterIDs[index];
                    final assetName =
                        'assets/${character['class'] ?? 'default'}.svg';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(
                          character['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Level: ${character['level'] ?? 'Unknown'}\n'
                          'Race: ${character['race'] ?? 'Unknown'}\n'
                          'Class: ${character['class'] ?? 'Unknown'}',
                        ),
                        trailing: Center(
                          child: SvgPicture.asset(
                            assetName,
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported);
                            },
                          ),
                        ),
                        isThreeLine: true,
                        onTap: () {
                          // Navigate to CharacterSheet and pass the characterID
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CharacterSheet(characterID: characterID),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
