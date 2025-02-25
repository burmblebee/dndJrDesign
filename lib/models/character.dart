class Character {
  final String name;
  final String race;
  final String characterClass;
  final String background;
  final String picture;
  final Map<String, dynamic> abilityScores;
  final Map<String, dynamic> weapons;
  final Map<String, dynamic> spells;
  final Map<String, dynamic> specifics;

  Character({
    required this.name,
    required this.race,
    required this.characterClass,
    required this.background,
    required this.picture,
    required this.abilityScores,
    required this.weapons,
    required this.spells,
    required this.specifics,
  });

  factory Character.fromMap(Map<String, dynamic> data) {
    return Character(
      name: data['name'] ?? '',
      race: data['race'] ?? '',
      characterClass: data['characterClass'] ?? '',
      background: data['background'] ?? '',
      picture: data['picture'] ?? '',
      abilityScores: data['abilityScores'] ?? {},
      weapons: data['weapons'] ?? {},
      spells: data['spells'] ?? {},
      specifics: data['specifics'] ?? {},
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
      'specifics': specifics,
    };
  }

  Character copyWith({
    String? name,
    String? race,
    String? characterClass,
    String? background,
    String? picture,
    Map<String, dynamic>? abilityScores,
    Map<String, dynamic>? weapons,
    Map<String, dynamic>? spells,
    Map<String, dynamic>? specifics,
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
      specifics: specifics ?? this.specifics,
    );
  }
}