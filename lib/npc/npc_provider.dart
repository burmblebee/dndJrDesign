import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'npc.dart';

class NPCState {
  final List<NPC> npcs;
  final NPC? selectedNPC;
  final List<int> diceToRoll;
  final List<AttackOption> attackOptions;

  NPCState({
    required this.npcs,
    this.selectedNPC,
    required this.diceToRoll,
    required this.attackOptions,
  });

  NPCState copyWith({
    List<NPC>? npcs,
    NPC? selectedNPC,
    List<int>? diceToRoll,
    List<AttackOption>? attackOptions,
  }) {
    return NPCState(
      npcs: npcs ?? this.npcs,
      selectedNPC: selectedNPC ?? this.selectedNPC,
      diceToRoll: diceToRoll ?? this.diceToRoll,
      attackOptions: attackOptions ?? this.attackOptions,
    );
  }
}

final npcProvider = StateNotifierProvider<NPCProvider, NPCState>(
      (ref) => NPCProvider(),
);

class NPCProvider extends StateNotifier<NPCState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NPCProvider()
      : super(NPCState(
    npcs: [],
    selectedNPC: null,
    diceToRoll: List.filled(7, 0),
    attackOptions: [],
  ));

  Future<void> addNPC(NPC npc, String npcId) async {
    try {
      await _firestore.collection('npcs').doc(npcId).set({
        'name': npc.name,
        'attacks': npc.attacks.map((attack) =>
        {
          'name': attack.name,
          'diceConfig': attack.diceConfig,
        }).toList(),
      });

      state = state.copyWith(npcs: [...state.npcs, npc]);
    } catch (e) {
      print("Error adding NPC to Firestore: $e");
    }
  }


  Future<void> fetchNPCs() async {
    try {
      final querySnapshot = await _firestore.collection('npcs').get();
      final npcs = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return NPC(
          id: doc.id,
          name: data['name'],
          attacks: (data['attacks'] as List<dynamic>).map((attack) {
            return AttackOption(
              name: attack['name'],
              diceConfig: List<int>.from(attack['diceConfig']),
            );
          }).toList(),
        );
      }).toList();

      state = state.copyWith(npcs: npcs);
    } catch (e) {
      print("Error fetching NPCs: $e");
    }
  }

  Future<void> updateNPC(NPC npc) async {
    try {
      await _firestore.collection('npcs').doc(npc.id).update({
        'name': npc.name,
        'attacks': npc.attacks.map((attack) =>
        {
          'name': attack.name,
          'diceConfig': attack.diceConfig,
        }).toList(),
      });

      state = state.copyWith(npcs: [
        ...state.npcs.where((existingNpc) => existingNpc.id != npc.id),
        npc,
      ]);
    } catch (e) {
      print("Error updating NPC: $e");
    }
  }

  Future<void> editNPCName(NPC npc, String newName) async {
    try {
      await _firestore.collection('npcs').doc(npc.id).update({
        'name': newName,
      });

      final updatedNpcs = state.npcs.map((currNpc) {
        if (currNpc.id == npc.id) {
          return currNpc.copyWith(name: newName);
        }
        return currNpc;
      }).toList();

      final updatedSelectedNPC = state.selectedNPC?.id == npc.id
          ? state.selectedNPC!.copyWith(name: newName)
          : state.selectedNPC;

      state =
          state.copyWith(npcs: updatedNpcs, selectedNPC: updatedSelectedNPC);
    } catch (e) {
      print("Error updating NPC name: $e");
    }
  }


  Future<void> editAttackOption(String npcId, int attackIndex,
      AttackOption updatedAttack) async {
    try {
      final npcIndex = state.npcs.indexWhere((npc) => npc.id == npcId);
      if (npcIndex == -1) return; // NPC not found

      final updatedAttacks = List<AttackOption>.from(
          state.npcs[npcIndex].attacks);
      updatedAttacks[attackIndex] = updatedAttack;

      await _firestore.collection('npcs').doc(npcId).update({
        'attacks': updatedAttacks.map((attack) =>
        {
          'name': attack.name,
          'diceConfig': attack.diceConfig,
        }).toList(),
      });

      final updatedNpc = state.npcs[npcIndex].copyWith(attacks: updatedAttacks);
      final updatedNpcs = [...state.npcs]..[npcIndex] = updatedNpc;

      state = state.copyWith(npcs: updatedNpcs, selectedNPC: updatedNpc);
    } catch (e) {
      print("Error updating attack option: $e");
    }
  }


  Future<void> deleteNPC(String npcId) async {
    try {
      await _firestore.collection('npcs').doc(npcId).delete();
      state =
          state.copyWith(npcs: state.npcs.where((n) => n.id != npcId).toList());
    } catch (e) {
      print("Error deleting NPC: $e");
    }
  }


  void selectNPC(NPC npc) {
    state = state.copyWith(selectedNPC: npc);
  }

  void setDice(List<int> diceConfig) {
    state = state.copyWith(diceToRoll: List.from(diceConfig));
  }

  void addAttackOption(AttackOption attack) {
    var currentNPC = state.selectedNPC;
    if (currentNPC != null) {
      final updatedAttacks = [...currentNPC.attacks, attack];
      final updatedNPC = currentNPC.copyWith(attacks: updatedAttacks);

      state = state.copyWith(selectedNPC: updatedNPC);
      updateNPC(updatedNPC); // Save changes to Firestore
    }
  }

  void updateAttackOption(int index, AttackOption newAttack) {
    var currentNPC = state.selectedNPC;
    if (currentNPC != null) {
      final updatedAttacks = List<AttackOption>.from(currentNPC.attacks);
      updatedAttacks[index] = newAttack;

      final updatedNPC = currentNPC.copyWith(attacks: updatedAttacks);
      state = state.copyWith(selectedNPC: updatedNPC);
      updateNPC(updatedNPC); // Save changes to Firestore
    }
  }

  void removeAttackOption(int index) {
    var currentNPC = state.selectedNPC;
    if (currentNPC != null && index < currentNPC.attacks.length) {
      final updatedAttacks = List<AttackOption>.from(currentNPC.attacks)
        ..removeAt(index);
      final updatedNPC = currentNPC.copyWith(attacks: updatedAttacks);

      state = state.copyWith(selectedNPC: updatedNPC);
      updateNPC(updatedNPC); // Save changes to Firestore
    }
  }

}