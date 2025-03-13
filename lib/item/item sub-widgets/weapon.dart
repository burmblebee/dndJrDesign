import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../fixed_item.dart';
import '../item_provider.dart';

final requiresAttunementProvider = StateProvider<bool>((ref) => false);
final selectedDamageType1Provider = StateProvider<DamageType?>((ref) => null);
final selectedDamageType2Provider = StateProvider<DamageType?>((ref) => null);
final selectedWeaponCategoryProvider = StateProvider<WeaponCategory?>((ref) => null);



class AddWeaponWidget extends ConsumerWidget {
  AddWeaponWidget();

  List<String> diceLabels = ['d4', 'd6', 'd8', 'd10', 'd12', 'd20', 'd100'];
  String damageConfig1 = '';
  String damageConfig2 = '';
  Currency selectedCurrency = Currency.gp;
  TextEditingController weightController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController =  TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController attunementDescriptionController = TextEditingController();

  String getDiceString(List<int> diceConfig) {
    List<String> diceParts = [];
    for (int i = 0; i < diceConfig.length; i++) {
      if (diceConfig[i] > 0) {
        diceParts.add('${diceConfig[i]}${diceLabels[i]}');
      }
    }
    return diceParts.isNotEmpty ? diceParts.join(' + ') : 'No dice set';
  }

  bool checkIfFieldsAreFilled() {
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        damageConfig1.isNotEmpty
    ) {
      return true;
    }
    return false;
  }

  void _addAttack(BuildContext context, ItemProvider itemNotifier, int damageIndex, WidgetRef ref){
    List<int> diceConfig = List.filled(7, 0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Attack Option'),
        content: _attackForm(diceConfig),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final diceString = getDiceString(diceConfig);

              if (damageIndex == 0) {
                damageConfig1 = diceString;
              } else {
                damageConfig2 = diceString;
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }



  Widget _attackForm(List<int> diceConfig) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Text('Dice Configuration (e.g., 1d4, 2d6)'),
          Column(
            children: List.generate(7, (index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(diceLabels[index]),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      initialValue: diceConfig[index].toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        diceConfig[index] = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

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
    WeaponCategory? weaponCategory,
    required WidgetRef ref
  }) {
    final CombatItem? selectedItem = ref.watch(
        itemProvider.select((state) => state.selectedItem as CombatItem?));

    if (selectedItem == null) return;

    final updatedItem = selectedItem.copyWith(
      weaponCategory: weaponCategory ?? selectedItem.weaponCategory,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CombatItem? selectedItem = ref.watch(
        itemProvider.select((state) => state.selectedItem as CombatItem?));
    final requiresAttunement = ref.watch(requiresAttunementProvider);
    final selectedDamageType1 = ref.watch(selectedDamageType1Provider);
    final selectedDamageType2 = ref.watch(selectedDamageType2Provider);
    final selectedWeaponCategory = ref.watch(selectedWeaponCategoryProvider);
    final selectedItemType = ref.watch(selectedItemTypeProvider);


    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
        SizedBox(
        width: 150,
          height: 60,
          child: DropdownButton<WeaponCategory>(
            isExpanded: true,
            value: selectedWeaponCategory,
            hint: const Text("Select Weapon Category"),
            onChanged: (WeaponCategory? newValue) {
              if (newValue != null) {
                ref.read(selectedWeaponCategoryProvider.notifier).state = newValue;
                _updateItem(weaponCategory: newValue, ref: ref);
              }
            },
            items: WeaponCategory.values.map((WeaponCategory category) {
              return DropdownMenuItem<WeaponCategory>(
                value: category,
                child: Text(category.toString().split('.').last),
              );
            }).toList(),
          ),
        ),
      const Spacer(),
          ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Select Weapon Types"),
                          content: Consumer(
                            builder: (context, ref, _) {
                              final selectedWeaponTypes = ref.watch(selectedWeaponTypeProvider);

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: WeaponType.values.map((weapon) {
                                  return CheckboxListTile(
                                    title: Text(weapon.toString().split('.').last),
                                    value: selectedWeaponTypes.contains(weapon),
                                    onChanged: (bool? isChecked) {
                                      final updatedSelection = Set<WeaponType>.from(selectedWeaponTypes);
                                      if (isChecked == true) {
                                        updatedSelection.add(weapon);
                                      } else {
                                        updatedSelection.remove(weapon);
                                      }
                                      ref.read(selectedWeaponTypeProvider.notifier).state = updatedSelection;
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("Select Weapon Types"),
                ),
              ],
            ),

            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) => _updateItem(name: value, ref: ref),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (value) => _updateItem(description: value, ref: ref),
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
                        _updateItem(price: int.tryParse(value) ?? 0, ref: ref),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<Currency>
                  (value: selectedCurrency,
               // hint: const Text("Select Currency"),
                onChanged: (newValue) {
                  selectedCurrency = newValue!;
                },
                  items: Currency.values.map((Currency currency) {
                    return DropdownMenuItem<Currency>(
                      value: currency,
                      child: Text(currency.toString().split('.').last),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 100),
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Weight'),
                    onChanged: (value) =>
                        _updateItem(weight: int.tryParse(value) ?? 0, ref: ref),
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
                    _updateItem(requiresAttunement: value, ref: ref);
                  },
                ),
              ],
            ),
            if (requiresAttunement)
              TextField(
                controller: attunementDescriptionController,
                decoration: InputDecoration(labelText: 'Attunement Description'),
                onChanged: (value) => _updateItem(attunementDescription: value, ref: ref),
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
                    _updateItem(damageType1: newValue, ref: ref);
                  },
                  items: DamageType.values.map((DamageType type) {
                    return DropdownMenuItem<DamageType>(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      _addAttack(context, ref.read(itemProvider.notifier), 0, ref); // 0 for damage1
                    },
                    child: Text('Damage Dice'))
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
                    ref.read(selectedDamageType2Provider.notifier).state = newValue;
                    _updateItem(damageType2: newValue, ref: ref);
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
                if (selectedDamageType2 != null)
                  ElevatedButton(
                    onPressed: () {
                      _addAttack(context, ref.read(itemProvider.notifier), 1, ref); // 1 for damage2
                    },
                    child: Text('Damage Dice'),
                  ),
              ],
            ),

            ElevatedButton(
              onPressed: () async {
                CombatItem toSave = CombatItem(
                  id: selectedItem?.id ?? '',
                  name: nameController.text,
                  description: descriptionController.text,
                  price: int.tryParse(priceController.text) ?? 0,
                  weight: int.tryParse(weightController.text) ?? 0,
                  requiresAttunement: requiresAttunement,
                  attunementDescription: attunementDescriptionController.text,
                  damageType1: selectedDamageType1 ?? DamageType.Acid,
                  damage1: damageConfig1,
                  damageType2: selectedDamageType2 != null ? selectedDamageType2 : null,
                  damage2: selectedDamageType2 != null ? damageConfig2 : null,
                  weaponCategory: selectedWeaponCategory ?? WeaponCategory.Simple,
                  currency: selectedCurrency,
                  weaponTypes: ref.read(selectedWeaponTypeProvider.notifier).state.toSet(),
                );
                if(checkIfFieldsAreFilled()) {
                  await ref.read(itemProvider.notifier).saveItem(
                    toSave,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Item saved successfully!'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  // Clear the form fields
                  clearFormFields(ref);

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill out all fields!'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void clearFormFields(WidgetRef ref) {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    weightController.clear();
    attunementDescriptionController.clear();
    damageConfig1 = '';
    damageConfig2 = '';
    ref.read(selectedDamageType1Provider.notifier).state = null;
    ref.read(selectedDamageType2Provider.notifier).state = null;
    ref.read(selectedWeaponCategoryProvider.notifier).state = null;
    ref.read(selectedWeaponTypeProvider.notifier).state = {};
    ref.read(requiresAttunementProvider.notifier).state = false;
    ref.read(selectedItemTypeProvider.notifier).state = null;
  }
}
