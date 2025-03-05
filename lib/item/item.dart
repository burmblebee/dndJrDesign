enum ItemType { Armor, Potion, Ring, Rod, Scroll, Staff, Wand, Weapon, Wondrous, Miscellaneous }

enum Rarity { Common, Uncommon, Rare, VeryRare, Legendary }

enum ResetCondition { longRest, shortRest, dawn, other, consumable }

enum ModifierType { bonus, damage, advantage, disadvantage, resistance, immunity }

enum Condition { blinded, charmed, deafened, exhaustion, frightened, grappled, incapacitated, invisible, paralyzed, petrified, poisoned, prone, restrained, stunned, unconscious }

enum DamageType { acid, bludgeoning, cold, fire, force, lightning, necrotic, piercing, poison, psychic, radiant, slashing, thunder }

class Item {
  final String id;
  final String name;
  final String description;
  final int weight;
  final int price;
  final bool requiresAttunement;
  final String? attunementDescription;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.weight,
    required this.requiresAttunement,
    this.attunementDescription,
  });

  Item copyWith({
    String? id,
    String? name,
    String? description,
    int? weight,
    bool? requiresAttunement,
    String? attunementDescription,
    int? price,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      requiresAttunement: requiresAttunement ?? this.requiresAttunement,
      attunementDescription: attunementDescription ?? this.attunementDescription,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'weight': weight,
      'requiresAttunement': requiresAttunement,
      'attunementDescription': attunementDescription,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map, String id) {
    return Item(
      id: id,
      name: map['name'],
      description: map['description'],
      price: map['price'] ?? 0,
      weight: map['weight'] ?? 0,
      requiresAttunement: map['requiresAttunement'] ?? false,
      attunementDescription: map['attunementDescription'],
    );
  }
}




class CombatItem extends Item {
  DamageType damageType;
  String damage; // "1d8", "2d6", etc.

  CombatItem({
    required String id,
    required String name,
    required String description,
    required int price,
    required this.damageType,
    required this.damage,
    required int weight,
    required bool requiresAttunement,
    String? attunementDescription,
  }) : super(
    id: id,
    name: name,
    description: description,
    price: price,
    weight: weight,
    requiresAttunement: requiresAttunement,
    attunementDescription: attunementDescription,
  );


  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map.addAll({
      'damageType': damageType.toString().split('.').last,
      'damage': damage,
    });
    return map;
  }

  factory CombatItem.fromMap(Map<String, dynamic> map, String id) {
    return CombatItem(
      id: id, // Pass id here
      name: map['name'],
      description: map['description'],
      price: map['price'] ?? 0,
      damageType: DamageType.values.firstWhere((e) => e.toString().split('.').last == map['damageType']),
      damage: map['damage'],
      weight: map['weight'] ?? 0,
      requiresAttunement: map['requiresAttunement'] ?? false,
      attunementDescription: map['attunementDescription'],
    );
  }
}

class ArmorItem extends Item {
  int armorClass;
  String armorType; // "light", "medium", "heavy"
  int strRequirement;
  bool stealthDisadvantage;

  ArmorItem({
    required String id,
    required String name,
    required String description,
    required int price,
    required this.armorClass,
    required this.armorType,
    required this.strRequirement,
    required this.stealthDisadvantage,
    required int weight,
    required bool requiresAttunement,
    String? attunementDescription,
  }) : super(
    id: id,
    name: name,
    description: description,
    price: price,
    weight: weight,
    requiresAttunement: requiresAttunement,
    attunementDescription: attunementDescription,
  );


  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map.addAll({
      'armorClass': armorClass,
      'armorType': armorType,
      'strRequirement': strRequirement,
      'stealthDisadvantage': stealthDisadvantage,
    });
    return map;
  }

  factory ArmorItem.fromMap(Map<String, dynamic> map, String id) {
    return ArmorItem(
      id: id, // Pass id here
      name: map['name'],
      description: map['description'],
      price: map['price'] ?? 0,
      armorClass: map['armorClass'],
      armorType: map['armorType'],
      strRequirement: map['strRequirement'],
      stealthDisadvantage: map['stealthDisadvantage'],
      weight: map['weight'] ?? 0, // Default to 0 if not provided
      requiresAttunement: map['requiresAttunement'] ?? false,
      attunementDescription: map['attunementDescription'],
    );
  }
}
