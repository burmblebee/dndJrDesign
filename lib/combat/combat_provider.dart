import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warlocks_of_the_beach/data/character%20creator%20data/weapon_data.dart';
import '../combat/combat_character.dart';
import '../npc/npc.dart';
import 'firestore_service.dart';
import 'package:warlocks_of_the_beach/screens/character_sheet/character_sheet.dart';

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
    await _firestoreService.initializeCombat(campaignId, state.characters);
  }


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String campaignId;

  final Map<String, String> simpleWeaponDamage = {
    'Club': '1d4',
    'Dagger': '1d4',
    'Greatclub': '2d4',
    'Handaxe': '1d6',
    'Javelin': '1d6',
    'Light Hammer': '1d4',
    'Mace': '1d6',
    'Quarterstaff': '1d6',
    'Sickle': '1d4',
    'Spear': '1d6',
    'Light Crossbow': '1d8',
    'Dart': '1d4',
    'Shortbow': '1d6',
    'Sling': '1d4',
    'Blowgun': '1',
  };

  final Map<String, String> martialWeaponDamage = {
    'Battleaxe': '1d8',
    'Flail': '1d8',
    'Glaive': '1d10',
    'Greataxe': '1d12',
    'Greatsword': '2d6',
    'Halberd': '1d10',
    'Lance': '1d12',
    'Longsword': '1d8',
    'Maul': '2d6',
    'Morningstar': '1d8',
    'Pike': '1d10',
    'Rapier': '1d8',
    'Scimitar': '1d6',
    'Shortsword': '1d6',
    'Trident': '1d6',
    'War Pick': '1d8',
    'Warhammer': '1d8',
    'Whip': '1d4',
    'Hand Crossbow': '1d6',
    'Heavy Crossbow': '1d10',
    'Longbow': '1d8',
    'Net': '0',
  };

  List<int> parseDiceString(String diceString) {
    List<int> diceToRoll = List.filled(7, 0); // d4, d6, d8, d10, d12, d20, d100
    final diceParts = diceString.split(RegExp(r'\s*\+\s*'));

    for (String part in diceParts) {
      final match = RegExp(r'(\d*)d(\d+)').firstMatch(part.trim());
      if (match != null) {
        int count = match.group(1)!.isEmpty ? 1 : int.parse(match.group(1)!);
        int sides = int.parse(match.group(2)!);

        int index = switch (sides) {
          4 => 0,
          6 => 1,
          8 => 2,
          10 => 3,
          12 => 4,
          20 => 5,
          100 => 6,
          _ => -1
        };

        if (index != -1) {
          diceToRoll[index] += count;
        } else {
          print("Unsupported die: d$sides");
        }
      }
    }

    return diceToRoll;
  }


  // Load combat data from Firestore and listen for real-time updates
  void _loadCombatData() {
    _firestore.collection('user_campaigns').doc(campaignId).snapshots().listen((snapshot) async {
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final List<dynamic> npcData = data['characters'] ?? [];
      final List<dynamic> players = data['players'] ?? [];

      // Parse existing NPCs
      List<CombatCharacter> fetchedNPCs = npcData
          .map((char) => CombatCharacter.fromMap(char))
          .where((c) => c.isNPC)
          .toList();

      // Fetch player characters and attach playerId
      List<CombatCharacter> playerCharacters = [];

      for (var playerEntry in players) {
        final characterId = playerEntry['character'];
        final playerId = playerEntry['player'];

        final charDoc = await _firestore
            .collection('app_user_profiles')
            .doc(playerId) // assuming playerId is also their profile doc ID
            .collection('characters')
            .doc(characterId)
            .get();
        if (charDoc.exists) {
          final charData = charDoc.data()!;

          //try parsing health and max health from string
          final health = int.tryParse(charData['hp'].toString()) ?? 0;
          final weapons = charData['weapons'];
          List<AttackOption> attacks = [];

          //pull weapon damage from weapon_data.dart
          for(String weapon in weapons){
            final attackData = simpleWeaponDamage[weapon] ??
                martialWeaponDamage[weapon] ??
                'Unknown';
            final diceConfig = parseDiceString(attackData);
            final attack = AttackOption(
              name: weapon,
              diceConfig: diceConfig,
            );

            attacks.add(attack);
          }
          final character = CombatCharacter
            (
              name: charData['name'],
              health: health,
              maxHealth: health,
              armorClass: charData['ac'],
              attacks: attacks,
              isNPC: false,
          playerId: playerId);

          playerCharacters.add(character);
          debugPrint('Player character fetched: ${character.name}');
        }
      }

      // Combine and upload to Firestore
      final allCharacters = [...fetchedNPCs, ...playerCharacters];

      // Write merged characters into Firestore
      await _firestore.collection('user_campaigns').doc(campaignId).update({
        'characters': allCharacters.map((c) => c.toFirestore()).toList(),
      });

      // Update local state
      state = state.copyWith(
        characters: allCharacters,
        currentTurnIndex: data['currentTurnIndex'] ?? 0,
      );
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
