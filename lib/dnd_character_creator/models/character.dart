class Character {
  final String name;
  final String race;
  final String characterClass;
  final String background; // Added background
  final String picture; // This is the image URL
  final Map<String, dynamic> abilityScores; // Define abilityScores as a Map

  Character({
    required this.name,
    required this.race,
    required this.characterClass,
    required this.background, // Include background in the constructor
    required this.picture,
    required this.abilityScores,
  });

  // Factory method to create a Character from Firestore document data
  factory Character.fromMap(Map<String, dynamic> data) {
    return Character(
      name: data['name'] ?? 'Unknown', // Default value if the field is null
      race: data['race'] ?? 'Unknown',
      characterClass: data['class'] ?? 'Unknown',
      background: data['background'] ?? 'Unknown',
      abilityScores: data['abilityScores'] ?? {}, // Handle missing abilityScores
      picture: data['imageUrl'] ?? '', // Default to empty string if no picture
    );
  }

  // Method to convert the Character instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'race': race,
      'class': characterClass,
      'background': background, // Include background in serialization
      'picture': picture, // This is the image URL
      'abilityScores': abilityScores, // Handle abilityScores
    };
  }

  // Optional: Getters for convenience if required
  String get displayClass => characterClass;
  String get displayRace => race;
  String get displayBackground => background;
  String get displayAbilityScores => abilityScores.toString(); // Or customize display
  String get displayPicture => picture;
}




// class Character {
//   final String name;
//   final String race;
//   final String characterClass;
//   final String background; // Added background
//   final String picture;
//   final abilityScores;

//   Character({
//     required this.name,
//     required this.race,
//     required this.characterClass,
//     required this.background, // Include background in the constructor
//     required this.picture,
//     required this.abilityScores,
//   });

//   // Factory method to create a Character from Firestore document data
//   factory Character.fromMap(Map<String, dynamic> data) {
//     return Character(
//       name: data['name'] ?? 'Unknown', // Default value if the field is null
//       race: data['race'] ?? 'Unknown',
//       characterClass: data['class'] ?? 'Unknown',
//       background: data['background'] ?? 'Unknown',
//       abilityScores: data['abilityScores'] ?? {}, // Handle missing background
//       picture: data['picture'] ?? '', // Default to empty string if no picture
//     );
//   }

//   // Method to convert the Character instance to a Map for Firestore
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'race': race,
//       'class': characterClass,
//       'background': background, // Include background in serialization
//       'picture': picture,
      
//     };
//   }

//   // Optional: Getters for convenience if required
//   String get displayClass => characterClass;
//   String get displayRace => race;
//   String get displayBackground => background;
//   String get displayAbilityScores => abilityScores;
// }
