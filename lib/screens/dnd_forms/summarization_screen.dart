import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/providers/character_provider.dart';
import 'package:warlocks_of_the_beach/widgets/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import 'package:warlocks_of_the_beach/widgets/dnd_form_widgets/spell_tile.dart';
import 'package:warlocks_of_the_beach/data/spell and cantrips/spell_data.dart';

class SummarizationScreen extends ConsumerWidget {
  const SummarizationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);

    return Scaffold(
      appBar: MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Character Summary',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            _buildSummaryTile(context, 'Name', character.name),
            _buildSummaryTile(context, 'Race', character.race),
            _buildSummaryTile(context, 'Class', character.characterClass),
            _buildSummaryTile(context, 'Background', character.background),
            _buildSummaryTile(context, 'Alignment', character.traits['alignment'] ?? ''),
            _buildSummaryTile(context, 'Faith', character.traits['faith'] ?? ''),
            _buildSummaryTile(context, 'Lifestyle', character.traits['lifestyle'] ?? ''),
            _buildSummaryTile(context, 'Hair', character.traits['hair'] ?? ''),
            _buildSummaryTile(context, 'Eyes', character.traits['eyes'] ?? ''),
            _buildSummaryTile(context, 'Skin', character.traits['skin'] ?? ''),
            _buildSummaryTile(context, 'Height', character.traits['height'] ?? ''),
            _buildSummaryTile(context, 'Weight', character.traits['weight'] ?? ''),
            _buildSummaryTile(context, 'Age', character.traits['age'] ?? ''),
            _buildSummaryTile(context, 'Gender', character.traits['gender'] ?? ''),
            _buildSummaryTile(context, 'Personality Traits', character.traits['personalityTraits'] ?? ''),
            _buildSummaryTile(context, 'Ideals', character.traits['ideals'] ?? ''),
            _buildSummaryTile(context, 'Bonds', character.traits['bonds'] ?? ''),
            _buildSummaryTile(context, 'Flaws', character.traits['flaws'] ?? ''),
            _buildSummaryTile(context, 'Organizations', character.traits['organization'] ?? ''),
            _buildSummaryTile(context, 'Allies', character.traits['allies'] ?? ''),
            _buildSummaryTile(context, 'Enemies', character.traits['enemies'] ?? ''),
            _buildSummaryTile(context, 'Backstory', character.traits['backstory'] ?? ''),
            _buildSummaryTile(context, 'Other', character.traits['other'] ?? ''),
            const SizedBox(height: 20),
            Text(
              'Stats',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            _buildSummaryTile(context, 'Strength', character.abilityScores['Strength'].toString()),
            _buildSummaryTile(context, 'Dexterity', character.abilityScores['Dexterity'].toString()),
            _buildSummaryTile(context, 'Constitution', character.abilityScores['Constitution'].toString()),
            _buildSummaryTile(context, 'Intelligence', character.abilityScores['Intelligence'].toString()),
            _buildSummaryTile(context, 'Wisdom', character.abilityScores['Wisdom'].toString()),
            _buildSummaryTile(context, 'Charisma', character.abilityScores['Charisma'].toString()),
            const SizedBox(height: 20),
            Text(
              'Weapons',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Column(
              children: character.weapons.map((weapon) => _buildSummaryTile(context, 'Weapon', weapon)).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Cantrips',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Column(
              children: character.cantrips.map((cantrip) => _buildCantripTile(context, cantrip)).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Spells',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Column(
              children: character.spells.map((spell) => _buildSpellTile(context, spell)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTile(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        tileColor: Theme.of(context).listTileTheme.tileColor,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildSpellTile(BuildContext context, String spell) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        tileColor: Theme.of(context).listTileTheme.tileColor,
        title: Text(
          spell,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: IconButton(
          icon: Icon(Icons.info_outline, color: Theme.of(context).iconTheme.color),
          onPressed: () => _showSpellInfoDialog(context, spell),
        ),
      ),
    );
  }

  Widget _buildCantripTile(BuildContext context, String cantrip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        tileColor: Theme.of(context).listTileTheme.tileColor,
        title: Text(
          cantrip,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: IconButton(
          icon: Icon(Icons.info_outline, color: Theme.of(context).iconTheme.color),
          onPressed: () => _showCantripInfoDialog(context, cantrip),
        ),
      ),
    );
  }

  Future<void> _showSpellInfoDialog(BuildContext context, String spellName) async {
    final spellData = await _getSpellData(spellName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            spellName,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  spellData['description'] ?? 'No description available',
                  style: const TextStyle(color: Colors.white),
                ),
                const Divider(height: 30, color: Colors.grey),
                Text(
                  'Range: ${spellData['range'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Components: ${spellData['components']?.join(', ') ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Duration: ${spellData['duration'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Level: ${spellData['level'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'School: ${spellData['school'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Cast Time: ${spellData['castTime'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }

  Future<void> _showCantripInfoDialog(BuildContext context, String cantripName) async {
    final cantripData = await _getCantripData(cantripName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            cantripName,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cantripData['description'] ?? 'No description available',
                  style: const TextStyle(color: Colors.white),
                ),
                const Divider(height: 30, color: Colors.grey),
                Text(
                  'Range: ${cantripData['range'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Components: ${cantripData['components']?.join(', ') ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Duration: ${cantripData['duration'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Level: ${cantripData['level'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'School: ${cantripData['school'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Cast Time: ${cantripData['castTime'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _getSpellData(String spellName) async {
    // Replace this with your actual logic to fetch the spell data
    // For example, you might fetch it from a JSON file or a database
    return spellsByClass['Wizard']?['FirstLevel']?.firstWhere((spell) => spell['name'] == spellName, orElse: () => {}) ?? {};
  }

  Future<Map<String, dynamic>> _getCantripData(String cantripName) async {
    // Replace this with your actual logic to fetch the cantrip data
    // For example, you might fetch it from a JSON file or a database
    return spellsByClass['Wizard']?['Cantrips']?.firstWhere((cantrip) => cantrip['name'] == cantripName, orElse: () => {}) ?? {};
  }
}