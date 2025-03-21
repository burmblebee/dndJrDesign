import 'package:flutter/material.dart';

enum ItemType {
  Armor,
  Weapon,
  Wondrous,
//  Miscellaneous
}

// enum ItemType {
//   Armor,
//   Potion,
//   Ring,
//   Rod,
//   Scroll,
//   Staff,
//   Wand,
//   Weapon,
//   Wondrous,
//   Miscellaneous
// }

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

enum ArmorType {
  Light,
  Medium,
  Heavy,
  Shield,
}

class Item {
  final String id;
  final String name;
  final String description;
  final int price;
  final int weight;
  final bool requiresAttunement;
  final String? attunementDescription;
  final ItemType itemType;
  final Currency currency;
  final Rarity rarity;

  Item({
    required this.itemType,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.weight,
    required this.requiresAttunement,
    this.attunementDescription,
    required this.currency,
    required this.rarity,
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
      // 'type': 'Miscellaneous',
      'currency': currency.name,
      'rarity': rarity.name,
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
      rarity: Rarity.values.firstWhere(
        (e) => e.name == map['rarity'],
      ),
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
    Rarity? rarity,
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
      rarity: rarity ?? this.rarity,
    );
  }
}

class CombatItem extends Item {
  final DamageType damageType1;
  final String damage1;
  final DamageType? damageType2;
  final String? damage2;
  final WeaponCategory weaponCategory;
  final Set<WeaponType?> weaponTypes;
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
    required this.weaponTypes,
    required Rarity rarity,
  }) : super(
            itemType: ItemType.Weapon,
            id: id,
            name: name,
            description: description,
            price: price,
            weight: weight,
            requiresAttunement: requiresAttunement,
            attunementDescription: attunementDescription,
            currency: currency,
            rarity: rarity);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'itemType': itemType.name,
      'damageType1': damageType1.name,
      'damage1': damage1,
      'damageType2': damageType2?.name,
      'damage2': damage2,
      'weaponCategory': weaponCategory.name,
      'weaponTypes': weaponTypes.map((e) => e?.name).toList(),
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
      weaponTypes: Set.from((map['weaponTypes'] as List<dynamic>?)?.map(
              (e) => WeaponType.values.firstWhere((type) => type.name == e)) ??
          []),
      rarity: Rarity.values.firstWhere((e) => e.name == map['rarity'],
          orElse: () => Rarity.Common),
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
    Set<WeaponType?>? weaponTypes,
    Rarity? rarity,
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
      weaponTypes: weaponTypes ?? this.weaponTypes,
      rarity: rarity ?? this.rarity,
    );
  }
}

enum LightArmor {
  Padded,
  Leather,
  StuddedLeather,
}

enum MediumArmor {
  Hide,
  ChainShirt,
  ScaleMail,
  Breastplate,
  HalfPlate,
}

enum HeavyArmor {
  RingMail,
  ChainMail,
  Splint,
  Plate,
}

class ArmorItem extends Item {
  final int armorClass;
  final ArmorType armorType;
  final bool stealthDisadvantage;
  final dynamic baseArmor; // Can be LightArmor, MediumArmor, or HeavyArmor

  ArmorItem({
    required String id,
    required String name,
    required String description,
    required int price,
    required this.armorClass,
    required this.armorType,
    required this.stealthDisadvantage,
    this.baseArmor,
    required int weight,
    required bool requiresAttunement,
    String? attunementDescription,
    required Currency currency,
    required Rarity rarity,
  }) : super(
          id: id,
          itemType: ItemType.Armor,
          name: name,
          description: description,
          price: price,
          weight: weight,
          requiresAttunement: requiresAttunement,
          attunementDescription:
              (requiresAttunement) ? attunementDescription : null,
          currency: currency,
          rarity: rarity,
        );

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map.addAll({
      'armorClass': armorClass,
      'armorType': armorType.name,
      'stealthDisadvantage': stealthDisadvantage,
      'baseArmor':
          baseArmor.toString().split('.').last, // Get the enum name as string
    });
    // debugPrint(map.toString()); // Debugging line

    return map;
  }

  factory ArmorItem.fromMap(String id, Map<String, dynamic> map) {
    ArmorType armorType = ArmorType.values.firstWhere(
      (e) => e.name == map['armorType'],
      orElse: () => ArmorType.Light,
    );

    // debugPrint(map.toString()); // Debugging line
    //
    // debugPrint("Retrieved armorType: ${map['armorType']}"); // Debugging line
    //
    dynamic baseArmor;
    // debugPrint("Retrieved baseArmor: ${map['baseArmor']}"); // Debugging line

    if (armorType == ArmorType.Light) {
      baseArmor = LightArmor.values.firstWhere(
        (e) => e.name == map['baseArmor'],
        orElse: () => LightArmor.Leather,
      );
    } else if (armorType == ArmorType.Medium) {
      baseArmor = MediumArmor.values.firstWhere(
        (e) => e.name == map['baseArmor'],
        orElse: () => MediumArmor.Hide,
      );
    } else if (armorType == ArmorType.Heavy) {
      baseArmor = HeavyArmor.values.firstWhere(
        (e) => e.name == map['baseArmor'],
        orElse: () => HeavyArmor.ChainMail,
      );
    }
    // debugPrint("Retrieved baseArmor: ${map['baseArmor']}"); // Debugging line

    return ArmorItem(
      id: id, // Use provided id
      name: map['name'] ?? 'Unknown',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
      armorClass: map['armorClass'] ?? 7,
      armorType: armorType,
      stealthDisadvantage: map['stealthDisadvantage'] ?? false,
      baseArmor: baseArmor,
      weight: map['weight'] ?? 0,
      requiresAttunement: map['requiresAttunement'] ?? false,
      attunementDescription: map['attunementDescription'] ?? '',
      currency: Currency.values.firstWhere(
        (e) => e.name == map['currency'],
        orElse: () => Currency.gp,
      ),
      rarity: Rarity.values.firstWhere(
        (e) => e.name == map['rarity'],
        orElse: () => Rarity.Common,
      ),
    );
  }

  ArmorItem copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    int? armorClass,
    ArmorType? armorType,
    bool? stealthDisadvantage,
    dynamic? baseArmor,
    int? weight,
    bool? requiresAttunement,
    String? attunementDescription,
    Currency? currency,
    Rarity? rarity,
  }) {
    return ArmorItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      armorClass: armorClass ?? this.armorClass,
      armorType: armorType ?? this.armorType,
      stealthDisadvantage: stealthDisadvantage ?? this.stealthDisadvantage,
      baseArmor: baseArmor ?? this.baseArmor,
      weight: weight ?? this.weight,
      requiresAttunement: requiresAttunement ?? this.requiresAttunement,
      attunementDescription:
          attunementDescription ?? this.attunementDescription,
      currency: currency ?? this.currency,
      rarity: rarity ?? this.rarity,
    );
  }
}

enum UseType { Wear, Wield, Other }

class WondrousItem extends Item {
  final bool activationRequirement;
  final String? activationDescription;
  final bool consumable;
  final int? charges;
  final UseType? useType;
  final String? resetCondition;
  WondrousItem(
      {required String id,
      required String name,
      required String description,
      required int price,
      required int weight,
      required bool requiresAttunement,
      String? attunementDescription,
      required Rarity rarity,
      required Currency currency,
      required this.activationRequirement,
      this.activationDescription,
      required this.consumable,
      this.charges,
      this.useType,
      this.resetCondition})
      : super(
          id: id,
          itemType: ItemType.Wondrous,
          name: name,
          description: description,
          price: price,
          weight: weight,
          requiresAttunement: requiresAttunement,
          attunementDescription:
              (requiresAttunement) ? attunementDescription : null,
          currency: currency,
          rarity: rarity,
        );

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map.addAll({
      'activationRequirement': activationRequirement,
      'activationDescription': activationDescription,
      'consumable': consumable,
      'charges': charges,
      'useType': useType?.name,
    });
    return map;
  }

  factory WondrousItem.fromMap(String id, Map<String, dynamic> map) {
    return WondrousItem(
      id: id, // Use provided id
      name: map['name'] ?? 'Unknown',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
      weight: map['weight'] ?? 0,
      requiresAttunement: map['requiresAttunement'] ?? false,
      attunementDescription: map['attunementDescription'] ?? '',
      rarity: Rarity.values.firstWhere(
        (e) => e.name == map['rarity'],
        orElse: () => Rarity.Common,
      ),
      currency: Currency.values.firstWhere(
        (e) => e.name == map['currency'],
        orElse: () => Currency.gp,
      ),
      activationRequirement: map['activationRequirement'] ?? false,
      activationDescription: map['activationDescription'],
      consumable: map['consumable'] ?? false,
      charges: map['charges'],
      useType: map['useType'] != null
          ? UseType.values.firstWhere((e) => e.name == map['useType'],
              orElse: () => UseType.Other)
          : null,
    );
  }

  WondrousItem copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    int? weight,
    bool? requiresAttunement,
    String? attunementDescription, // Corrected this
    Rarity? rarity,
    Currency? currency,
    bool? activationRequirement,
    String? activationDescription,
    bool? consumable,
    int? charges,
    UseType? useType,
    String? resetCondition,
  }) {
    return WondrousItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      requiresAttunement: requiresAttunement ?? this.requiresAttunement,
      attunementDescription: attunementDescription ??
          this.attunementDescription, // Corrected reference
      rarity: rarity ?? this.rarity,
      currency: currency ?? this.currency,
      activationRequirement:
          activationRequirement ?? this.activationRequirement,
      activationDescription:
          activationDescription ?? this.activationDescription,
      consumable: consumable ?? this.consumable,
      charges: charges ?? this.charges,
      useType: useType ?? this.useType,
      resetCondition: resetCondition ?? this.resetCondition,
    );
  }
}
