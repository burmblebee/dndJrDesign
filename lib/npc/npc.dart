class AttackOption {
  String name;
  List<int> diceConfig;

  AttackOption({required this.name, required this.diceConfig});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'diceConfig': diceConfig,
    };
  }

  factory AttackOption.fromMap(Map<String, dynamic> data) {
    return AttackOption(
      name: data['name'] as String,
      diceConfig: List<int>.from(data['diceConfig']),
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'attacks': attacks.map((attack) => attack.toMap()).toList(),
      'maxHealth': maxHealth,
      'ac': ac,
    };
  }

  factory NPC.fromMap(Map<String, dynamic> data) {
    return NPC(
      id: data['id'] as String,
      name: data['name'] as String,
      attacks: (data['attacks'] as List<dynamic>).map((attack) {
        return AttackOption.fromMap(attack);
      }).toList(),
      maxHealth: data['maxHealth'] as int,
      ac: data['ac'] as int,
    );
  }
}
