import 'package:riverpod/riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../combat/combat_character.dart';
import '../npc/npc.dart';
import 'firestore_service.dart';

final diceRollProvider = StateProvider<int>((ref) => 0);

class CombatState {
  final List<CombatCharacter> characters;
  final int currentTurnIndex;

  CombatState({required this.characters, this.currentTurnIndex = 0});

  CombatState copyWith({List<CombatCharacter>? characters, int? currentTurnIndex}) {
    return CombatState(
      characters: characters ?? this.characters,
      currentTurnIndex: currentTurnIndex ?? this.currentTurnIndex,
    );
  }
}

class CombatStateNotifier extends StateNotifier<CombatState> {
  final FirestoreService _firestoreService = FirestoreService();  // Create an instance

  CombatStateNotifier({required this.campaignId})
      : super(CombatState(characters: [
    // Add your initial characters here
  ])) {
    _loadCombatData();
  }

  // Add startCombat method that uses _firestoreService
  void startCombat(String campaignId) async {
    await _firestoreService.initializeCombat(campaignId, state.characters);  // Use the instance here
  }


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String campaignId;

  // Load combat data from Firestore and listen for real-time updates
  void _loadCombatData() {
    _firestore.collection('user_campaigns').doc(campaignId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        List<CombatCharacter> fetchedCharacters = (data['characters'] as List)
            .map((char) => CombatCharacter.fromMap(char))
            .toList();

        state = state.copyWith(
          characters: fetchedCharacters,
          currentTurnIndex: data['currentTurnIndex'] ?? 0,
        );
      }
    });
  }

  // Update Firestore with new turn index
  void nextTurn() {
    if (state.characters.isNotEmpty) {
      final newIndex = (state.currentTurnIndex + 1) % state.characters.length;
      state = state.copyWith(currentTurnIndex: newIndex);

      _firestore.collection('user_campaigns').doc(campaignId).update({
        'currentTurnIndex': newIndex,
      });
    }
  }

  // Update character health and sync with Firestore
  void updateHealth(String characterName, int newHealth) {
    List<CombatCharacter> updatedCharacters = state.characters.map((char) {
      return char.name == characterName ? char.copyWith(health: newHealth) : char;
    }).toList();

    state = state.copyWith(characters: updatedCharacters);

    _firestore.collection('user_campaigns').doc(campaignId).update({
      'characters': updatedCharacters.map((c) => c.toFirestore()).toList(),
    });
  }

  // Add new character and sync with Firestore
  void addCharacter(CombatCharacter newCharacter) {
    List<CombatCharacter> updatedCharacters = [...state.characters, newCharacter];
    state = state.copyWith(characters: updatedCharacters);

    _firestore.collection('user_campaigns').doc(campaignId).update({
      'characters': updatedCharacters.map((c) => c.toFirestore()).toList(),
    });
  }

  // Remove character and sync with Firestore
  void removeCharacter(String characterName) {
    List<CombatCharacter> updatedCharacters = state.characters
        .where((char) => char.name != characterName)
        .toList();

    state = state.copyWith(characters: updatedCharacters);

    _firestore.collection('user_campaigns').doc(campaignId).update({
      'characters': updatedCharacters.map((c) => c.toFirestore()).toList(),
    });
  }

  // Reorder characters and sync with Firestore
  void reorderCharacters(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex -= 1;
    final character = state.characters[oldIndex];

    List<CombatCharacter> updatedCharacters = List.from(state.characters)
      ..removeAt(oldIndex)
      ..insert(newIndex, character);

    state = state.copyWith(characters: updatedCharacters);

    _firestore.collection('user_campaigns').doc(campaignId).update({
      'characters': updatedCharacters.map((c) => c.toFirestore()).toList(),
    });
  }
}

final combatProvider = StateNotifierProvider.family<CombatStateNotifier, CombatState, String>((ref, campaignId) {
  return CombatStateNotifier(campaignId: campaignId);
});
