import 'package:flutter/material.dart';
import '../fixed_item.dart';

class WondrousDetailsScreen extends StatelessWidget {
  final WondrousItem item; // Accept the WondrousItem as a parameter

  const WondrousDetailsScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Handle delete logic here
              Navigator.pop(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          // Handle saving logic here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item details saved!')),
          );
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${item.name}', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 10),
              const Text('Description:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(item.description, style: const TextStyle(fontSize: 20)),
              Row(
                children: [
                  const Text(
                    'Rarity: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(item.rarity.name, style: const TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Price: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text('${item.price} ${item.currency.name}',
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Weight: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text('${item.weight} lbs',
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),
              if (item.requiresAttunement)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Requires Attunement',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    if (item.attunementDescription?.isNotEmpty ?? false)
                      Text(item.attunementDescription!,
                          style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 20),
                  ],
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Consumable: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text((item.consumable) ? 'Yes' : 'No',
                      style: const TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),
              if (item.activationRequirement)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Activation Requirement: ',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text('${item.activationDescription ?? 'None'}',
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
              const SizedBox(height: 20),
              if (item.charges != null && item.charges! > 0)
                Column(
                  children: [
                    const Text(
                      'Charges: ',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text('${item.charges} charges ',
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
              const SizedBox(height: 10),
              if (!item.consumable && item.charges! > 0 && item.charges != null)
                Column(
                  children: [
                    const Text(
                      'Reset Condition: ',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(item.resetCondition ?? 'None',
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
