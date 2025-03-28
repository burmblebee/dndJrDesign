import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../fixed_item.dart';
import '../item_provider.dart';

class AddMiscWidget extends ConsumerWidget {
  AddMiscWidget({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController attunementController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemProvider);
    final WondrousItem? selectedItem = ref.watch(
        itemProvider.select((state) => state.selectedItem as WondrousItem?));
    final selectedCurrency = ref.watch(selectedCurrencyProvider);
    final attunementBool = ref.watch(requiresAttunementProvider);
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
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      Item toSave = Item(
                        name: nameController.text,
                        description: descriptionController.text,
                        price: int.tryParse(priceController.text) ?? 0,
                        weight: int.tryParse(weightController.text) ?? 0,
                        currency: selectedCurrency,
                        rarity: selectedRarity,
                        requiresAttunement: attunementBool,
                        attunementDescription: attunementController.text,
                        id: selectedItem?.id ?? '',
                        itemType: ItemType.Miscellaneous,
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
        weightController.text.isNotEmpty;
  }

  void clearFormFields(WidgetRef ref) {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    weightController.clear();
    attunementController.clear();
  }
}
