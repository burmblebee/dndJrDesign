import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dice_roll.dart';

class DiceRollProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendDiceRoll(DiceRoll diceRoll) async {
    try {
      await _firestore.collection('campaigns').doc(diceRoll.campaignId).set(
        diceRoll.toMap(),
        SetOptions(merge: true),
      );
      notifyListeners();
    } catch (error) {
      print('Error saving dice rolls: $error');
    }
  }
}
