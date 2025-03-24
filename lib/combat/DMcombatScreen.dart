import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/combat/premade_attacks.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/combat_nav_bar.dart';
import '../dice/diceRoller.dart';
import '../npc/npc.dart';
import '../npc/npc_provider.dart';
import 'attack_roll.dart';
import 'character.dart';
import 'combat_provider.dart';

class DMCombatScreen extends ConsumerWidget {
  const DMCombatScreen({super.key, required this.campaignId});
  final String campaignId;

  void attackBottomSheet(BuildContext context, List<Character> characters,
      WidgetRef ref, int currentTurnIndex) {
    String? selectedCharacter;

    void handleRollComplete(int total) {
      ref.read(diceRollProvider.notifier).state = total;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              int damage = ref.watch(diceRollProvider);

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  List<String> characterNames = characters
                      .where((character) => character.health > 0)
                      .map((character) => character.name)
                      .toList();

                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 159, 158, 154),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Wrap(
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PremadeAttack(
                                                        campaignId: campaignId,
                                                        attackOptions: characters[
                                                                currentTurnIndex]
                                                            .attacks,
                                                        onRollComplete:
                                                            handleRollComplete,
                                                      )));
                                        },
                                        child: const Text('Premade Attack')),
                                    ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Enter Damage'),
                                                content: TextField(
                                                  decoration: const InputDecoration(
                                                    labelText: 'Damage Amount',
                                                    border: OutlineInputBorder(),
                                                  ),
                                                  keyboardType: TextInputType.number,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      damage = int.tryParse(value) ?? 0;
                                                    });
                                                  },
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(onPressed: (){
                                                    ref.read(diceRollProvider.notifier).state = damage;
                                                    Navigator.pop(context);
                                                  }, child: const Text('Save'))
                                                ],
                                              ));
                                        },
                                        child: const Text('Enter Damage')),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AttackRoll(
                                                      campaignId: campaignId, onRollComplete: handleRollComplete,)));
                                    },
                                    child: const Text('Roll for Damage')),
                                const SizedBox(height: 20),
                                Text(
                                  'Damage: $damage',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        ref.read(diceRollProvider.notifier).state = 0;
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (selectedCharacter != null) {
                                          int newHealth = characters
                                                  .firstWhere((char) =>
                                                      char.name ==
                                                      selectedCharacter)
                                                  .health -
                                              damage;
                                          ref
                                              .read(combatProvider.notifier)
                                              .updateHealth(
                                                  selectedCharacter!, newHealth);
                                          Navigator.pop(context);
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                  'No Character Selected'),
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
          ),
        );
      },
    );
  }

  void healBottomSheet(
      BuildContext context, List<Character> characters, WidgetRef ref) {
    String? selectedCharacter;
    int healedAmount = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
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
                                    Character character = characters.firstWhere(
                                        (char) =>
                                            char.name == selectedCharacter);
                                    int newHealth =
                                        character.health + healedAmount;

                                    // Cap healing at max health
                                    newHealth = newHealth > character.maxHealth
                                        ? character.maxHealth
                                        : newHealth;

                                    ref
                                        .read(combatProvider.notifier)
                                        .updateHealth(
                                            selectedCharacter!, newHealth);
                                    Navigator.pop(context);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title:
                                            const Text('No Character Selected'),
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

  void addRemoveCharacterBottomSheet(
      BuildContext context, WidgetRef ref, List<Character> characters) {
    String? selectedName;
    int? hp;
    int? ac;
    int? maxHealth;
    String? removeCharacter;
    ref.read(npcProvider.notifier).fetchNPCs();
    final npcState = ref.watch(npcProvider);
    String? npc = npcState.npcs[0].name;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                        children: [
                          const Text(
                            'Create Quick Character to Add',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Character Name',
                              border: OutlineInputBorder(),
                              hintText: 'Enter character name',
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                selectedName = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Current Health',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      hp = int.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Max Health',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      maxHealth = int.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Armor Class',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      ac = int.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          const Text(
                            'OR Select a Character to Add.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //drop down list of all npc names from firestore
                          // DropdownButton<String>(
                          //   hint: const Text("Select a Character"),
                          //   value: npc,
                          //   items: npcState.npcs.map((npc) {
                          //     return DropdownMenuItem<String>(
                          //       value: npc.name,
                          //       child: Text(npc.name),
                          //     );
                          //   }).toList(),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       npc = value;
                          //     });
                          //   },
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (selectedName != null &&
                                      selectedName!.isNotEmpty &&
                                      hp != null &&
                                      hp! > 0 &&
                                      maxHealth != null &&
                                      maxHealth! > 0 &&
                                      ac != null &&
                                      ac! > 0) {
                                    ref
                                        .read(combatProvider.notifier)
                                        .addCharacter(selectedName!, hp!,
                                            maxHealth!, ac!);
                                    Navigator.pop(context);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                            'You left something empty!'),
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
                                child: const Text('Add Character'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'OR Select a Character to Remove.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButton<String>(
                            hint: const Text("Select a Character to Remove"),
                            value: removeCharacter,
                            items: characters.map((character) {
                              return DropdownMenuItem<String>(
                                value: character.name,
                                child: Text(character.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                removeCharacter = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (removeCharacter != null &&
                                      removeCharacter!.isNotEmpty) {
                                    ref
                                        .read(combatProvider.notifier)
                                        .removeCharacter(removeCharacter!);
                                    Navigator.pop(context);
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                            'You left something empty!'),
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
                                child: const Text('Remove Character'),
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

  void startNewCombatBottomSheet() {}
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Character> characters = ref.read(combatProvider).characters;
    int currentTurnIndex = ref.watch(combatProvider).currentTurnIndex;
    final oddItemColor = Theme.of(context).canvasColor;
    final evenItemColor = Colors.white.withOpacity(0.2);

    return Scaffold(
      appBar: AppBar(title: const Text('Combat Screen')),
      bottomNavigationBar: CombatBottomNavBar(),
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
                      addRemoveCharacterBottomSheet(context, ref, characters);
                    },
                    child: const Text('Add/Remove Character')),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () {}, child: const Text('Start New Combat')),
              ],
            ),
            const SizedBox(height: 20),
            // Pass the context to the currentTurnOrder method
            currentTurnOrder(
                context, characters, oddItemColor, evenItemColor, ref),
            const SizedBox(height: 40),
            currentTurn(context, characters, currentTurnIndex, ref),
            const Spacer(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget currentTurnOrder(BuildContext context, List<Character> characters,
      Color oddItemColor, Color evenItemColor, WidgetRef ref) {
    return SizedBox(
      height: 300,
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

  Widget currentTurn(context, List<Character> characters, int currentTurnIndex,
      WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Current Turn: ${characters[currentTurnIndex].name}',
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
          Text(
            'Health: ${characters[currentTurnIndex].health}/${characters[0].maxHealth}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    attackBottomSheet(
                        context, characters, ref, currentTurnIndex);
                  },
                  child: const Text('Attack')),
              const SizedBox(width: 20),
              ElevatedButton(
                  onPressed: () {
                    healBottomSheet(context, characters, ref);
                  },
                  child: const Text('Heal')),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(combatProvider.notifier)
                  .nextTurn(); // Advance turn order
            },
            child: const Text('Advance Turn'),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
