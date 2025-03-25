import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../fixed_item.dart';
import '../item_provider.dart';

class AddWondrousWidget extends ConsumerWidget {
  AddWondrousWidget({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController activationController = TextEditingController();
  final TextEditingController chargesController = TextEditingController();
  final TextEditingController attunementController = TextEditingController();
  final TextEditingController resetConditionController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemProvider);
    final WondrousItem? selectedItem = ref.watch(
        itemProvider.select((state) => state.selectedItem as WondrousItem?));
    final selectedCurrency = ref.watch(selectedCurrencyProvider);
    final activationBool = ref.watch(activationProvider);
    final attunementBool = ref.watch(requiresAttunementProvider);
    final consumableBool = ref.watch(consumableProvider);
    final selectedRarity = ref.watch(rarityProvider);
    final selectedUseType = ref.watch(useTypeProvider);

    // if (wondrous == null) {
    //   return Scaffold(
    //     appBar: AppBar(title: const Text('Wondrous Item Details')),
    //     body: const Center(
    //       child: Text(
    //         'Wondrous Item not found!',
    //         style: TextStyle(fontSize: 20),
    //       ),
    //     ),
    //   );
    // }
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
                DropdownButton<UseType>(
                  value: selectedUseType,
                  hint: const Text('Select Use Type'),
                  items: UseType.values.map((type) {
                    return DropdownMenuItem<UseType>(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (useType) {
                    ref.read(useTypeProvider.notifier).state = useType!;
                  },
                ),
              ],
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
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
                    ref.read(selectedCurrencyProvider.notifier).state =
                        newValue!;
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
            Row(
              children: [
                const Text('Activation Requirement:',
                    style: TextStyle(fontSize: 16)),
                const Spacer(),
                Switch(
                    value: activationBool,
                    onChanged: (value) {
                      ref.read(activationProvider.notifier).state = value;
                    }),
              ],
            ),
            if (activationBool)
              TextField(
                controller: activationController,
                decoration:
                    const InputDecoration(labelText: 'Activation Requirement'),
              ),
            // const SizedBox(height: 10),
            Row(
              children: [
                const Text('Requires Attunement:',
                    style: TextStyle(fontSize: 16)),
                const Spacer(),
                Switch(
                    value: attunementBool,
                    onChanged: (value) {
                      ref.read(requiresAttunementProvider.notifier).state =
                          value;
                    }),
              ],
            ),
            if (attunementBool)
              TextField(
                controller: attunementController,
                decoration:
                    const InputDecoration(labelText: 'Attunement Description'),
              ),
            // const SizedBox(height: 10),
            Row(
              children: [
                const Text('Consumable:', style: TextStyle(fontSize: 16)),
                const Spacer(),
                Switch(
                    value: consumableBool,
                    onChanged: (value) {
                      ref.read(consumableProvider.notifier).state = value;
                    }),
              ],
            ),
            TextField(
              controller: chargesController,
              decoration:
                  const InputDecoration(labelText: 'Charges (optional)'),
              keyboardType: TextInputType.number,
            ),
            if (chargesController.text.isNotEmpty && !consumableBool)
              TextField(
                controller: resetConditionController,
                decoration: const InputDecoration(labelText: 'Reset Condition'),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  WondrousItem toSave = WondrousItem(
                    name: nameController.text,
                    description: descriptionController.text,
                    price: int.tryParse(priceController.text) ?? 0,
                    weight: int.tryParse(weightController.text) ?? 0,
                    currency: selectedCurrency,
                    rarity: selectedRarity,
                    useType: selectedUseType,
                    requiresAttunement: attunementBool,
                    attunementDescription: attunementController.text,
                    activationDescription: activationController.text,
                    activationRequirement: activationBool,
                    consumable: consumableBool,
                    charges: int.tryParse(chargesController.text) ?? 0,
                    resetCondition: resetConditionController.text,
                    id: selectedItem?.id ?? '',
                  );
                  if (checkIfFieldsAreFilled(ref)) {
                    await ref.read(itemProvider.notifier).saveItem(
                          toSave,
                        );
                    clearFormFields(ref);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Item saved successfully!'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
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
                child: Text('Save'))
          ],
        ),
      )),
    );
  }

  bool checkIfFieldsAreFilled(WidgetRef ref) {
    return nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        weightController.text.isNotEmpty &&
        (!ref.read(consumableProvider)|| (chargesController.text.isNotEmpty && !(ref.read(consumableProvider)) && resetConditionController.text.isNotEmpty) || ref.read(consumableProvider));
  }

  void clearFormFields(WidgetRef ref) {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    weightController.clear();
    activationController.clear();
    chargesController.clear();
    attunementController.clear();
    resetConditionController.clear();
  }
}
