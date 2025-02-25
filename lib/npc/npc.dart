class AttackOption {
  String name;
  List<int> diceConfig;

  AttackOption({required this.name, required this.diceConfig});
}

class NPC {
  String name;
  List<AttackOption> attacks;

  NPC({required this.name, required this.attacks});
}
