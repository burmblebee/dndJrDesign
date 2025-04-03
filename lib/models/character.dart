class Character {
  final String name;
  final String race;
  final String characterClass;
  final String background;
  final String picture;
  final Map<String, dynamic> abilityScores;
  final List<String> weapons;
  final List<String> cantrips;
  final List<String> spells;
  final List<String> proficiencies;
  final List<String> languages;
  final Map<String, String> traits;

  // Updated field for starting equipment
  final List<String> selectedKit; // Changed from String? to List<String>
  final String? selectedArmor;
  final List<String> selectedEquipment;
  final String? selectedInstrument;

  Character({
    required this.name,
    required this.race,
    required this.characterClass,
    required this.background,
    required this.picture,
    required this.abilityScores,
    required this.weapons,
    required this.cantrips,
    required this.spells,
    required this.proficiencies,
    required this.languages,
    required this.traits,
    this.selectedKit = const [], // Default to an empty list
    this.selectedArmor,
    this.selectedEquipment = const [],
    this.selectedInstrument,
  });

  Character copyWith({
    String? name,
    String? race,
    String? characterClass,
    String? background,
    String? picture,
    Map<String, dynamic>? abilityScores,
    List<String>? weapons,
    List<String>? cantrips,
    List<String>? spells,
    List<String>? proficiencies,
    List<String>? languages,
    Map<String, String>? traits,
    List<String>? selectedKit, // Updated to List<String>
    String? selectedArmor,
    List<String>? selectedEquipment,
    String? selectedInstrument,
  }) {
    return Character(
      name: name ?? this.name,
      race: race ?? this.race,
      characterClass: characterClass ?? this.characterClass,
      background: background ?? this.background,
      picture: picture ?? this.picture,
      abilityScores: abilityScores ?? this.abilityScores,
      weapons: weapons ?? this.weapons,
      cantrips: cantrips ?? this.cantrips,
      spells: spells ?? this.spells,
      proficiencies: proficiencies ?? this.proficiencies,
      languages: languages ?? this.languages,
      traits: traits ?? this.traits,
      selectedKit: selectedKit ?? this.selectedKit, // Updated
      selectedArmor: selectedArmor ?? this.selectedArmor,
      selectedEquipment: selectedEquipment ?? this.selectedEquipment,
      selectedInstrument: selectedInstrument ?? this.selectedInstrument,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'race': race,
      'characterClass': characterClass,
      'background': background,
      'picture': picture,
      'abilityScores': abilityScores,
      'weapons': weapons,
      'cantrips': cantrips,
      'spells': spells,
      'proficiencies': proficiencies,
      'languages': languages,
      'traits': traits,
      'selectedKit': selectedKit, // Updated
      'selectedArmor': selectedArmor,
      'selectedEquipment': selectedEquipment,
      'selectedInstrument': selectedInstrument,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      name: map['name'] ?? '',
      race: map['race'] ?? '',
      characterClass: map['characterClass'] ?? '',
      background: map['background'] ?? '',
      picture: map['picture'] ?? '',
      abilityScores: Map<String, dynamic>.from(map['abilityScores'] ?? {}),
      weapons: List<String>.from(map['weapons'] ?? []),
      cantrips: List<String>.from(map['cantrips'] ?? []),
      spells: List<String>.from(map['spells'] ?? []),
      proficiencies: List<String>.from(map['proficiencies'] ?? []),
      languages: List<String>.from(map['languages'] ?? []),
      traits: Map<String, String>.from(map['traits'] ?? {}),
      selectedKit: List<String>.from(map['selectedKit'] ?? []), // Updated
      selectedArmor: map['selectedArmor'],
      selectedEquipment: List<String>.from(map['selectedEquipment'] ?? []),
      selectedInstrument: map['selectedInstrument'],
    );
  }
}