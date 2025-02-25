import 'package:flutter/material.dart';

import 'npc.dart';

class NPCProvider with ChangeNotifier {
  List<NPC> _npcs = [];
  NPC? _selectedNPC;
  List<int> _diceToRoll = List.filled(7, 0);

  List<NPC> get npcs => _npcs;
  NPC? get selectedNPC => _selectedNPC;
  List<int> get diceToRoll => _diceToRoll;

  void addNPC(NPC npc) {
    _npcs.add(npc);
    notifyListeners();
  }

  void selectNPC(NPC npc) {
    _selectedNPC = npc;
    notifyListeners();
  }

  void setDice(List<int> diceConfig) {
    _diceToRoll = List.from(diceConfig);
    notifyListeners();
  }
}
