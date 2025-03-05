import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../item.dart';
import '../item_provider.dart';

final requiresAttunementProvider = StateProvider<bool>((ref) => false);
final selectedDamageType1Provider = StateProvider<DamageType?>((ref) => null);
final selectedDamageType2Provider = StateProvider<DamageType?>((ref) => null);

class AddWeaponWidget extends ConsumerWidget {
  AddWeaponWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CombatItem? selectedItem = ref.watch(
        itemProvider.select((state) => state.selectedItem as CombatItem?));
    final requiresAttunement = ref.watch(requiresAttunementProvider);
    final selectedDamageType1 = ref.watch(selectedDamageType1Provider);
    final selectedDamageType2 = ref.watch(selectedDamageType2Provider);

    final weightController =
        TextEditingController(text: selectedItem?.weight.toString() ?? '0');
    final nameController =
        TextEditingController(text: selectedItem?.name ?? '');
    final descriptionController =
        TextEditingController(text: selectedItem?.description ?? '');
    final priceController =
        TextEditingController(text: selectedItem?.price.toString() ?? '0');
    final attunementDescriptionController =
        TextEditingController(text: selectedItem?.attunementDescription ?? '');

    void _updateItem({
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
      final CombatItem? selectedItem = ref.watch(
          itemProvider.select((state) => state.selectedItem as CombatItem?));

      if (selectedItem == null) return;

      final updatedItem = selectedItem.copyWith(
        name: name ?? selectedItem.name,
        description: description ?? selectedItem.description,
        price: price ?? selectedItem.price,
        weight: weight ?? selectedItem.weight,
        requiresAttunement:
            requiresAttunement ?? selectedItem.requiresAttunement,
        attunementDescription:
            attunementDescription ?? selectedItem.attunementDescription,
        damageType1: damageType1 ?? selectedItem.damageType1,
        damage1: damage1 ?? selectedItem.damage1,
        damageType2: damageType2 ?? selectedItem.damageType2,
        damage2: damage2 ?? selectedItem.damage2,
      );

      ref.read(itemProvider.notifier).updateItem(updatedItem);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
            onChanged: (value) => _updateItem(name: value),
          ),
          SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
            onChanged: (value) => _updateItem(description: value),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Price'),
                  onChanged: (value) =>
                      _updateItem(price: int.tryParse(value) ?? 0),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Weight'),
                  onChanged: (value) =>
                      _updateItem(weight: int.tryParse(value) ?? 0),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Requires Attunement'),
              Switch(
                value: requiresAttunement,
                onChanged: (value) {
                  ref.read(requiresAttunementProvider.notifier).state = value;
                  _updateItem(requiresAttunement: value);
                },
              ),
            ],
          ),
          if (requiresAttunement)
            TextField(
              controller: attunementDescriptionController,
              decoration: InputDecoration(labelText: 'Attunement Description'),
              onChanged: (value) => _updateItem(attunementDescription: value),
            ),
          SizedBox(height: 20),
          Text('Damage Type 1 (Required)'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<DamageType>(
                value: selectedDamageType1 ?? DamageType.Acid,
                hint: const Text("Select Damage Type 1"),
                onChanged: (DamageType? newValue) {
                  ref.read(selectedDamageType1Provider.notifier).state =
                      newValue;
                  _updateItem(damageType1: newValue);
                },
                items: DamageType.values.map((DamageType type) {
                  return DropdownMenuItem<DamageType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
              ),
              SizedBox(width: 10),
              ElevatedButton(onPressed: () {}, child: Text('Damage Dice'))
            ],
          ),
          SizedBox(height: 10),
          Text('Damage Type 2 (Optional)'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<DamageType>(
                value: selectedDamageType2,
                hint: const Text("Damage Type 2"),
                onChanged: (DamageType? newValue) {
                  ref.read(selectedDamageType2Provider.notifier).state =
                      newValue;
                  _updateItem(damageType2: newValue);
                },
                items: [
                  // Add a "None" option as the first item
                  const DropdownMenuItem<DamageType>(
                    value: null,
                    child: Text("None"),
                  ),
                  ...DamageType.values.map((DamageType type) {
                    return DropdownMenuItem<DamageType>(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                ],
              ),
              ElevatedButton(onPressed: () {}, child: Text('Damage Dice')),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final description = descriptionController.text;
              final price = int.tryParse(priceController.text) ?? 0;
              final weight = int.tryParse(weightController.text) ?? 0;
              final attunementDescription =
                  attunementDescriptionController.text;

              final myItem = CombatItem(
                name: name,
                description: description,
                price: price,
                weight: weight,
                requiresAttunement: requiresAttunement,
                attunementDescription: attunementDescription,
                damageType1: selectedDamageType1 ?? DamageType.Acid,
                damage1: '1',
                damageType2: selectedDamageType2,
                damage2: selectedDamageType2 != null ? '2' : null,
                id: '15',
              );

              if (ref.read(itemProvider).selectedItem == null) {
                ref.read(itemProvider.notifier).selectItem(myItem);
              }
              ref.read(itemProvider.notifier).addItem(myItem);
            },
            child: Text('Save'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
