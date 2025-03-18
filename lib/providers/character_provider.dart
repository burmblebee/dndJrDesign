import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/character.dart';

class CharacterNotifier extends StateNotifier<Character> {
  CharacterNotifier()
      : super(Character(
          name: '',
          race: '',
          characterClass: '',
          background: '',
          picture: '',
          abilityScores: {},
          weapons: [],
          cantrips: [], // Updated
          spells: [], // Updated
          proficiencies: [],
          languages: [],
          traits: {},
        ));

  void updateCharacterName(String name) {
    state = state.copyWith(name: name);
  }

  void updateSelectedRace(String race) {
    state = state.copyWith(race: race);
  }

  void updateSelectedClass(String className) {
    state = state.copyWith(characterClass: className);
  }

  void updateSelectedBackground(String background) {
    state = state.copyWith(background: background);
  }

  void updateAbilityScores(Map<String, dynamic> scores) {
    state = state.copyWith(abilityScores: scores);
  }

  void updateWeapons(List<String> weapons) {
    state = state.copyWith(weapons: weapons);
  }

  void updateCantrips(List<String> cantrips) { // New method
    state = state.copyWith(cantrips: cantrips);
  }

  void updateSpells(List<String> spells) { // Updated method
    state = state.copyWith(spells: spells);
  }

  void updateProficiencies(List<String> proficiencies) {
    state = state.copyWith(proficiencies: proficiencies);
  }

  void updateLanguages(List<String> languages) {
    state = state.copyWith(languages: languages);
  }

  void updatePicture(String picture) {
    state = state.copyWith(picture: picture);
  }

  void updateTrait(String key, String value) {
    final currentTraits = state.traits;
    final newTraits = Map<String, String>.from(currentTraits);
    newTraits[key] = value;
    state = state.copyWith(traits: newTraits);
  }

  Future<void> saveCharacterToFirestore(String userId) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(userId)
          .collection('characters')
          .doc(state.name);

      await docRef.set(state.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error saving character: $e');
    }
  }
}

final characterProvider = StateNotifierProvider<CharacterNotifier, Character>((ref) {
  return CharacterNotifier();
});