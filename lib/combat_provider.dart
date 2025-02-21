import 'package:riverpod/riverpod.dart';
import 'character.dart';

class CombatStateNotifier extends StateNotifier<List<Character>> {
  CombatStateNotifier() : super([
    Character(name: 'Suffering', health: 2, maxHealth: 100, armorClass: 17),
    Character(name: 'Help', health: 17, maxHealth: 100, armorClass: 9),
    Character(name: 'Pain', health: 9, maxHealth: 100, armorClass: 10),
    Character(name: 'Fear', health: 2, maxHealth: 100, armorClass: 17),
    Character(name: 'Despair', health: 17, maxHealth: 100, armorClass: 9),
    Character(name: 'Perchance', health: 9, maxHealth: 100, armorClass: 10),
    Character(name: 'Mayhaps', health: 2, maxHealth: 100, armorClass: 17),
    Character(name: 'Death', health: 17, maxHealth: 100, armorClass: 9),
  ]);

  void setCharacters(List<Character> characters) {
    state = characters;
  }

  void updateHealth(String characterName, int newHealth) {
    state = [
      for (final char in state)
        if (char.name == characterName)
          char.copyWith(health: newHealth)
        else
          char
    ];
  }

  void reorderCharacters(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final character = state[oldIndex];
    final updatedList = List<Character>.from(state)
      ..removeAt(oldIndex)
      ..insert(newIndex, character);
    state = updatedList;
  }
}

final combatProvider =
StateNotifierProvider<CombatStateNotifier, List<Character>>((ref) {
  return CombatStateNotifier();
});
