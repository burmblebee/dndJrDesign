import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/combat/premade_attacks.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/combat_nav_bar.dart';
import '../dice/diceRoller.dart';
import '../npc/npc.dart';
import '../npc/npc_provider.dart';
import 'attack_roll.dart';
import 'combat_character.dart';
import 'combat_provider.dart';
import 'firestore_service.dart';

class PlayerCombatScreen extends ConsumerWidget {
  PlayerCombatScreen({super.key, required this.campaignId});
  final String campaignId;
  late CombatCharacter playerCharacter;

  void attackBottomSheet(BuildContext context, List<CombatCharacter> characters,
      WidgetRef ref, int currentTurnIndex, String campaignId) {
    String? selectedCharacter;
    String? selectedCharacterId;
    final FirestoreService firestoreService = FirestoreService();

    void handleRollComplete(int total) {
      ref.read(diceRollProvider.notifier).state = total;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            int damage = ref.watch(diceRollProvider);

            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                List<Map<String, String>> characterList = characters
                    .where((character) => character.health > 0)
                    .map((character) => {
                  'name': character.name
                })
                    .toList();

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
                                items: characterList.map((char) {
                                  return DropdownMenuItem<String>(
                                    value: char['name'],
                                    child: Text(char['name']!),
                                    onTap: () {
                                      selectedCharacterId = char['id']; // Save the character's Firestore ID
                                    },
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PremadeAttack(
                                            campaignId: campaignId,
                                            attackOptions: characters[currentTurnIndex].attacks,
                                            onRollComplete: handleRollComplete,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Premade Attack'),
                                  ),
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
                                            TextButton(
                                              onPressed: () {
                                                ref.read(diceRollProvider.notifier).state = damage;
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: const Text('Enter Damage'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AttackRoll(
                                        campaignId: campaignId,
                                        onRollComplete: handleRollComplete,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Roll for Damage'),
                              ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      ref.read(diceRollProvider.notifier).state = 0;
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (selectedCharacter != null) {
                                        int newHealth = characters
                                            .firstWhere((char) => char.name == selectedCharacter)
                                            .health - damage;

                                        await firestoreService.updateCharacterHealth(campaignId, selectedCharacter!, newHealth);

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
      },
    );
  }

  void healBottomSheet(
      BuildContext context, List<CombatCharacter> characters, WidgetRef ref, String campaignId) {
    CombatCharacter? selectedCharacter;
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
                          DropdownButton<CombatCharacter>( // Using Character directly
                            hint: const Text("Select a Character"),
                            value: selectedCharacter,
                            items: characters.map((character) {
                              return DropdownMenuItem<CombatCharacter>(
                                value: character,
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
                                onPressed: () async {
                                  if (selectedCharacter != null && healedAmount > 0) {
                                    int newHealth = selectedCharacter!.health + healedAmount;

                                    // Cap healing at max health
                                    newHealth = newHealth > selectedCharacter!.maxHealth
                                        ? selectedCharacter!.maxHealth
                                        : newHealth;

                                    // Update character health in Firestore
                                    await FirestoreService().updateCharacterHealth(
                                        campaignId, selectedCharacter!.name, newHealth);

                                    // Update the health locally (using ref.read() for StateNotifier)
                                    ref.read(combatProvider(campaignId).notifier).updateHealth(
                                        selectedCharacter!.name, newHealth);

                                    Navigator.pop(context);
                                  } else {
                                    // Show alert if no character selected or invalid healing
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Invalid Input'),
                                        content: Text(
                                          selectedCharacter == null
                                              ? 'No character selected!'
                                              : 'Healing amount must be greater than 0!',
                                        ),
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
    //TODO: Get character for that player
    playerCharacter = CombatCharacter(
      name: 'Suffering',
      health: 100,
      maxHealth: 100,
      armorClass: 15,
      attacks: [],
      isNPC: false
    );
    final combatState = ref.watch(combatProvider(campaignId));

    final characters = combatState.characters;
    final currentTurnIndex = combatState.currentTurnIndex;

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
            currentTurnOrder(context, ref, oddItemColor, evenItemColor),
             const SizedBox(height: 20),
            const SizedBox(height: 40),
            currentTurn(context, characters, currentTurnIndex, ref),
            const Spacer(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget currentTurnOrder(BuildContext context, WidgetRef ref, Color oddItemColor, Color evenItemColor) {
    final characters = ref.watch(combatProvider(campaignId)).characters; // Live updates

    return SizedBox(
      height: 300,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: [
          for (int index = 0; index < characters.length; index++)
            Container(
              key: ValueKey(characters[index]),
              decoration: BoxDecoration(
                color: (characters[index].health > 0)
                    ? (index.isEven ? evenItemColor : oddItemColor)
                    : Colors.red.withOpacity(0.5),
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
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget currentTurn(context, List<CombatCharacter> characters, int currentTurnIndex,
      WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 200,
      //full screen width
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: (characters[currentTurnIndex].health > 0)
            ? Colors.grey[800]
            : Colors.red.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Current Turn: ${characters[currentTurnIndex].name}',
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
          if (characters[currentTurnIndex].name == playerCharacter.name)
            Column(
              children: [
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
                              context, characters, ref, currentTurnIndex, campaignId);
                        },
                        child: const Text('Attack')),
                    const SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: () {
                          healBottomSheet(
                              context, characters, ref, campaignId);
                        },
                        child: const Text('Heal')),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    ref.read(combatProvider(campaignId).notifier).nextTurn();
                  },
                  child: const Text('Advance Turn'),
                ),
              ],
            ),

          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
