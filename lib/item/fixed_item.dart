enum ItemType {
  Armor,
  Potion,
  Ring,
  Rod,
  Scroll,
  Staff,
  Wand,
  Weapon,
  Wondrous,
  Miscellaneous
}

enum WeaponType {
  melee,
  ranged,
  ammunition,
  thrown,
  finesse,
  heavy,
  light,
  loading,
  reach,
  special,
}

enum WeaponCategory { Simple, Martial }

enum Rarity { Common, Uncommon, Rare, VeryRare, Legendary }

enum ResetCondition { longRest, shortRest, dawn, other, consumable }

enum Currency { cp, sp, ep, gp, pp }

// enum ModifierType {
//   bonus,
//   damage,
//   advantage,
//   disadvantage,
//   resistance,
//   immunity
// }
//
// enum Condition {
//   blinded,
//   charmed,
//   deafened,
//   exhaustion,
//   frightened,
//   grappled,
//   incapacitated,
//   invisible,
//   paralyzed,
//   petrified,
//   poisoned,
//   prone,
//   restrained,
//   stunned,
//   unconscious
// }

enum DamageType {
  Acid,
  Bludgeoning,
  Cold,
  Fire,
  Force,
  Lightning,
  Necrotic,
  Piercing,
  Poison,
  Psychic,
  Radiant,
  Slashing,
  Thunder
}

class Item {
  final String id; // Firestore document ID
  final String name;
  final String description;
  final int price;
  final int weight;
  final bool requiresAttunement;
  final String? attunementDescription;
  final ItemType itemType;
  final Currency currency;

  Item({
    required this.itemType,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.weight,
    required this.requiresAttunement,
    this.attunementDescription,
    this.currency = Currency.gp,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemType': itemType.name,
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'weight': weight,
      'requiresAttunement': requiresAttunement,
      'attunementDescription': attunementDescription,
      'type': 'Miscellaneous',
      'currency': currency.name,
    };
  }

  factory Item.fromMap(String id, Map<String, dynamic> map) {
    return Item(
      itemType: ItemType.values.firstWhere((e) => e.name == map['itemType'],
          orElse: () => ItemType.Miscellaneous),
      id: id, // Firestore document ID
      name: map['name'] ?? 'Unknown',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
      weight: map['weight'] ?? 0,
      requiresAttunement: map['requiresAttunement'] ?? false,
      attunementDescription: map['attunementDescription'] ?? '',
      currency: Currency.values.firstWhere((e) => e.name == map['currency'],
          orElse: () => Currency.gp),
    );
  }

  Item copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    int? weight,
    bool? requiresAttunement,
    String? attunementDescription,
    Currency? currency,
  }) {
    return Item(
      itemType: itemType,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      requiresAttunement: requiresAttunement ?? this.requiresAttunement,
      attunementDescription:
          attunementDescription ?? this.attunementDescription,
      currency: currency ?? this.currency,
    );
  }
}

class CombatItem extends Item {
  final DamageType damageType1;
  final String damage1;
  final DamageType? damageType2;
  final String? damage2;
  final WeaponCategory weaponCategory;
  CombatItem({
    required String id,
    required String name,
    required String description,
    required int price,
    required int weight,
    required bool requiresAttunement,
    String? attunementDescription,
    required this.damageType1,
    required this.damage1,
    this.damageType2,
    this.damage2,
    required this.weaponCategory,
    required Currency currency,
  }) : super(
            itemType: ItemType.Weapon,
            id: id,
            name: name,
            description: description,
            price: price,
            weight: weight,
            requiresAttunement: requiresAttunement,
            attunementDescription: attunementDescription,
            currency: currency);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'type': 'Weapon',
      'damageType1': damageType1.name,
      'damage1': damage1,
      'damageType2': damageType2?.name,
      'damage2': damage2,
      'weaponCategory': weaponCategory.name,
    });
    return baseMap;
  }

  factory CombatItem.fromMap(String id, Map<String, dynamic> map) {
    return CombatItem(
      id: id,
      name: map['name'] ?? 'Unknown',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
      weight: map['weight'] ?? 0,
      requiresAttunement: map['requiresAttunement'] ?? false,
      attunementDescription: map['attunementDescription'],
      damageType1: DamageType.values.firstWhere(
          (e) => e.name == map['damageType1'],
          orElse: () => DamageType.Bludgeoning),
      damage1: map['damage1'] ?? '',
      damageType2: map['damageType2'] != null
          ? DamageType.values.firstWhere((e) => e.name == map['damageType2'],
              orElse: () => DamageType.Bludgeoning)
          : null,
      damage2: map['damage2'],
      weaponCategory: WeaponCategory.values.firstWhere(
          (e) => e.name == map['weaponCategory'],
          orElse: () => WeaponCategory.Simple),
      currency: Currency.values.firstWhere((e) => e.name == map['currency'],
          orElse: () => Currency.gp),
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
    WeaponCategory? weaponCategory,
    Currency? currency,
  }) {
    return CombatItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      requiresAttunement: requiresAttunement ?? this.requiresAttunement,
      attunementDescription:
          attunementDescription ?? this.attunementDescription,
      damageType1: damageType1 ?? this.damageType1,
      damage1: damage1 ?? this.damage1,
      damageType2: damageType2 ?? this.damageType2,
      damage2: damage2 ?? this.damage2,
      weaponCategory: weaponCategory ?? this.weaponCategory,
      currency: currency ?? this.currency,
    );
  }
}

class ArmorItem extends Item {
  int armorClass;
  String armorType; // "light", "medium", "heavy"
  int strRequirement;
  bool stealthDisadvantage;

  ArmorItem({
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
          id: 'armor_${name.toLowerCase().replaceAll(' ', '_')}', // Unique ID based on name
          itemType: ItemType.Armor,
          name: name,
          description: description,
          price: price,
          weight: weight,
          requiresAttunement: requiresAttunement,
          attunementDescription:
              (requiresAttunement) ? attunementDescription : null,
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

  factory ArmorItem.fromMap(Map<String, dynamic> map) {
    return ArmorItem(
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
