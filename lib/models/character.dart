class Character {
  final String name;
  final String race;
  final String characterClass;
  final String background;
  final String picture;
  final Map<String, dynamic> abilityScores;
  final List<String> weapons;
  final Map<String, dynamic> spells;

  final List<String> proficiencies;
  final List<String> languages;

  Character({
    required this.name,
    required this.race,
    required this.characterClass,
    required this.background,
    required this.picture,
    required this.abilityScores,
    required this.weapons,
    required this.spells,
    required this.proficiencies,
    required this.languages,
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
      spells: data['spells'] ?? {},
      proficiencies: List<String>.from(data['proficiencies'] ?? []),
      languages: List<String>.from(data['languages'] ?? []),
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
      'spells': spells,
      'languages' : languages,
      'proficiencies': proficiencies,
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
    Map<String, dynamic>? spells,
    Map<String, dynamic>? specifics,
    List<String>? proficiencies,
    List<String>? languages,
  }) {
    return Character(
      name: name ?? this.name,
      race: race ?? this.race,
      characterClass: characterClass ?? this.characterClass,
      background: background ?? this.background,
      picture: picture ?? this.picture,
      abilityScores: abilityScores ?? this.abilityScores,
      weapons: weapons ?? this.weapons,
      spells: spells ?? this.spells,
      proficiencies: proficiencies ?? this.proficiencies,
      languages: languages ?? this.languages,
    );
  }
}
