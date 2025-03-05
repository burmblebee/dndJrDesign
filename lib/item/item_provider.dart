import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'item.dart'; // Make sure 'CombatItem' is defined here.

final selectedItemTypeProvider = StateProvider<ItemType?>((ref) => null);
final requiresAttunementProvider = StateProvider<bool>((ref) => false);

class ItemState {
  final List<Item> items;
  final Item? selectedItem;

  ItemState({
    required this.items,
    this.selectedItem,
  });

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

final itemProvider = StateNotifierProvider<ItemProvider, ItemState>((ref) => ItemProvider());

class ItemProvider extends StateNotifier<ItemState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ItemProvider() : super(ItemState(items: [], selectedItem: null));

  // Add Item
  Future<void> addItem(Item item) async {
    try {
      final docRef = _firestore.collection('items').doc(); // Generate an ID if missing
      final newItem = item.id.isEmpty ? item.copyWith(id: docRef.id) : item;

      await docRef.set(newItem.toMap());

      state = state.copyWith(items: [...state.items, newItem], selectedItem: newItem);

      print("Item added successfully with ID: ${newItem.id}");
    } catch (e) {
      print("Error adding item to Firestore: $e");
    }
  }


  // Fetch Items
  Future<void> fetchItems() async {
    try {
      final querySnapshot = await _firestore.collection('items').get();
      final items = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final id = doc.id;
        if (data['type'] == 'Weapon') {
          return CombatItem.fromMap(data, id);
        } else if (data['type'] == 'Armor') {
          return ArmorItem.fromMap(data, id);
        }
        return Item.fromMap(data, id);
      }).toList();

      state = state.copyWith(items: items.cast<Item>());
    } catch (e) {
      print("Error fetching items: $e");
    }
  }

  // Update Item
  Future<void> updateItem(Item item) async {
    try {
      await _firestore.collection('items').doc(item.id).update(item.toMap());
      state = state.copyWith(
        items: state.items.map((existingItem) {
          return existingItem.id == item.id ? item : existingItem;
        }).toList(),
        selectedItem: item,
      );
    } catch (e) {
      print("Error updating item: $e");
    }
  }

  // Delete Item
  Future<void> deleteItem(String itemId) async {
    try {
      await _firestore.collection('items').doc(itemId).delete();
      state = state.copyWith(
        items: state.items.where((i) => i.id != itemId).toList(),
      );
    } catch (e) {
      print("Error deleting item: $e");
    }
  }

  // Select Item
  void selectItem(Item item) {
    state = state.copyWith(selectedItem: item);
  }

  Future<void> updateRequiresAttunement(bool value) async {
    if (state.selectedItem != null) {
      final updatedItem = state.selectedItem!.copyWith(requiresAttunement: value);

      try {
        await _firestore.collection('items').doc(updatedItem.id).update({
          'requiresAttunement': updatedItem.requiresAttunement,
        });

        // Update the entire state, including items list
        state = state.copyWith(
          selectedItem: updatedItem,
          items: state.items.map((item) => item.id == updatedItem.id ? updatedItem : item).toList(),
        );
      } catch (e) {
        print("Error updating requiresAttunement: $e");
      }
    }
  }
}
