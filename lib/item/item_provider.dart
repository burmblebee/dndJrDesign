import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fixed_item.dart';

final selectedItemTypeProvider = StateProvider<ItemType?>((ref) => null);
final requiresAttunementProvider = StateProvider<bool>((ref) => false);
final selectedDamageType1Provider = StateProvider<DamageType?>((ref) => null);
final selectedDamageType2Provider = StateProvider<DamageType?>((ref) => null);
final selectedWeaponTypeProvider = StateProvider<Set<WeaponType>>((ref) => {});
final selectedWeaponCategoryProvider =
    StateProvider<WeaponCategory>((ref) => WeaponCategory.Simple);
final selectedArmorTypeProvider = StateProvider<ArmorType?>((ref) => null);
final selectedBaseArmorProvider = StateProvider<dynamic?>((ref) => null);
final selectedCurrencyProvider = StateProvider<Currency>((ref) => Currency.gp);
final stealthDisadvantageProvider = StateProvider<bool>((ref) => false);
final selectedACProvider = StateProvider<int>((ref) => 0);
final activationProvider = StateProvider<bool>((ref) => false);
final consumableProvider = StateProvider<bool>((ref) => false);
final rarityProvider = StateProvider<Rarity>((ref) => Rarity.Common);
final useTypeProvider = StateProvider<UseType?>((ref) => null);




class ItemState {
  final List<Item> items;
  final Item? selectedItem;
  // late final CombatItem? selectedWeapon;
  // late final ArmorItem? selectedArmor;

  ItemState({
    required this.items,
    this.selectedItem,
    // this.selectedWeapon,
    // this.selectedArmor,
  });

  // Item? get selectedWeapon =>
  //     selectedItem is CombatItem ? selectedItem as CombatItem : selectedItem is ArmorItem ? selectedItem as ArmorItem : null;

  ItemState copyWith({
    List<Item>? items,
    Item? selectedItem,

  }) {
    return ItemState(
      items: items ?? this.items,
      selectedItem: selectedItem ?? this.selectedItem,

    );
  }
}

final itemProvider =
    StateNotifierProvider<ItemProvider, ItemState>((ref) => ItemProvider());

class ItemProvider extends StateNotifier<ItemState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ItemProvider() : super(ItemState(items: [], selectedItem: null));

  Future<void> saveItem(Item item) async {
    try {
      debugPrint("Saving item: ${item.toMap()}");

      final uuid = FirebaseAuth.instance.currentUser?.uid;
      if (uuid == null) {
        debugPrint("Error: User is not authenticated.");
        return;
      }

      bool isNewItem = item.id.isEmpty;
      final docRef = isNewItem
          ? _firestore.collection('app_user_profiles').doc(uuid).collection('items').doc()
          : _firestore.collection('app_user_profiles').doc(uuid).collection('items').doc(item.id);

      if (isNewItem) {
        item = item.copyWith(id: docRef.id);
      }

      await docRef.set(item.toMap(), SetOptions(merge: true));

      state = state.copyWith(
        items: isNewItem
            ? [...state.items, item] // Append new item
            : state.items.map((i) => i.id == item.id ? item : i).toList(),
        selectedItem: null,
      );

      debugPrint("Item saved successfully: ${item.toMap()}");

    } catch (e) {
      debugPrint("Error saving item: $e");
    }
  }




  Future<void> fetchItems() async {
    try {
      final uuid = FirebaseAuth.instance.currentUser?.uid;
      final querySnapshot = await _firestore.collection('app_user_profiles').doc(uuid).collection('items').get();
      final items = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final type = data['itemType'];
        final id = doc.id;

        switch (type) {
          case 'Weapon':
            return CombatItem.fromMap(id, data);
          case 'Armor':
            return ArmorItem.fromMap(id, data);
          case 'Wondrous':
            return WondrousItem.fromMap(id, data);
          default:
            return Item.fromMap(id, data);
        }
      }).toList();

      state = state.copyWith(items: items);
    } catch (e) {
      debugPrint("Error fetching items: $e");
    }
  }

  void selectItem(Item item) {
    // debugPrint('Selecting item with type: ${item.itemType}');
    if (item.itemType == ItemType.Armor) {
      ArmorItem armorItem = ArmorItem.fromMap(item.id, item.toMap());
      // debugPrint('Selected an armor item: ${armorItem.name}');
      // debugPrint('ArmorType: ${armorItem.armorType}, BaseArmor: ${armorItem.baseArmor}');
      state = state.copyWith(selectedItem: armorItem);
    } else if (item.itemType == ItemType.Weapon) {
      final combatItem = CombatItem.fromMap(item.id, item.toMap());
      // debugPrint('Selected a combat item: ${combatItem.name}');
      state = state.copyWith(selectedItem: combatItem);
    } else if(item.itemType == ItemType.Wondrous) {
      final wondrousItem = WondrousItem.fromMap(item.id, item.toMap());
      state = state.copyWith(selectedItem: wondrousItem);
    }

    else {
      // debugPrint('Selected a regular item: ${item.name}');
      state = state.copyWith(selectedItem: item);
    }
  }





  void resetSelectedItem() {
    state = state.copyWith(selectedItem: null);

  }


  Future<void> deleteItem(String id) async {
    try {
      final uuid = FirebaseAuth.instance.currentUser?.uid;
      await _firestore.collection('app_user_profiles').doc(uuid).collection('items').doc(id).delete();
      state = state.copyWith(
        items: state.items.where((item) => item.id != id).toList(),
        selectedItem: null,
      );
    } catch (e) {
      debugPrint("Error deleting item: $e");
    }
  }

  Future<void> updateItem(Item item) async {
    if (item.id.isEmpty) {
      debugPrint("Error: Item ID is null, cannot update.");
      return;
    }
    try {
      final uuid = FirebaseAuth.instance.currentUser?.uid;
      await _firestore.collection('app_user_profiles').doc(uuid).collection('items').doc(item.id).update(item.toMap());
      state = state.copyWith(
        items: state.items.map((i) => i.id == item.id ? item : i).toList(),
        selectedItem: item,
      );
    } catch (e) {
      debugPrint("Error updating item: $e");
    }
  }
}
