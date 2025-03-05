import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../item.dart';
import '../item_provider.dart';

final requiresAttunementProvider = StateProvider<bool>((ref) => false); // Riverpod state for requiresAttunement

class AddWeaponWidget extends ConsumerWidget {
  AddWeaponWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(itemProvider.select((state) => state.selectedItem));
    final requiresAttunement = ref.watch(requiresAttunementProvider.state).state;

    final weightController = TextEditingController(
        text: selectedItem?.weight.toString() ?? '0');
    final nameController = TextEditingController(text: selectedItem?.name ?? '');
    final descriptionController = TextEditingController(text: selectedItem?.description ?? '');
    final priceController = TextEditingController(text: selectedItem?.price.toString() ?? '0');
    final attunementDescriptionController = TextEditingController(text: selectedItem?.attunementDescription ?? '');

    void _updateItem({
      String? name,
      String? description,
      String? price,
      String? weight,
      bool? requiresAttunement,
      String? attunementDescription,
    }) {
      if (selectedItem == null) {
        print("No selected item to update");
        return;
      }

      final updatedItem = selectedItem.copyWith(
        name: name ?? selectedItem.name,
        description: description ?? selectedItem.description,
        weight: weight != null ? (double.tryParse(weight) ?? selectedItem.weight).toInt() : selectedItem.weight,
        requiresAttunement: requiresAttunement ?? selectedItem.requiresAttunement,
        attunementDescription: attunementDescription ?? selectedItem.attunementDescription,
      );

      ref.read(itemProvider.notifier).updateItem(updatedItem);
    }

    return Consumer(builder: (context, ref, child) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                _updateItem(name: value);
              },
            ),
            SizedBox(height: 10),

            // Description Field
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                _updateItem(description: value);
              },
            ),
            SizedBox(height: 10),

            Row(
              children: [
                // Price Field
                Expanded(
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Price'),
                    onChanged: (value) {
                      _updateItem(price: value);
                    },
                  ),
                ),
                SizedBox(width: 10),

                // Weight Field
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Weight'),
                    onChanged: (value) {
                      _updateItem(weight: value);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Requires Attunement Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Requires Attunement'),
                Switch(
                  value: ref.watch(requiresAttunementProvider), // Watch the provider directly
                  onChanged: (value) {
                    ref.read(requiresAttunementProvider.notifier).state = value;
                    _updateItem(requiresAttunement: value); // Update the item state
                    print("User Changed Requires Attunement to: $value");
                  },
                ),
              ],
            ),

            // Conditionally display Attunement Description TextField
            if (ref.watch(requiresAttunementProvider)) // Watch the state directly
              TextField(
                controller: attunementDescriptionController,
                decoration: InputDecoration(labelText: 'Attunement Description'),
                onChanged: (value) {
                  _updateItem(attunementDescription: value); // Update the item with the new description
                },
              ),
          //  Spacer(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final description = descriptionController.text;
                final price = priceController.text;
                final weight = weightController.text;
                final attunementDescription = attunementDescriptionController.text;
                CombatItem myItem = CombatItem(
                  name: name,
                  description: description,
                  price: int.tryParse(price) ?? 0,
                  weight: int.tryParse(weight) ?? 0,
                  requiresAttunement: requiresAttunement,
                  attunementDescription: attunementDescription,
                  damageType: DamageType.acid,
                  damage: '1',
                  id: '15',

                );

                  if (ref.read(itemProvider).selectedItem == null) {
                    print("No item selected! Selecting first available item.");
                    ref.read(itemProvider.notifier).selectItem(myItem); // Ensure an item is selected
                  }
                  ref.read(itemProvider.notifier).updateRequiresAttunement(true);
                },
              child: Text('Save'),
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}
