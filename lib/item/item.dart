enum ItemType { Armor, Potion, Ring, Rod, Scroll, Staff, Wand, Weapon, Wondrous, Miscellaneous }

enum Rarity { Common, Uncommon, Rare, VeryRare, Legendary }

enum ResetCondition { longRest, shortRest, dawn, other, consumable }

enum ModifierType { bonus, damage, advantage, disadvantage, resistance, immunity }

enum Condition { blinded, charmed, deafened, exhaustion, frightened, grappled, incapacitated, invisible, paralyzed, petrified, poisoned, prone, restrained, stunned, unconscious }

enum DamageType { Acid, Bludgeoning, Cold, Fire, Force, Lightning, Necrotic, Piercing, Poison, Psychic, Radiant, Slashing, Thunder }

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
  final DamageType damageType1;
  final String damage1; // "1d8", "2d6", etc.
  final DamageType? damageType2;
  final String? damage2;

  CombatItem({
    required String id,
    required String name,
    required String description,
    required int price,
    required this.damageType1,
    required this.damage1,
    this.damageType2,
    this.damage2,
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
      'damageType1': damageType1.toString().split('.').last,
      'damage1': damage1,
      if (damageType2 != null) 'damageType2': damageType2.toString().split('.').last,
      if (damage2 != null) 'damage2': damage2,
    });
    return map;
  }

  factory CombatItem.fromMap(Map<String, dynamic> map, String id) {
    return CombatItem(
      id: id,
      name: map['name'],
      description: map['description'],
      price: map['price'] ?? 0,
      damageType1: DamageType.values.firstWhere(
            (e) => e.toString().split('.').last == map['damageType1'],
        orElse: () => DamageType.Bludgeoning, // Default fallback
      ),
      damage1: map['damage1'] ?? "1d6",
      damageType2: map.containsKey('damageType2')
          ? DamageType.values.firstWhere(
            (e) => e.toString().split('.').last == map['damageType2'],
        orElse: () => DamageType.Bludgeoning,
      )
          : null,
      damage2: map['damage2'],
      weight: map['weight'] ?? 0,
      requiresAttunement: map['requiresAttunement'] ?? false,
      attunementDescription: map['attunementDescription'],
    );
  }

  CombatItem copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    int? weight,
    bool? requiresAttunement,
    String? attunementDescription,
    DamageType? damageType1,
    String? damage1,
    DamageType? damageType2,
    String? damage2,
  }) {
    return CombatItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      requiresAttunement: requiresAttunement ?? this.requiresAttunement,
      attunementDescription: attunementDescription ?? this.attunementDescription,
      damageType1: damageType1 ?? this.damageType1,
      damage1: damage1 ?? this.damage1,
      damageType2: damageType2 ?? this.damageType2,
      damage2: damage2 ?? this.damage2,
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
