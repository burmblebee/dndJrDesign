class AttackOption {
  String name;
  List<int> diceConfig;

  AttackOption({required this.name, required this.diceConfig});
}

class NPC {
  String id;
  String name;
  List<AttackOption> attacks;

  NPC({required this.id, required this.name, required this.attacks});

  NPC copyWith({String? id, String? name, List<AttackOption>? attacks}) {
    return NPC(
      id: id ?? this.id,
      name: name ?? this.name,
      attacks: attacks ?? this.attacks,
    );
  }
}


