import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CharacterSheet extends StatefulWidget {
  final String characterID;

  const CharacterSheet({Key? key, required this.characterID}) : super(key: key);

  @override
  _CharacterSheetState createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  // Variables to hold character data
  String name = '';
  String race = '';
  String characterClass = '';
  String background = '';
  String alignment = '';
  String faith = '';
  String lifestyle = '';
  String hair = '';
  String eyes = '';
  String skin = '';
  String height = '';
  String weight = '';
  String age = '';
  String gender = '';
  String personalityTraits = '';
  String ideals = '';
  String bonds = '';
  String flaws = '';
  String organizations = '';
  String allies = '';
  String enemies = '';
  String backstory = '';
  String other = '';
  Map<String, dynamic> abilityScores = {};
  List<dynamic> weapons = [];
  List<dynamic> cantrips = [];
  List<dynamic> spells = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCharacterData();
  }

  Future<void> _fetchCharacterData() async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        return;
      } else {
        final User user = FirebaseAuth.instance.currentUser!;
        final uuid = user.uid;

        // Fetch the character data from Firestore
        DocumentSnapshot characterSnapshot = await FirebaseFirestore.instance
            .collection('app_user_profiles')
            .doc(uuid) // Use the actual user ID
            .collection('characters')
            .doc(widget.characterID)
            .get();

        if (characterSnapshot.exists) {
          final data = characterSnapshot.data() as Map<String, dynamic>;

          setState(() {
            // Assign data to variables
            name = data['name'] ?? '';
            race = data['race'] ?? '';
            characterClass = data['class'] ?? '';
            background = data['background'] ?? '';
            alignment = data['alignment'] ?? '';
            faith = data['faith'] ?? '';
            lifestyle = data['lifestyle'] ?? '';
            hair = data['hair'] ?? '';
            eyes = data['eyes'] ?? '';
            skin = data['skin'] ?? '';
            height = data['height'] ?? '';
            weight = data['weight'] ?? '';
            age = data['age'] ?? '';
            gender = data['gender'] ?? '';
            personalityTraits = data['personalityTraits'] ?? '';
            ideals = data['ideals'] ?? '';
            bonds = data['bonds'] ?? '';
            flaws = data['flaws'] ?? '';
            organizations = data['organizations'] ?? '';
            allies = data['allies'] ?? '';
            enemies = data['enemies'] ?? '';
            backstory = data['backstory'] ?? '';
            other = data['other'] ?? '';
            abilityScores = data['abilityScores'] ?? {};
            weapons = data['weapons'] ?? [];
            cantrips = data['cantrips'] ?? [];
            spells = data['spells'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Character not found.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error fetching character data: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch character data: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Sheet'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: $name',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Race: $race', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Text('Class: $characterClass',
                      style: const TextStyle(fontSize: 16)),
                  
                ],
              ),
            ),
    );
  }
}