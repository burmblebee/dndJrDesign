import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CharacterSheet extends StatefulWidget {
  final String characterID;
  const CharacterSheet({Key? key, required this.characterID}) : super(key: key);

  @override
  _CharacterSheetState createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet> {
  Map<String, dynamic>? characterData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCharacterData();
  }

  Future<void> _fetchCharacterData() async {
    try {
      DocumentSnapshot characterSnapshot = await FirebaseFirestore.instance
          .collection('characters')
          .doc(widget.characterID)
          .get();

      setState(() {
        characterData = characterSnapshot.data() as Map<String, dynamic>?;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching character data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addSpell() async {
    TextEditingController spellNameController = TextEditingController();
    TextEditingController spellLevelController = TextEditingController();
    TextEditingController spellDescriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Spell"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: spellNameController,
                decoration: const InputDecoration(labelText: "Spell Name"),
              ),
              TextField(
                controller: spellLevelController,
                decoration: const InputDecoration(labelText: "Spell Level"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: spellDescriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (spellNameController.text.isNotEmpty &&
                    spellLevelController.text.isNotEmpty) {
                  Map<String, dynamic> newSpell = {
                    "name": spellNameController.text,
                    "level": int.tryParse(spellLevelController.text) ?? 0,
                    "description": spellDescriptionController.text,
                  };

                  List<dynamic> updatedSpells =
                      List.from(characterData?["spells"] ?? []);
                  updatedSpells.add(newSpell);

                  await FirebaseFirestore.instance
                      .collection('characters')
                      .doc(widget.characterID)
                      .update({"spells": updatedSpells});

                  setState(() {
                    characterData?["spells"] = updatedSpells;
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(characterData?['name'] ?? 'Character Sheet')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 5,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Stats'),
                      Tab(text: 'Skills'),
                      Tab(text: 'Spells'),
                      Tab(child: Text('Combat'),),
                      Tab(text: 'Traits'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildStatsTab(),
                        _buildSkillsTab(),
                        _buildSpellsTab(),
                        _buildCombatTab(),
                        _buildTraitsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSpellsTab() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _addSpell,
            child: const Text("Add Spell"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: (characterData?["spells"] as List<dynamic>?)?.length ?? 0,
              itemBuilder: (context, index) {
                var spell = characterData?["spells"][index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(spell["name"] ?? "Unknown Spell"),
                    subtitle: Text("Level: ${spell["level"]}\n${spell["description"]}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    return Center(child: Text("Stats Placeholder"));
  }

  Widget _buildSkillsTab() {
    return Center(child: Text("Skills & Saves Placeholder"));
  }

  Widget _buildTraitsTab() {
    // Placeholder for traits tab, if needed in the future
    return Center(child: Text("Traits Placeholder"));
  }

  Widget _buildCombatTab() {
    // Placeholder for combat tab, if needed in the future
    return Center(child: Text("Combat Placeholder"));
  }
}
