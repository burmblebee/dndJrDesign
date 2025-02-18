class WeaponData {
  static const Map<String, Map<String, Map<String, dynamic>>> Weapons = {
    "SimpleWeapons": {
      "None" : {
        "damage_die": "—",
        "gold_cost": "—",
        "damage_type": "—",
        "properties": ["—"],
        "weight": "—"
      },
      "Club": {
        "damage_die": "1d4",
        "gold_cost": "0.1 gp",
        "damage_type": "bludgeoning",
        "properties": ["light"],
        "weight": "2 lbs"
      },
      "Dagger": {
        "damage_die": "1d4",
        "gold_cost": "2 gp",
        "damage_type": "piercing",
        "properties": ["finesse", "light", "thrown (20/60)"],
        "weight": "1 lb"
      },
      "Greatclub": {
        "damage_die": "1d8",
        "gold_cost": "0.2 gp",
        "damage_type": "bludgeoning",
        "properties": ["two-handed"],
        "weight": "10 lbs"
      },
      "Handaxe": {
        "damage_die": "1d6",
        "gold_cost": "5 gp",
        "damage_type": "slashing",
        "properties": ["light", "thrown (20/60)"],
        "weight": "2 lbs"
      },
      "Javelin": {
        "damage_die": "1d6",
        "gold_cost": "0.5 gp",
        "damage_type": "piercing",
        "properties": ["thrown (30/120)"],
        "weight": "2 lbs"
      },
      "Light Hammer": {
        "damage_die": "1d4",
        "gold_cost": "2 gp",
        "damage_type": "bludgeoning",
        "properties": ["light", "thrown (20/60)"],
        "weight": "2 lbs"
      },
      "Mace": {
        "damage_die": "1d6",
        "gold_cost": "5 gp",
        "damage_type": "bludgeoning",
        "properties": [],
        "weight": "4 lbs"
      },
      "Quarterstaff": {
        "damage_die": "1d6",
        "gold_cost": "0.2 gp",
        "damage_type": "bludgeoning",
        "properties": ["versatile (1d8)"],
        "weight": "4 lbs"
      },
      "Sickle": {
        "damage_die": "1d4",
        "gold_cost": "1 gp",
        "damage_type": "slashing",
        "properties": ["light"],
        "weight": "2 lbs"
      },
      "Spear": {
        "damage_die": "1d6",
        "gold_cost": "1 gp",
        "damage_type": "piercing",
        "properties": ["thrown (20/60)", "versatile (1d8)"],
        "weight": "3 lbs"
      },
      "Light Crossbow": {
        "damage_die": "1d8",
        "gold_cost": "25 gp",
        "damage_type": "piercing",
        "properties": ["ammunition (80/320)", "loading", "two-handed"],
        "weight": "5 lbs"
      },
      "Dart": {
        "damage_die": "1d4",
        "gold_cost": "0.05 gp",
        "damage_type": "piercing",
        "properties": ["finesse", "thrown (20/60)"],
        "weight": "0.25 lbs"
      },
      "Shortbow": {
        "damage_die": "1d6",
        "gold_cost": "25 gp",
        "damage_type": "piercing",
        "properties": ["ammunition (80/320)", "two-handed"],
        "weight": "2 lbs"
      },
      "Sling": {
        "damage_die": "1d4",
        "gold_cost": "0.1 gp",
        "damage_type": "bludgeoning",
        "properties": ["ammunition (30/120)"],
        "weight": "0 lbs"
      },
      "Blowgun": {
        "damage_die": "1",
        "gold_cost": "10 gp",
        "damage_type": "piercing",
        "properties": ["ammunition (25/100)", "loading"],
        "weight": "1 lb"
      }
    },
    "MartialWeapons": {
      "None" : {
        "damage_die": "—",
        "gold_cost": "—",
        "damage_type": "—",
        "properties": ["—"],
        "weight": "—"
      },
      "Battleaxe": {
        "damage_die": "1d8",
        "gold_cost": "10 gp",
        "damage_type": "slashing",
        "properties": ["versatile (1d10)"],
        "weight": "4 lbs"
      },
      "Flail": {
        "damage_die": "1d8",
        "gold_cost": "10 gp",
        "damage_type": "bludgeoning",
        "properties": [],
        "weight": "2 lbs"
      },
      "Glaive": {
        "damage_die": "1d10",
        "gold_cost": "20 gp",
        "damage_type": "slashing",
        "properties": ["heavy", "reach", "two-handed"],
        "weight": "6 lbs"
      },
      "Greataxe": {
        "damage_die": "1d12",
        "gold_cost": "30 gp",
        "damage_type": "slashing",
        "properties": ["heavy", "two-handed"],
        "weight": "7 lbs"
      },
      "Greatsword": {
        "damage_die": "2d6",
        "gold_cost": "50 gp",
        "damage_type": "slashing",
        "properties": ["heavy", "two-handed"],
        "weight": "6 lbs"
      },
      "Halberd": {
        "damage_die": "1d10",
        "gold_cost": "20 gp",
        "damage_type": "slashing",
        "properties": ["heavy", "reach", "two-handed"],
        "weight": "6 lbs"
      },
      "Lance": {
        "damage_die": "1d12",
        "gold_cost": "10 gp",
        "damage_type": "piercing",
        "properties": ["reach", "special"],
        "weight": "6 lbs"
      },
      "Longsword": {
        "damage_die": "1d8",
        "gold_cost": "15 gp",
        "damage_type": "slashing",
        "properties": ["versatile (1d10)"],
        "weight": "3 lbs"
      },
      "Maul": {
        "damage_die": "2d6",
        "gold_cost": "10 gp",
        "damage_type": "bludgeoning",
        "properties": ["heavy", "two-handed"],
        "weight": "10 lbs"
      },
      "Morningstar": {
        "damage_die": "1d8",
        "gold_cost": "15 gp",
        "damage_type": "piercing",
        "properties": [],
        "weight": "4 lbs"
      },
      "Pike": {
        "damage_die": "1d10",
        "gold_cost": "5 gp",
        "damage_type": "piercing",
        "properties": ["heavy", "reach", "two-handed"],
        "weight": "18 lbs"
      },
      "Rapier": {
        "damage_die": "1d8",
        "gold_cost": "25 gp",
        "damage_type": "piercing",
        "properties": ["finesse"],
        "weight": "2 lbs"
      },
      "Scimitar": {
        "damage_die": "1d6",
        "gold_cost": "25 gp",
        "damage_type": "slashing",
        "properties": ["finesse", "light"],
        "weight": "3 lbs"
      },
      "Shortsword": {
        "damage_die": "1d6",
        "gold_cost": "10 gp",
        "damage_type": "piercing",
        "properties": ["finesse", "light"],
        "weight": "2 lbs"
      },
      "Trident": {
        "damage_die": "1d6",
        "gold_cost": "5 gp",
        "damage_type": "piercing",
        "properties": ["thrown (20/60)", "versatile (1d8)"],
        "weight": "4 lbs"
      },
      "War Pick": {
        "damage_die": "1d8",
        "gold_cost": "5 gp",
        "damage_type": "piercing",
        "properties": [],
        "weight": "2 lbs"
      },
      "Warhammer": {
        "damage_die": "1d8",
        "gold_cost": "15 gp",
        "damage_type": "bludgeoning",
        "properties": ["versatile (1d10)"],
        "weight": "2 lbs"
      },
      "Whip": {
        "damage_die": "1d4",
        "gold_cost": "2 gp",
        "damage_type": "slashing",
        "properties": ["finesse", "reach"],
        "weight": "3 lbs"
      },
      "Hand Crossbow": {
        "damage_die": "1d6",
        "gold_cost": "75 gp",
        "damage_type": "piercing",
        "properties": ["ammunition (30/120)", "light", "loading"],
        "weight": "3 lbs"
      },
      "Heavy Crossbow": {
        "damage_die": "1d10",
        "gold_cost": "50 gp",
        "damage_type": "piercing",
        "properties": [
          "ammunition (100/400)",
          "heavy",
          "loading",
          "two-handed"
        ],
        "weight": "18 lbs"
      },
      "Longbow": {
        "damage_die": "1d8",
        "gold_cost": "50 gp",
        "damage_type": "piercing",
        "properties": ["ammunition (150/600)", "heavy", "two-handed"],
        "weight": "2 lbs"
      },
      "Net": {
        "damage_die": "—",
        "gold_cost": "1 gp",
        "damage_type": "—",
        "properties": ["special", "thrown (5/15)"],
        "weight": "3 lbs"
      }
    }
  };
}
