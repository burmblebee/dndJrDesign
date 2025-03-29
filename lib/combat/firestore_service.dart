import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future<void> updateCombatantStat(String campaignId, String combatantId, int health) async {
    await firestore
        .collection('user_campaigns')
        .doc(campaignId)
        .collection('combatants')
        .doc(combatantId)
        .update({'hp': health});
  }
}
