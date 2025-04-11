import '../npc/npc.dart';

class PlayerCharacter {
  final String name;
  final int health;
  final int maxHealth;
  final int armorClass;
  List<AttackOption> attacks = [];

  PlayerCharacter({
    required this.name,
    required this.health,
    required this.maxHealth,
    required this.armorClass,
    required this.attacks,
  });

  PlayerCharacter copyWith({
    String? name,
    int? health,
    int? maxHealth,
    int? armorClass,
    List<AttackOption>? attacks,
  }) {
    return PlayerCharacter(
      name: name ?? this.name,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      armorClass: armorClass ?? this.armorClass,
      attacks: attacks ?? this.attacks,
    );
  }
}