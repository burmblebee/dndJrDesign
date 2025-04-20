import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warlocks_of_the_beach/npc/npc.dart';

import '../combat/combat_character.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Listen for combat updates
  Stream<DocumentSnapshot> getCombatStream(String campaignId) {
    return firestore.collection('user_campaigns').doc(campaignId).snapshots();
  }

  // Update the current turn
  Future<void> updateTurn(String campaignId, int turnIndex) async {
    await firestore.collection('user_campaigns').doc(campaignId).update({
      'currentTurn': turnIndex,
    });
  }

  Future<void> addCharacter(String campaignId, String characterId, String characterName, int maxHealth) async {
    await firestore
        .collection('user_campaigns')
        .doc(campaignId)
        .collection('characters')
        .doc(characterId)
        .set(
      {
        'characterName': characterName,
        'maxHealth': maxHealth,
      },
    );
  }

  // Update HP
  // Future<void> updateCharacterHealth(String campaignId, String characterName, int health) async {
  //   QuerySnapshot querySnapshot = await firestore
  //       .collection('user_campaigns')
  //       .doc(campaignId)
  //       .collection('characters')
  //       .where('name', isEqualTo: characterName)
  //       .get();
  //
  //   if (querySnapshot.docs.isNotEmpty) {
  //     String docId = querySnapshot.docs.first.id; // Get the document ID of the matching character
  //     await firestore
  //         .collection('user_campaigns')
  //         .doc(campaignId)
  //         .collection('characters')
  //         .doc(docId)
  //         .update({'hp': health});
  //   } else {
  //     print("Character $characterName not found in Firestore!");
  //   }
  // }

  Future<void> initializeCombat(String campaignId, List<CombatCharacter> characters) async {
    WriteBatch batch = firestore.batch();
    CollectionReference characterCollection = firestore
        .collection('user_campaigns')
        .doc(campaignId)
        .collection('characters');

    for (var character in characters) {
      DocumentReference charDoc = characterCollection.doc(character.name); // Using name as ID
      batch.set(charDoc, {
        'characterName': character.name,
        'hp': character.health,
        'maxHealth': character.maxHealth,
        'armorClass': character.armorClass,
      });
    }


    await batch.commit();
  }





  Future<void> addCharacterToCampaign(
      String campaignId, String name, int hp, int maxHealth, int ac, List<AttackOption> attacks, bool isNPC) async {
    try {
      final campaignRef = FirebaseFirestore.instance.collection('user_campaigns').doc(campaignId);

      // Check if the document exists
      final docSnapshot = await campaignRef.get();
      if (!docSnapshot.exists) {
        // If the campaign doesn't exist, create it with basic fields
        await campaignRef.set({
          'characters': [], // Initialize characters array if the campaign doesn't exist
          'currentTurn': 0, // or some default value
          'turnOrder': [],
        });
      }

      // Now proceed to add the character
      final attacksMap = attacks.map((attack) => attack.toMap()).toList();
      final user = FirebaseAuth.instance.currentUser;

      if(isNPC) {
        await campaignRef.update({
          'characters': FieldValue.arrayUnion([{
            'playerId': null,
            'name': name,
            'hp': hp,
            'maxHealth': maxHealth,
            'ac': ac,
            'attacks': attacksMap,
            'isNPC': true,
          }
          ]),
        });
      } else {
        await campaignRef.update({
          'characters': FieldValue.arrayUnion([{
            'playerId': user?.uid,
            'name': name,
            'hp': hp,
            'maxHealth': maxHealth,
            'ac': ac,
            'attacks': attacksMap,
            'isNPC': false,
          }]),
        });

      }


    } catch (e) {
      print("Error adding character: $e");
    }
  }


  // Remove character from the campaign
  Future<void> removeCharacterFromCampaign(String campaignId, String characterName) async {
    try {
      final campaignRef = FirebaseFirestore.instance.collection('user_campaigns').doc(campaignId);
      await campaignRef.update({
        'characters': FieldValue.arrayRemove([{'name': characterName}]),
      });
    } catch (e) {
      print("Error removing character: $e");
    }
  }
}
