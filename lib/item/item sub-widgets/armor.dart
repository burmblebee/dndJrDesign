import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../fixed_item.dart';
import '../item_provider.dart';

class AddArmorWidget extends ConsumerWidget {
  AddArmorWidget({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController armorClassController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController attunementDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ArmorItem? selectedItem = ref.watch(
        itemProvider.select((state) => state.selectedItem as ArmorItem?));
    final selectedArmorType = ref.watch(selectedArmorTypeProvider);
    final requiresAttunement = ref.watch(requiresAttunementProvider);
    final stealthDisadvantage = ref.watch(stealthDisadvantageProvider);
    final selectedCurrency = ref.watch(selectedCurrencyProvider);
    var ac = ref.watch(selectedACProvider);
    final selectedBaseArmor = ref.watch(selectedBaseArmorProvider);
    final selectedRarity = ref.watch(rarityProvider);

    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<Rarity>(
                    value: selectedRarity,
                    items: Rarity.values.map((type) {
                      return DropdownMenuItem<Rarity>(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (rarity) {
                      ref.read(rarityProvider.notifier).state = rarity!;
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<ArmorType>(
                    value: selectedArmorType,
                    hint: const Text("Select Armor Type"),
                    items: ArmorType.values.map((type) {
                      return DropdownMenuItem<ArmorType>(
                        value: type,
                        child: Text(type.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (type) {
                      ref.read(selectedArmorTypeProvider.notifier).state = type;
                      ref.read(selectedBaseArmorProvider.notifier).state = null;
                    },
                  ),
                  const SizedBox(width: 20),
                  correctBaseArmor(selectedArmorType, ref),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 5),
                ),
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: TextField(
                    textAlign: TextAlign.center,
                    scrollPadding: const EdgeInsets.all(10),
                    controller: armorClassController,
                    decoration: const InputDecoration(
                        labelText: 'AC',
                        labelStyle: TextStyle(
                          fontSize: 24,
                        )),
                    keyboardType: TextInputType.number,
                    expands: false,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      expands: false,
                    ),
                  ),
                  DropdownButton<Currency>(
                    value: selectedCurrency,
                    // hint: const Text("Select Currency"),
                    onChanged: (newValue) {
                      ref.read(selectedCurrencyProvider.notifier).state = newValue!;
                      // _updateItem(currency: newValue, ref: ref);
                    },
                    items: Currency.values.map((Currency currency) {
                      return DropdownMenuItem<Currency>(
                        value: currency,
                        child: Text(currency.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: weightController,
                      decoration: const InputDecoration(labelText: 'Weight'),
                      keyboardType: TextInputType.number,
                      expands: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Requires Attunement:'),
                  Switch(
                    value: requiresAttunement,
                    onChanged: (value) {
                      ref.read(requiresAttunementProvider.notifier).state = value;
                      // _updateItem(requiresAttunement: value, ref: ref);
                    },
                  ),
                ],
              ),
              if (requiresAttunement)
                TextField(
                  controller: attunementDescriptionController,
                  decoration: InputDecoration(labelText: 'Attunement Description'),
                  // onChanged: (value) => _updateItem(attunementDescription: value, ref: ref),
                ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Stealth Disadvantage'),
                  Switch(
                    value: stealthDisadvantage,
                    onChanged: (value) {
                      ref.read(stealthDisadvantageProvider.notifier).state = value;
                      // _updateItem(requiresAttunement: value, ref: ref);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  ac = int.tryParse(armorClassController.text) ?? 7;
                  ref.read(selectedACProvider.notifier).state = ac;
                  ArmorItem toSave = ArmorItem(
                    id: selectedItem?.id ?? '',
                    name: nameController.text,
                    description: descriptionController.text,
                    price: int.tryParse(priceController.text) ?? 0,
                    weight: int.tryParse(weightController.text) ?? 0,
                    requiresAttunement: requiresAttunement,
                    attunementDescription: attunementDescriptionController.text,
                    currency: selectedCurrency,
                    armorClass: ref.read(selectedACProvider),
                    armorType: selectedArmorType!,
                    stealthDisadvantage: stealthDisadvantage,
                    baseArmor: selectedBaseArmor,
                    rarity: selectedRarity,
                  );
                  // debugPrint(toSave.toString());
                  // debugPrint(toSave.toMap().toString());
                  if(checkIfFieldsAreFilled(ref)) {
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Item saved successfully!'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

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
            ],
          ),
        ),
      ),
    );
  }

  correctBaseArmor(ArmorType? selectedArmorType, WidgetRef ref) {
    if (selectedArmorType == null) {
      return const Text('Please select an armor type');
    } else {
      switch (selectedArmorType) {
        case ArmorType.Light:
          return DropdownButton<LightArmor>(
            value: ref.watch(selectedBaseArmorProvider) as LightArmor?,
            hint: const Text("Select Base Armor"),
            items: LightArmor.values.map((base) {
              return DropdownMenuItem<LightArmor>(
                value: base,
                child: Text(base.toString().split('.').last),
              );
            }).toList(),
            onChanged: (base) {
              ref.read(selectedBaseArmorProvider.notifier).state = base;
            },
          );
        case ArmorType.Medium:
          return DropdownButton<MediumArmor>(
            value: ref.watch(selectedBaseArmorProvider) as MediumArmor?,
            hint: const Text("Select Base Armor"),
            items: MediumArmor.values.map((base) {
              return DropdownMenuItem<MediumArmor>(
                value: base,
                child: Text(base.toString().split('.').last),
              );
            }).toList(),
            onChanged: (base) {
              ref.read(selectedBaseArmorProvider.notifier).state = base;
            },
          );
        case ArmorType.Heavy:
          return DropdownButton<HeavyArmor>(
            value: ref.watch(selectedBaseArmorProvider) as HeavyArmor?,
            hint: const Text("Select Base Armor"),
            items: HeavyArmor.values.map((base) {
              return DropdownMenuItem<HeavyArmor>(
                value: base,
                child: Text(base.toString().split('.').last),
              );
            }).toList(),
            onChanged: (base) {
              ref.read(selectedBaseArmorProvider.notifier).state = base;
            },
          );
        case ArmorType.Shield:
          return const SizedBox.shrink();
      }
    }
  }

  void clearFormFields(WidgetRef ref) {
    nameController.clear();
    descriptionController.clear();
    armorClassController.clear();
    weightController.clear();
    priceController.clear();
    attunementDescriptionController.clear();
    ref.read(selectedArmorTypeProvider.notifier).state = null;
    ref.read(selectedBaseArmorProvider.notifier).state = null;
    ref.read(requiresAttunementProvider.notifier).state = false;
    ref.read(stealthDisadvantageProvider.notifier).state = false;
    ref.read(selectedCurrencyProvider.notifier).state = Currency.gp;
    ref.read(selectedACProvider.notifier).state = 0;
    ref.read(rarityProvider.notifier).state = Rarity.Common;
  }

  bool checkIfFieldsAreFilled(WidgetRef ref) {
    return nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        armorClassController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        ref.watch(selectedArmorTypeProvider)!= null &&
        ref.watch(selectedBaseArmorProvider) != null;
  }
}
