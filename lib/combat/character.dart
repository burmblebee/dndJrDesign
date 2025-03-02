class Character {
  final String name;
  final int health;
  final int maxHealth;
  final int armorClass;

  Character({
    required this.name,
    required this.health,
    required this.maxHealth,
    required this.armorClass,
  });

  Character copyWith({
    String? name,
    int? health,
    int? maxHealth,
    int? armorClass,
  }) {
    return Character(
      name: name ?? this.name,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      armorClass: armorClass ?? this.armorClass,
    );
  }
}