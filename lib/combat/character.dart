import '../npc/npc.dart';

class Character {
  final String name;
  final int health;
  final int maxHealth;
  final int armorClass;
  List<AttackOption> attacks = [];

  Character({
    required this.name,
    required this.health,
    required this.maxHealth,
    required this.armorClass,
    required this.attacks,
  });

  Character copyWith({
    String? name,
    int? health,
    int? maxHealth,
    int? armorClass,
    List<AttackOption>? attacks,
  }) {
    return Character(
      name: name ?? this.name,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      armorClass: armorClass ?? this.armorClass,
      attacks: attacks ?? this.attacks,
    );
  }
}