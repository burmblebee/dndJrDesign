class AttackOption {
  String name;
  List<int> diceConfig;

  AttackOption({required this.name, required this.diceConfig});
}

class NPC {
  String id;
  String name;
  List<AttackOption> attacks;
  int maxHealth;
  int ac;

  NPC({required this.id, required this.name, required this.attacks, required this.maxHealth, required this.ac});

  NPC copyWith({String? id, String? name, List<AttackOption>? attacks, int? maxHealth, int? ac}) {
    return NPC(
      id: id ?? this.id,
      name: name ?? this.name,
      attacks: attacks ?? this.attacks,
      maxHealth: maxHealth ?? this.maxHealth,
      ac: ac ?? this.ac,

    );
  }
}
