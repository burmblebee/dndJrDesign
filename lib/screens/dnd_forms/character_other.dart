import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class CharacterOther extends StatefulWidget {
  CharacterOther({super.key, required this.characterName});

  final characterName;

  @override
  State<CharacterOther> createState() => _CharacterOtherState();
}

class _CharacterOtherState extends State<CharacterOther> {
  Color customColor = const Color.fromARGB(255, 138, 28, 20);
//TODO: Fetch from firestore
  var chosenlifeStyle = 'Wealthy';
  var chosenAlignment = 'Lawful Good';
  var chosenFaith = 'Flat Earther';
  var chosenLanguages = ['Common', 'Dwarvish', 'Elvish'];
  var chosenHair = 'Brown';
  var chosenEyes = 'Brown';
  var chosenSkin = 'White';
  var chosenHeight = '5\'10"';
  var chosenWeight = '150 lbs';
  var chosenAge = '25';
  var chosenGender = 'Male';
  var chosenPersonality = 'Aggressive';
  var chosenIdeals = 'Justice';
  var chosenBonds = 'Family';
  var chosenFlaws =
      'Frogs are very scary. Whenever I see a frog jump into a lake full of frogs I cry. Avoid frogs at all costs';
  var chosenOrganizations = 'Marching Band';
  var chosenAllies = 'The french horn paleyers';
  var chosenEnemies = 'Trumpets and football players';
  var chosenBackstory = 'I was once a frog.';
  var everythingElse = 'I have no idea what I am doing.';

  @override
  void initState() {
    super.initState();
    _fetchCharacterTraits();
  }

  Future<void> _fetchCharacterTraits() async {
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null) {
      try {
        final docRef = FirebaseFirestore.instance
            .collection('app_user_profiles')
            .doc(currentUserUid)
            .collection('characters')
            .doc(widget.characterName);

        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data['characterTraits'] != null) {
            final traits = Map<String, dynamic>.from(data['characterTraits']);
            setState(() {
              chosenAlignment = traits['alignment'] ?? 'Unknown';
              chosenFaith = traits['faith'] ?? 'Unknown';
              chosenlifeStyle = traits['lifestyle'] ?? 'Unknown';
              chosenHair = traits['hair'] ?? 'Unknown';
              chosenEyes = traits['eyes'] ?? 'Unknown';
              chosenSkin = traits['skin'] ?? 'Unknown';
              chosenHeight = traits['height'] ?? 'Unknown';
              chosenWeight = traits['weight'] ?? 'Unknown';
              chosenAge = traits['age'] ?? 'Unknown';
              chosenGender = traits['gender'] ?? 'Unknown';
              chosenPersonality = traits['personalityTraits'] ?? 'Unknown';
              chosenIdeals = traits['ideals'] ?? 'Unknown';
              chosenBonds = traits['bonds'] ?? 'Unknown';
              chosenFlaws = traits['flaws'] ?? 'Unknown';
              chosenOrganizations = traits['organization'] ?? 'Unknown';
              chosenAllies = traits['allies'] ?? 'Unknown';
              chosenEnemies = traits['enemies'] ?? 'Unknown';
              chosenBackstory = traits['backstory'] ?? 'Unknown';
              everythingElse = traits['other'] ?? 'Unknown';
            });
          }
        } else {
          print('Document does not exist.');
        }
      } catch (e) {
        print('Error fetching traits: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Divider(color: Colors.black, thickness: 2),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 25),
              const Text(
                "Lifestyle",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: Text(
                  '.............................................',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(chosenlifeStyle,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const SizedBox(width: 25),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 25),
              const Text(
                "Alignment",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: Text(
                  '..........................................',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(chosenAlignment,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const SizedBox(width: 25),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 25),
              const Text(
                "Faith",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: Text(
                  '.............................................',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(chosenFaith,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const SizedBox(width: 25),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.black, thickness: 2),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(width: 25),
              Text(
                "Languages",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            height: 75,
            width: 375,
            child: SingleChildScrollView(
              child: Text(chosenLanguages.join(', '),
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.black, thickness: 2),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 25),
              const Text(
                "Hair",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: Text(
                  '.............................................',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(chosenHair,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const SizedBox(width: 25),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 25),
              const Text(
                "Eyes",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: Text(
                  '..........................................',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(chosenEyes,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const SizedBox(width: 25),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 25),
              const Text(
                "Skin",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: Text(
                  '.............................................',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(chosenSkin,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const SizedBox(width: 25),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 25),
              const Text(
                "Height",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: Text(
                  '.............................................',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(chosenHeight,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const SizedBox(width: 25),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 25),
              const Text(
                "Weight",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: Text(
                  '.............................................',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(chosenWeight,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const SizedBox(width: 25),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 25),
              const Text(
                "Age",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: Text(
                  '.............................................',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(chosenAge,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const SizedBox(width: 25),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 25),
              const Text(
                "Gender",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: Text(
                  '.............................................',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(chosenGender,
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const SizedBox(width: 25),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.black, thickness: 2),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(width: 25),
              Text(
                "Personality",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            height: 150,
            width: 375,
            child: SingleChildScrollView(
              child: Text(chosenPersonality,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(width: 25),
              Text(
                "Ideals",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            height: 150,
            width: 375,
            child: SingleChildScrollView(
              child: Text(chosenIdeals,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(width: 25),
              Text(
                "Bonds",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            height: 150,
            width: 375,
            child: SingleChildScrollView(
              child: Text(chosenBonds,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(width: 25),
              Text(
                "Flaws",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            height: 150,
            width: 375,
            child: SingleChildScrollView(
              child: Text(chosenFlaws,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.black, thickness: 2),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(width: 25),
              Text(
                "Organizations",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            height: 150,
            width: 375,
            child: SingleChildScrollView(
              child: Text(chosenOrganizations,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(width: 25),
              Text(
                "Allies",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            height: 150,
            width: 375,
            child: SingleChildScrollView(
              child: Text(chosenAllies,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(width: 25),
              Text(
                "Enemies",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            height: 150,
            width: 375,
            child: SingleChildScrollView(
              child: Text(chosenEnemies,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(width: 25),
              Text(
                "Backstory",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            height: 150,
            width: 375,
            child: SingleChildScrollView(
              child: Text(chosenBackstory,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              SizedBox(width: 25),
              Text(
                "Other Notes",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
            height: 150,
            width: 375,
            child: SingleChildScrollView(
              child: Text(everythingElse,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
