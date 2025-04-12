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

  Future<void> _deleteCharacter(String characterID, int index) async {
    final User user = FirebaseAuth.instance.currentUser!;
    final uuid = user.uid;

    try {
      String characterName = characters[index]['name'] ?? 'Character';

      await FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(uuid)
          .collection('characters')
          .doc(characterID)
          .delete();

      setState(() {
        characters.removeAt(index);
        characterIDs.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$characterName was deleted.'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error deleting character: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete character: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character List'),
      ),
      bottomNavigationBar: MainBottomNavBar(),
      drawer: MainDrawer(),
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
                    final levelClass =
                        'Level ${character['level'] ?? 'Unknown'} ${character['class'] ?? 'Unknown'}';

                    return Dismissible(
                      key: ValueKey(characterID),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        bool? confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Character'),
                            content: const Text(
                                'Are you sure you want to delete this character?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        );
                        return confirm ?? false;
                      },
                      onDismissed: (direction) {
                        _deleteCharacter(characterID, index);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: SvgPicture.asset(
                            assetName,
                            height: 56,
                            width: 56,
                            alignment: Alignment.center,
                            color: Theme.of(context).iconTheme.color,
                            placeholderBuilder: (context) =>
                                const CircularProgressIndicator(),
                          ),
                          title: Text(
                            character['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '$levelClass\nRace: ${character['race'] ?? 'Unknown'}',
                          ),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CharacterSheet(characterID: characterID, inSession: false,),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
