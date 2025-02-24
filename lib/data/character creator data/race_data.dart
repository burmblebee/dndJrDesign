final Map<String, Map<String, dynamic>> RaceData = {
  'Aasimar': {
    'abilityScoreIncrease': {'Charisma': 2},
    'size': 'Medium',
    'speed': '30 ft./round',
    'vision': 'Darkvision (60 ft.)',
    'languages': ['Common', 'Celestial'],
    'traits': [
      'Healing Hands',
      'Light Bearer',
      'Celestial Resistance',
      'Radiant Soul/Radiant Consumption/Radiant Shield',
    ],
    'description':
        'Aasimar are beings with celestial ancestry, often marked by radiant beauty and a strong connection to the divine.',
  },
  'Dragonborn': {
    'abilityScoreIncrease': {'Strength': 2, 'Charisma': 1},
    'size': 'Medium',
    'speed': '30 ft./round',
    'vision': 'Normal',
    'languages': ['Common', 'Draconic'],
    'traits': [
      'Draconic Ancestry',
      'Breath Weapon',
      'Damage Resistance',
    ],
    'description':
        'Dragonborn are proud and powerful beings, with draconic ancestry that grants them breath weapons and elemental resistance.',
  },
  'Dragonborn (Gem)': {
    'abilityScoreIncrease': {'Strength': 2, 'Charisma': 1},
    'size': 'Medium',
    'speed': '30 ft./round',
    'vision': 'Darkvision (60 ft.)',
    'languages': ['Common', 'Draconic'],
    'traits': [
      'Gem Ancestry',
      'Breath Weapon',
      'Psionic Mind',
      'Damage Resistance',
    ],
    'description':
        'Gem Dragonborn are infused with the power of gem dragons, exhibiting psionic abilities and unique elemental resistances.',
  },
  'Dwarf': {
    'abilityScoreIncrease': {'Constitution': 2},
    'size': 'Medium',
    'speed': '25 ft./round',
    'vision': 'Darkvision (60 ft.)',
    'languages': ['Common', 'Dwarvish'],
    'traits': [
      'Dwarven Resilience',
      'Dwarven Combat Training',
      'Stonecunning',
    ],
    'description':
        'Dwarves are known for their hardiness, resilience, and skill in stone and metalwork, with strong traditions and a fierce loyalty.',
  },
  'Elf': {
    'abilityScoreIncrease': {'Dexterity': 2},
    'size': 'Medium',
    'speed': '30 ft./round',
    'vision': 'Darkvision (60 ft.)',
    'languages': ['Common', 'Elvish'],
    'traits': [
      'Keen Senses',
      'Fey Ancestry',
      'Trance',
    ],
    'description':
        'Elves are graceful, perceptive beings with an affinity for magic and a deep connection to the natural world.',
  },
  'Gnome': {
    'abilityScoreIncrease': {'Intelligence': 2},
    'size': 'Small',
    'speed': '25 ft./round',
    'vision': 'Darkvision (60 ft.)',
    'languages': ['Common', 'Gnomish'],
    'traits': [
      'Gnome Cunning',
      'Artificer\'s Lore',
      'Tinker (if Rock Gnome)',
    ],
    'description':
        'Gnomes are curious and inventive, with a keen intellect and a natural talent for illusion and tinkering.',
  },
  'Goliath': {
    'abilityScoreIncrease': {'Strength': 2, 'Constitution': 1},
    'size': 'Medium',
    'speed': '30 ft./round',
    'vision': 'Normal',
    'languages': ['Common', 'Giant'],
    'traits': [
      'Natural Athlete',
      'Stone\'s Endurance',
      'Powerful Build',
    ],
    'description':
        'Goliaths are towering, resilient, and fiercely competitive, adapted to high-altitude environments and known for their physical prowess.',
  },
  'Halfling': {
    'abilityScoreIncrease': {'Dexterity': 2},
    'size': 'Small',
    'speed': '25 ft./round',
    'vision': 'Normal',
    'languages': ['Common', 'Halfling'],
    'traits': [
      'Lucky',
      'Brave',
      'Halfling Nimbleness',
    ],
    'description':
        'Halflings are cheerful, resourceful, and good-natured folk, known for their luck and resilience.',
  },
  'Human': {
    'abilityScoreIncrease': {
      'Strength': 1,
      'Dexterity': 1,
      'Constitution': 1,
      'Wisdom': 1,
      'Intelligence': 1,
      'Charisma': 1,
    },
    'size': 'Medium',
    'speed': '30 ft./round',
    'vision': 'Normal',
    'languages': ['Common', 'One additional language of choice'],
    'traits': [
      'Versatile Ability Scores',
      'Adaptable Nature',
    ],
    'description':
        'Humans are incredibly diverse, adaptable, and ambitious, thriving in nearly any environment and culture.',
  },
  'Orc': {
    'abilityScoreIncrease': {'Strength': 2, 'Constitution': 1},
    'size': 'Medium',
    'speed': '30 ft./round',
    'vision': 'Darkvision (60 ft.)',
    'languages': ['Common', 'Orc'],
    'traits': [
      'Aggressive',
      'Powerful Build',
      'Primal Intuition',
    ],
    'description':
        'Orcs are strong and resilient, with a fierce will to survive and a proud cultural heritage that values strength.',
  },
  'Tiefling': {
    'abilityScoreIncrease': {'Charisma': 2, 'Intelligence': 1},
    'size': 'Medium',
    'speed': '30 ft./round',
    'vision': 'Darkvision (60 ft.)',
    'languages': ['Common', 'Infernal'],
    'traits': [
      'Hellish Resistance',
      'Infernal Legacy',
    ],
    'description':
        'Tieflings bear fiendish heritage, often marked by horns or tails, with an innate resistance to fire and a knack for dark magic.',
  },
};
