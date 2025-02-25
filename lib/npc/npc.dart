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
}

