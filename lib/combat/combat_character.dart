import '../npc/npc.dart';

class CombatCharacter {
  final String name;
  final int health;
  final int maxHealth;
  final int armorClass;
  List<AttackOption> attacks;
  final bool isNPC;
  final String? playerId;

  CombatCharacter({
    required this.name,
    required this.health,
    required this.maxHealth,
    required this.armorClass,
    required this.attacks,
    required this.isNPC,
    this.playerId
  });

  CombatCharacter copyWith({
    String? name,
    int? health,
    int? maxHealth,
    int? armorClass,
    List<AttackOption>? attacks,
    bool? isNPC,
    String? playerId,
  }) {
    return CombatCharacter(
      name: name ?? this.name,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      armorClass: armorClass ?? this.armorClass,
      attacks: attacks ?? this.attacks,
      isNPC: isNPC ?? this.isNPC,
      playerId: playerId ?? this.playerId,
    );
  }

  // Convert Character to a Firestore-friendly map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'health': health,
      'maxHealth': maxHealth,
      'armorClass': armorClass,
      'attacks': attacks.map((attack) => attack.toMap()).toList(),
      'isNPC': isNPC,
      'playerId': playerId,
    };
  }

  // Create a Character from Firestore data
  factory CombatCharacter.fromMap(Map<String, dynamic> data) {
    return CombatCharacter(
      name: data['name'] as String,
      health: data['health'] as int,
      maxHealth: data['maxHealth'] as int,
      armorClass: data['armorClass'] as int,
      attacks: (data['attacks'] as List<dynamic>?)
          ?.map((attackData) => AttackOption.fromMap(attackData))
          .toList() ??
          [],
      isNPC: data['isNPC'] as bool? ?? false,
      playerId: data['playerId'] as String?,
    );
  }
}