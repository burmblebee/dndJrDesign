import '../npc/npc.dart';

class Character {
  final String name;
  final int health;
  final int maxHealth;
  final int armorClass;
  List<AttackOption> attacks;

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

  // Convert Character to a Firestore-friendly map
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'health': health,
      'maxHealth': maxHealth,
      'armorClass': armorClass,
      'attacks': attacks.map((attack) => attack.toMap()).toList(),
    };
  }

  // Create a Character from Firestore data
  factory Character.fromMap(Map<String, dynamic> data) {
    return Character(
      name: data['name'] as String,
      health: data['health'] as int,
      maxHealth: data['maxHealth'] as int,
      armorClass: data['armorClass'] as int,
      attacks: (data['attacks'] as List<dynamic>?)
          ?.map((attackData) => AttackOption.fromMap(attackData))
          .toList() ??
          [],
    );
  }
}