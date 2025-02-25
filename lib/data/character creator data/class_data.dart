// dnd_character_data.dart

final Map<String, Map<String, dynamic>> ClassData = {
  'Barbarian': {
    'hitDie': '1d12',
    'armors': ['Light armor', 'Medium armor', 'Shields'],
    'weapons': ['Simple weapons', 'Martial weapons'],
    'tools': [],
    'savingThrows': ['Strength', 'Constitution'],
    'skills': [
      '2 from Athletics',
      'Animal Handling',
      'Intimidation',
      'Nature',
      'Perception',
      'Survival',
    ],
    'description':
        'Barbarians are fierce warriors, known for their combat prowess and unbreakable resilience.',
  },
  'Bard': {
    'hitDie': '1d8',
    'armors': ['Light armor'],
    'weapons': ['Simple weapons', 'Hand crossbows', 'Longswords', 'Rapier'],
    'tools': ['Musical instrument'],
    'savingThrows': ['Dexterity', 'Charisma'],
    'skills': [
      'Choose any 3 skills',
    ],
    'description':
        'Bards are versatile spellcasters and performers, inspiring allies with music and magic.',
  },
  'Cleric': {
    'hitDie': '1d8',
    'armors': ['Light armor', 'Medium armor', 'Shields'],
    'weapons': ['Simple weapons'],
    'tools': [],
    'savingThrows': ['Wisdom', 'Charisma'],
    'skills': [
      'Choose 2 from History, Insight, Medicine, Persuasion, Religion',
    ],
    'description':
        'Clerics are devoted servants of the divine, capable of wielding magic granted by their deity.',
  },
  'Druid': {
    'hitDie': '1d8',
    'armors': ['Light armor', 'Medium armor', 'Shields'],
    'weapons': ['Club', 'Dagger', 'Dart', 'Quarterstaff', 'Spear'],
    'tools': ['Herbalism kit'],
    'savingThrows': ['Intelligence', 'Wisdom'],
    'skills': [
      'Choose 2 from Arcana, Animal Handling, Insight, Medicine, Nature, Perception, Religion',
    ],
    'description':
        'Druids are protectors of nature, able to transform into animals and wield nature-based magic.',
  },
  'Fighter': {
    'hitDie': '1d10',
    'armors': ['All armor', 'Shields'],
    'weapons': ['Simple weapons', 'Martial weapons'],
    'tools': [],
    'savingThrows': ['Strength', 'Constitution'],
    'skills': [
      'Choose 2 from Acrobatics, Animal Handling, Athletics, History, Insight, Intimidation, and Perception',
    ],
    'description':
        'Fighters are well-rounded combatants, excelling in physical confrontation with specialized skills.',
  },
  'Monk': {
    'hitDie': '1d8',
    'armors': ['Light armor'],
    'weapons': ['Simple weapons', 'Shortswords'],
    'tools': [],
    'savingThrows': ['Strength', 'Dexterity'],
    'skills': [
      'Choose 2 from Acrobatics, Athletics, History, Insight, Religion, Stealth',
    ],
    'description':
        'Monks harness both physical and spiritual discipline to achieve remarkable feats of agility and power.',
  },
  'Paladin': {
    'hitDie': '1d10',
    'armors': ['All armor', 'Shields'],
    'weapons': ['Simple weapons', 'Martial weapons'],
    'tools': [],
    'savingThrows': ['Strength', 'Charisma'],
    'skills': [
      'Choose 2 from Athletics, History, Insight, Intimidation, Medicine, Persuasion, Religion',
    ],
    'description':
        'Paladins are holy warriors, combining martial prowess with divine magic to fight against evil.',
  },
  'Ranger': {
    'hitDie': '1d10',
    'armors': ['Light armor', 'Medium armor'],
    'weapons': ['Simple weapons', 'Martial weapons'],
    'tools': [],
    'savingThrows': ['Strength', 'Dexterity'],
    'skills': [
      'Choose 3 from Animal Handling, Athletics, History, Insight, Investigation, Nature, Perception, Stealth, Survival',
    ],
    'description':
        'Rangers are skilled hunters and trackers, able to navigate the wilderness and protect allies.',
  },
  'Rogue': {
    'hitDie': '1d8',
    'armors': ['Light armor'],
    'weapons': [
      'Simple weapons',
      'Hand crossbows',
      'Longswords',
      'Rapier',
      'Shortswords'
    ],
    'tools': ['Thieves\' tools'],
    'savingThrows': ['Dexterity', 'Intelligence'],
    'skills': [
      'Choose 4 from Acrobatics, Athletics, Deception, Insight, Intimidation, Investigation, Perception, Performance, Persuasion, Sleight of Hand, Stealth',
    ],
    'description':
        'Rogues are cunning and dexterous, using stealth and agility to gain an edge in battle.',
  },
  'Sorcerer': {
    'hitDie': '1d6',
    'armors': ['Light armor'],
    'weapons': ['Simple weapons'],
    'tools': [],
    'savingThrows': ['Constitution', 'Charisma'],
    'skills': [
      'Choose 2 from Arcana, Deception, Insight, Intimidation, Persuasion, Religion',
    ],
    'description':
        'Sorcerers draw on inherent magical abilities, wielding arcane power with unmatched flexibility.',
  },
  'Wizard': {
    'hitDie': '1d6',
    'armors': ['Light armor'],
    'weapons': [
      'Daggers',
      'Darts',
      'Slings',
      'Quarterstaffs',
      'Light crossbows'
    ],
    'tools': ['The personal spellbook'],
    'savingThrows': ['Intelligence', 'Wisdom'],
    'skills': [
      'Choose 2 from Arcana, History, Insight, Investigation, Medicine, Religion',
    ],
    'description':
        'Wizards are learned spellcasters, using extensive knowledge and study to manipulate the arcane.',
  },
  'Warlock': {
    'hitDie': '1d8',
    'armors': ['Light armor'],
    'weapons': ['Simple weapons'],
    'tools': [],
    'savingThrows': ['Wisdom', 'Charisma'],
    'skills': [
      'Choose 2 from Arcana, Deception, History, Intimidation, Investigation, Nature, Religion',
    ],
    'description':
        'Warlocks form pacts with powerful beings, gaining magical abilities and unique spells from their patrons.',
  },
};
