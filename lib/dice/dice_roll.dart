import 'package:cloud_firestore/cloud_firestore.dart';

class DiceRoll {
  List<int> rolls;
  int total;
  String userId;
  String campaignId;

  DiceRoll({
    required this.rolls,
    required this.total,
    required this.userId,
    required this.campaignId,
  });

  Map<String, dynamic> toMap() {
    return {
      'rolls': rolls,
      'total': total,
      'userId': userId,
      'campaignId': campaignId,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
