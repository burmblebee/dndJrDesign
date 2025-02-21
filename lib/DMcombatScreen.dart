import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'character.dart';
import 'diceRoller.dart';
import 'combat_provider.dart'; // Import your provider

class DMCombatScreen extends ConsumerWidget {
  const DMCombatScreen({super.key, required this.campaignId});
  final String campaignId;

  void attackBottomSheet(BuildContext context, List<Character> characters, WidgetRef ref) {
    int damage = 0;
    String? selectedCharacter;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows it to resize with the keyboard
      backgroundColor: Colors.transparent, // Prevents weird gaps
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            List<String> characterNames = characters.map((character) => character.name).toList();

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 159, 158, 154),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Wrap( // Automatically sizes to content
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Attack',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButton<String>(
                            hint: const Text("Select a Character"),
                            value: selectedCharacter,
                            items: characterNames.map((name) {
                              return DropdownMenuItem<String>(
                                value: name,
                                child: Text(name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCharacter = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Damage',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              damage = int.tryParse(value) ?? 0;
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (selectedCharacter != null) {
                                    int newHealth = characters
                                        .firstWhere((char) => char.name == selectedCharacter)
                                        .health - damage;
                                    ref.read(combatProvider.notifier).updateHealth(selectedCharacter!, newHealth);
                                    Navigator.pop(context);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('No Character Selected'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Attack'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void healBottomSheet(BuildContext context, List<Character> characters, WidgetRef ref) {
    String? selectedCharacter; // Moved outside so it doesn't reset
    int healedAmount = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 159, 158, 154),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Heal Options',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButton<String>(
                            hint: const Text("Select a Character"),
                            value: selectedCharacter,
                            items: characters.map((character) {
                              return DropdownMenuItem<String>(
                                value: character.name,
                                child: Text(character.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCharacter = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Healing Amount',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                healedAmount = int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (selectedCharacter != null) {
                                    Character character = characters.firstWhere((char) => char.name == selectedCharacter);
                                    int newHealth = character.health + healedAmount;

                                    // Cap healing at max health
                                    newHealth = newHealth > character.maxHealth ? character.maxHealth : newHealth;

                                    ref.read(combatProvider.notifier).updateHealth(selectedCharacter!, newHealth);
                                    Navigator.pop(context);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('No Character Selected'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Heal'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(combatProvider);

    final oddItemColor = Theme.of(context).canvasColor;
    final evenItemColor = Colors.white.withOpacity(0.2);

    return Scaffold(
      appBar: AppBar(title: const Text('Combat Screen')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiceRollScreen(campaignId: campaignId),
            ),
          );
        },
        child: const Icon(Icons.casino),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      attackBottomSheet(context, characters, ref);
                    },
                    child: const Text('Attack')),
                const SizedBox(width: 20),
                ElevatedButton(onPressed: () {
                  healBottomSheet(context, characters, ref);
                }, child: const Text('Heal')),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {}, child: const Text('Add Character')),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () {}, child: const Text('Start New Combat')),
              ],
            ),
            const SizedBox(height: 20),
            // Pass the context to the currentTurnOrder method
            currentTurnOrder(
                context, characters, oddItemColor, evenItemColor, ref),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  // Accept BuildContext as a parameter
  Widget currentTurnOrder(BuildContext context, List<Character> characters,
      Color oddItemColor, Color evenItemColor, WidgetRef ref) {
    return SizedBox(
      height: 500,
      child: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: [
          for (int index = 0; index < characters.length; index++)
            Container(
              key: ValueKey(characters[index]),
              decoration: BoxDecoration(
                color: index.isEven ? evenItemColor : oddItemColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        characters[index].name,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${characters[index].health}/${characters[index].maxHealth}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${characters[index].armorClass}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
              ),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          ref
              .read(combatProvider.notifier)
              .reorderCharacters(oldIndex, newIndex);
        },
      ),
    );
  }
}
