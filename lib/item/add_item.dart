import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'item sub-widgets/armor.dart';
import 'item sub-widgets/misc.dart';
import 'item sub-widgets/weapon.dart';
import 'fixed_item.dart';
import 'item sub-widgets/wondrous.dart';
import 'item_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItem extends ConsumerWidget {
  const AddItem({super.key});

  // Correct Widget based on ItemType
  Widget correctWidget(ItemType type) {
    switch (type) {
      case ItemType.Weapon:
        return AddWeaponWidget();
      case ItemType.Armor:
        return AddArmorWidget();
    // case ItemType.Potion:
    // return AddPotionWidget();
      case ItemType.Wondrous:
        return AddWondrousWidget();
      case ItemType.Miscellaneous:
        return AddMiscWidget();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItemType = ref.watch(selectedItemTypeProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            DropdownButton<ItemType>(
              value: selectedItemType,
              hint: const Text("Select Item Type"),
              onChanged: (ItemType? newValue) {
                ref.read(selectedItemTypeProvider.notifier).state = null;
                ref.read(itemProvider.notifier).state = ItemState(
                  items: [],
                  selectedItem: null,
                );
                ref.read(selectedItemTypeProvider.notifier).state = newValue;
              },
              items: ItemType.values.map((ItemType type) {
                return DropdownMenuItem<ItemType>(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
            ),
            if (selectedItemType != null) correctWidget(selectedItemType),
          ],
        ),
      ),
    );
  }
}