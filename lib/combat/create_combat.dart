import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../npc/npc.dart';

class AddCombat extends StatefulWidget {
  const AddCombat({super.key, required this.campaignId});
  final String campaignId;

  @override
  State<AddCombat> createState() => _AddCombatState();
}

class _AddCombatState extends State<AddCombat> {
  TextEditingController combatNameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  List<NPC> npcs = []; // Initialize empty list
  List<bool> isSelected = [];

  @override
  void initState() {
    super.initState();
    fetchNPCs(); // Call once when widget initializes
  }

  Future<void> fetchNPCs() async {
    try {
      final querySnapshot = await _firestore
          .collection('app_user_profiles')
          .doc(userId)
          .collection('npcs')
          .get();

      setState(() {
        npcs = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return NPC(
            id: doc.id,
            name: data['name'],
            attacks: (data['attacks'] as List<dynamic>).map((attack) {
              return AttackOption(
                name: attack['name'],
                diceConfig: List<int>.from(attack['diceConfig']),
              );
            }).toList(),
            maxHealth: data['maxHealth'],
            ac: data['ac'],
          );
        }).toList();

        isSelected = List.filled(npcs.length, false); // Initialize selection list
      });
    } catch (e) {
      print("Error fetching NPCs: $e");
    }
  }

  Future<void> saveCombat() async {
    await _firestore.collection('user_campaigns').doc(widget.campaignId).collection('combats').doc().set({
      'name': combatNameController.text,
      'npcs': npcs.where((npc) => isSelected[npcs.indexOf(npc)]).map((npc) => npc.toMap()).toList(),
    });
  }



  @override
  Widget build(BuildContext context) {
    final existingNames = npcs.where((npc) => isSelected[npcs.indexOf(npc)]).map((npc) => npc.name).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Add Combat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Add Combat', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),

            // Combat Name Input
            TextField(
              controller: combatNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Combat Name',
              ),
            ),
            const SizedBox(height: 10),

            // Show NPCs or "No NPCs Found"
            npcs.isEmpty
                ? const Center(child: Text('No NPCs found'))
                : Expanded(
              child: ListView.builder(
                itemCount: npcs.length,
                itemBuilder: (context, i) {
                  return CheckboxListTile(
                    title: Text(npcs[i].name),
                    value: isSelected[i],
                    onChanged: (bool? value) {
                      if (existingNames
                          .contains(npcs[i])) {
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
                      setState(() {
                        isSelected[i] = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Create Combat Button
            ElevatedButton(
              onPressed: () {
                saveCombat();
                Navigator.pop(context);
              },
              child: const Text('Create Combat'),
            ),
          ],
        ),
      ),
    );
  }
}
