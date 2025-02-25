import 'package:riverpod/riverpod.dart';
import 'character.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CombatState {
  final List<Character> characters;
  final int currentTurnIndex;

  CombatState({required this.characters, this.currentTurnIndex = 0});

  CombatState copyWith({List<Character>? characters, int? currentTurnIndex}) {
    return CombatState(
      characters: characters ?? this.characters,
      currentTurnIndex: currentTurnIndex ?? this.currentTurnIndex,
    );
  }
}

class CombatStateNotifier extends StateNotifier<CombatState> {
  CombatStateNotifier()
      : super(CombatState(characters: [
    Character(name: 'Suffering', health: 2, maxHealth: 100, armorClass: 17),
    Character(name: 'Help', health: 17, maxHealth: 100, armorClass: 9),
    Character(name: 'Pain', health: 9, maxHealth: 100, armorClass: 10),
    Character(name: 'Fear', health: 2, maxHealth: 100, armorClass: 17),
    Character(name: 'Despair', health: 17, maxHealth: 100, armorClass: 9),
    Character(name: 'Perchance', health: 9, maxHealth: 100, armorClass: 10),
    Character(name: 'Mayhaps', health: 2, maxHealth: 100, armorClass: 17),
    Character(name: 'Death', health: 17, maxHealth: 100, armorClass: 9),
  ]));

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void nextTurn() {
    if (state.characters.isNotEmpty) {
      final newIndex = (state.currentTurnIndex + 1) % state.characters.length; // Wrap around using modulo
      print('Advancing turn from ${state.currentTurnIndex} to $newIndex');
      state = state.copyWith(currentTurnIndex: newIndex);
    }
  }

  void setCharacters(List<Character> characters) {
    state = state.copyWith(characters: characters);
  }

  void updateHealth(String characterName, int newHealth) {
    state = state.copyWith(
      characters: [
        for (final char in state.characters)
          if (char.name == characterName)
            char.copyWith(health: newHealth)
          else
            char
      ],
    );
  }

  void addCharacter(String name, int health, int maxHealth, int armorClass) {
    state = state.copyWith(
      characters: [
        ...state.characters,
        Character(
          name: name,
          health: health,
          maxHealth: maxHealth,
          armorClass: armorClass,
        ),
      ],
    );
  }

  void removeCharacter(String characterName) {
    state = state.copyWith(
      characters: state.characters.where((char) => char.name != characterName).toList(),
    );
  }

  void reorderCharacters(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final character = state.characters[oldIndex];
    final updatedList = List<Character>.from(state.characters)
      ..removeAt(oldIndex)
      ..insert(newIndex, character);

    state = state.copyWith(characters: updatedList);
  }
}


final combatProvider = StateNotifierProvider<CombatStateNotifier, CombatState>((ref) {
  return CombatStateNotifier();
});
