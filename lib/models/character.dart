class Character {
  final String name;
  final String race;
  final String characterClass;
  final String background;
  final String picture;
  final Map<String, dynamic> abilityScores;
  final List<String> weapons;
  final List<String> cantrips; // New field for cantrips
  final List<String> spells; // New field for spells
  final List<String> proficiencies;
  final List<String> languages;
  final Map<String, String> traits;

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
  });

  factory Character.fromMap(Map<String, dynamic> data) {
    return Character(
      name: data['name'] ?? '',
      race: data['race'] ?? '',
      characterClass: data['characterClass'] ?? '',
      background: data['background'] ?? '',
      picture: data['picture'] ?? '',
      abilityScores: data['abilityScores'] ?? {},
      weapons: List<String>.from(data['weapons'] ?? []),
      cantrips: List<String>.from(data['cantrips'] ?? []), // Updated
      spells: List<String>.from(data['spells'] ?? []), // Updated
      proficiencies: List<String>.from(data['proficiencies'] ?? []),
      languages: List<String>.from(data['languages'] ?? []),
      traits: Map<String, String>.from(data['traits'] ?? {}),
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
      'cantrips': cantrips, // Updated
      'spells': spells, // Updated
      'proficiencies': proficiencies,
      'languages': languages,
      'traits': traits,
    };
  }

  Character copyWith({
    String? name,
    String? race,
    String? characterClass,
    String? background,
    String? picture,
    Map<String, dynamic>? abilityScores,
    List<String>? weapons,
    List<String>? cantrips, // Updated
    List<String>? spells, // Updated
    List<String>? proficiencies,
    List<String>? languages,
    Map<String, String>? traits,
  }) {
    return Character(
      name: name ?? this.name,
      race: race ?? this.race,
      characterClass: characterClass ?? this.characterClass,
      background: background ?? this.background,
      picture: picture ?? this.picture,
      abilityScores: abilityScores ?? this.abilityScores,
      weapons: weapons ?? this.weapons,
      cantrips: cantrips ?? this.cantrips, // Updated
      spells: spells ?? this.spells, // Updated
      proficiencies: proficiencies ?? this.proficiencies,
      languages: languages ?? this.languages,
      traits: traits ?? this.traits,
    );
  }
}