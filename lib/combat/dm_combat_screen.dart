import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class DMCombatScreen extends ConsumerWidget {
  const DMCombatScreen({super.key, required this.campaignId});
  final String campaignId;

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
                    .map((character) => {'name': character.name})
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
                                items: characterList.map((char) {
                                  return DropdownMenuItem<String>(
                                    value: char['name'],
                                    child: Text(char['name']!),
                                    onTap: () {
                                      selectedCharacterId = char[
                                          'id']; // Save the character's Firestore ID
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PremadeAttack(
                                            campaignId: campaignId,
                                            attackOptions:
                                                characters[currentTurnIndex]
                                                    .attacks,
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
                                                damage =
                                                    int.tryParse(value) ?? 0;
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
                                                ref
                                                    .read(diceRollProvider
                                                        .notifier)
                                                    .state = damage;
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      ref
                                          .read(diceRollProvider.notifier)
                                          .state = 0;
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (selectedCharacter != null) {
                                        int newHealth = characters
                                                .firstWhere((char) =>
                                                    char.name ==
                                                    selectedCharacter)
                                                .health -
                                            damage;

                                        await firestoreService
                                            .updateCharacterHealth(campaignId,
                                                selectedCharacter!, newHealth);
                                        ref
                                            .read(combatProvider(campaignId)
                                                .notifier)
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
        );
      },
    );
  }

  void healBottomSheet(BuildContext context, List<CombatCharacter> characters,
      WidgetRef ref, String campaignId) {
    CombatCharacter? selectedCharacter;
    int healedAmount = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
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
                            DropdownButton<CombatCharacter>(
                              // Using Character directly
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
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (selectedCharacter != null &&
                                        healedAmount > 0) {
                                      int newHealth =
                                          selectedCharacter!.health +
                                              healedAmount;

                                      // Cap healing at max health
                                      newHealth = newHealth >
                                              selectedCharacter!.maxHealth
                                          ? selectedCharacter!.maxHealth
                                          : newHealth;

                                      // Update character health in Firestore
                                      await FirestoreService()
                                          .updateCharacterHealth(
                                              campaignId,
                                              selectedCharacter!.name,
                                              newHealth);

                                      ref
                                          .read(combatProvider(campaignId)
                                              .notifier)
                                          .updateHealth(selectedCharacter!.name,
                                              newHealth);

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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void addRemoveCharacterBottomSheet(BuildContext context,
      List<CombatCharacter> characters, WidgetRef ref, String campaignId) {
    String? selectedName;
    int? hp, maxHealth, ac;
    String? npc;
    String? selectedCharacter;

    final npcState = ref.watch(npcProvider); // Watch the NPC state
    final existingNames = characters.map((c) => c.name).toSet();
    debugPrint("NPCs available: ${npcState.npcs.map((e) => e.name).toList()}");
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
                          DropdownButton<String>(
                            hint: const Text("Select a Character"),
                            value: (npcState.npcs.any((n) => n.name == npc)
                                ? npc
                                : null), // Ensure valid selection
                            items: npcState.npcs
                                .map((npc) => DropdownMenuItem<String>(
                                      value: npc.name,
                                      child: Text(npc.name),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                npc = value;
                              });
                            },
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (selectedName != null &&
                                      selectedName!.isNotEmpty &&
                                      hp != null &&
                                      hp! > 0 &&
                                      maxHealth != null &&
                                      maxHealth! > 0 &&
                                      ac != null &&
                                      ac! > 0) {
                                    // Add character to Firestore and update state
                                    if (existingNames.contains(selectedName!)) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              'Character already exists!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
                                    }
                                    await FirestoreService()
                                        .addCharacterToCampaign(
                                            campaignId,
                                            selectedName!,
                                            hp!,
                                            maxHealth!,
                                            ac!,
                                            [],
                                            true);

                                    ref
                                        .read(
                                            combatProvider(campaignId).notifier)
                                        .addCharacter(CombatCharacter(
                                            name: selectedName!,
                                            health: hp!,
                                            maxHealth: maxHealth!,
                                            armorClass: ac!,
                                            attacks: [],
                                            isNPC: true));
                                    Navigator.pop(context);
                                  } else if (npc != null && npc!.isNotEmpty) {
                                    NPC selectedNpc = npcState.npcs
                                        .firstWhere((n) => n.name == npc);

                                    // Add NPC to Firestore and update state
                                    if (existingNames
                                        .contains(selectedNpc.name)) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              'This NPC is already added!'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
                                    }

                                    await FirestoreService()
                                        .addCharacterToCampaign(
                                            campaignId,
                                            selectedNpc.name,
                                            selectedNpc.maxHealth,
                                            selectedNpc.maxHealth,
                                            selectedNpc.ac,
                                            selectedNpc.attacks,
                                            true);

                                    ref
                                        .read(
                                            combatProvider(campaignId).notifier)
                                        .addCharacter(CombatCharacter(
                                            name: selectedNpc.name,
                                            health: selectedNpc.maxHealth,
                                            maxHealth: selectedNpc.maxHealth,
                                            armorClass: selectedNpc.ac,
                                            attacks: selectedNpc.attacks,
                                            isNPC: true));
                                    Navigator.pop(context);
                                  } else {
                                    // Show error if nothing is selected
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

                          // Remove Character
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
                            value:
                                selectedCharacter, // Use this instead of selectedName
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (selectedCharacter != null &&
                                      selectedCharacter!.isNotEmpty) {
                                    // Remove character from Firestore and update state
                                    await FirestoreService()
                                        .removeCharacterFromCampaign(
                                            campaignId, selectedCharacter!);
                                    ref
                                        .read(
                                            combatProvider(campaignId).notifier)
                                        .removeCharacter(selectedName!);
                                    Navigator.pop(context);
                                  } else {
                                    // Show error if nothing is selected
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

  Future<List<String>> fetchCombatNames(String campaignId) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot combatDocs = await _firestore
          .collection('user_campaigns')
          .doc(campaignId)
          .collection('combats')
          .get();

      // Extract combat names
      List<String> combatNames =
          combatDocs.docs.map((doc) => doc['name'] as String).toList();

      return combatNames;
    } catch (e) {
      print("Error fetching combats: $e");
      return [];
    }
  }

//TODO: Implement this function
  Future<void> startNewCombatBottomSheet(BuildContext context) async {
    List<String> combats = await fetchCombatNames(campaignId);
    String? selectedCombat;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
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
                        child: Center(
                          child: Column(
                            children: [
                              const Text(
                                'Select a Combat to Start',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                              DropdownButton(
                                  items: combats
                                      .map((combat) => DropdownMenuItem<String>(
                                            value: combat,
                                            child: Text(combat),
                                          ))
                                      .toList(),
                                  value: selectedCombat,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCombat = value;
                                    });
                                  }),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                  //TODO: Start a new combat with only player characters
                                  onPressed: () {},
                                  child: Text('Reset Combat with No NPCs')),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel')),
                                  ElevatedButton(
                                      //TODO: Start new combat with selected combat
                                      onPressed: () {},
                                      child: Text('Start New Combat')),
                                ],
                              ),
                              SizedBox(height: 50)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
    final npcState = ref.watch(npcProvider);
    final npcNotifier = ref.read(npcProvider.notifier);

    if (npcState.npcs.isEmpty) {
      Future.microtask(() => npcNotifier.fetchNPCs());
    }

    List<CombatCharacter> characters =
        ref.watch(combatProvider(campaignId)).characters;
    int currentTurnIndex =
        ref.watch(combatProvider(campaignId)).currentTurnIndex;
    final oddItemColor = Theme.of(context).canvasColor;
    final evenItemColor = Color(0xFFD4C097).withOpacity(0.5);

    return Scaffold(
      appBar: AppBar(title: const Text('Combat Screen')),
      bottomNavigationBar: CombatBottomNavBar(
        campaignId: campaignId,
        isDM: true,
      ),
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
                    addRemoveCharacterBottomSheet(
                        context, characters, ref, campaignId);
                  },
                  child: const Text('Add/Remove Character'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    await startNewCombatBottomSheet(context);
                  },
                  child: const Text('Start New Combat'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Combat turn order list
            currentTurnOrder(context, characters, oddItemColor, evenItemColor,
                ref, campaignId),
            const SizedBox(height: 40),

            // Display current turn character
            currentTurn(context, characters, currentTurnIndex, ref, campaignId),
            const Spacer(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget currentTurnOrder(
      BuildContext context,
      List<CombatCharacter> characters,
      Color oddItemColor,
      Color evenItemColor,
      WidgetRef ref,
      String campaignId) {
    return SizedBox(
      height: 300,
      child: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: [
          for (int index = 0; index < characters.length; index++)
            Container(
              key: ValueKey(characters[index].name), // Use name for unique key
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
              .read(combatProvider(campaignId).notifier)
              .reorderCharacters(oldIndex, newIndex);
        },
      ),
    );
  }

  Widget currentTurn(BuildContext context, List<CombatCharacter> characters,
      int currentTurnIndex, WidgetRef ref, String campaignId) {
    if (characters.isEmpty) {
      return const Center(
        child: Text(
          'No characters in combat',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 200,
      decoration: BoxDecoration(
        color: (characters[currentTurnIndex].health > 0)
            ? Color(0xFFD4C097).withOpacity(0.5)
            : Colors.red.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Current Turn: ${characters[currentTurnIndex].name}',
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
          Text(
            'Health: ${characters[currentTurnIndex].health}/${characters[currentTurnIndex].maxHealth}',
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
                    healBottomSheet(context, characters, ref, campaignId);
                  },
                  child: const Text('Heal')),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              ref.read(combatProvider(campaignId).notifier).nextTurn();
            },
            child: const Text('Advance Turn'),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
