import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:warlocks_of_the_beach/providers/character_provider.dart';
import 'package:warlocks_of_the_beach/widgets/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import 'package:warlocks_of_the_beach/screens/campaign_screen.dart';

class SummarizationScreen extends ConsumerWidget {
  const SummarizationScreen({Key? key}) : super(key: key);

  Future<void> _sendCharacterDataToFirestore(
      BuildContext context, WidgetRef ref) async {
    final character = ref.read(characterProvider);
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    } else {
      final User user = FirebaseAuth.instance.currentUser!;
      final uuid = user.uid;
      final String characterId = const Uuid().v4();



      final characterData = {
        'name': character.name,
        'race': character.race,
        'class': character.characterClass,
        'background': character.background,
        'alignment': character.traits['alignment'] ?? '',
        'faith': character.traits['faith'] ?? '',
        'lifestyle': character.traits['lifestyle'] ?? '',
        'hair': character.traits['hair'] ?? '',
        'eyes': character.traits['eyes'] ?? '',
        'skin': character.traits['skin'] ?? '',
        'height': character.traits['height'] ?? '',
        'weight': character.traits['weight'] ?? '',
        'age': character.traits['age'] ?? '',
        'gender': character.traits['gender'] ?? '',
        'personalityTraits': character.traits['personalityTraits'] ?? '',
        'ideals': character.traits['ideals'] ?? '',
        'bonds': character.traits['bonds'] ?? '',
        'flaws': character.traits['flaws'] ?? '',
        'organizations': character.traits['organization'] ?? '',
        'allies': character.traits['allies'] ?? '',
        'enemies': character.traits['enemies'] ?? '',
        'backstory': character.traits['backstory'] ?? '',
        'other': character.traits['other'] ?? '',
        'proficiencies': character.proficiencies,
        'languages': character.languages,
        'abilityScores': {
          'Strength': character.abilityScores['Strength'],
          'Dexterity': character.abilityScores['Dexterity'],
          'Constitution': character.abilityScores['Constitution'],
          'Intelligence': character.abilityScores['Intelligence'],
          'Wisdom': character.abilityScores['Wisdom'],
          'Charisma': character.abilityScores['Charisma'],
        },
        'weapons': character.weapons,
        'cantrips': character.cantrips,
        'spells': character.spells,
        // Equipment selections using unified field names.
        'startingKit': character.selectedKit,
        'startingArmor': character.selectedArmor ?? 'Robes',
        'selectedEquipment': character.selectedEquipment,
        'level': 1, // Hard-coded until leveling up functionality is added.
        'hp' : calculateHP(character.characterClass, character.abilityScores['Constitution']),
        'ac' : 0,
        'hitDice' : calculateHitDice(character.characterClass),
      };


      try {
        await FirebaseFirestore.instance
            .collection('app_user_profiles')
            .doc(uuid)
            .collection('characters')
            .doc(characterId)
            .set(characterData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Character saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save character data: $e')),
        );
      }
    }
  }

  String calculateHitDice(String characterClass) {
  switch (characterClass) {
    case "Barbarian":
      return "1d12"; // Barbarian uses a d12 for hit dice
    case "Fighter":
    case "Paladin":
    case "Ranger":
      return "1d10"; // Fighter, Paladin, and Ranger use a d10 for hit dice
    case "Bard":
    case "Cleric":
    case "Druid":
    case "Monk":
    case "Rogue":
    case "Warlock":
      return "1d8"; // Bard, Cleric, Druid, Monk, Rogue, and Warlock use a d8 for hit dice
    case "Sorcerer":
    case "Wizard":
      return "1d6"; // Sorcerer and Wizard use a d6 for hit dice
    default:
      return "Unknown Hit Dice"; // Default case for unknown or unsupported classes
  }
}

  String calculateHP(String characterClass, int constitution) {
    //calcualte the constituion modifier
    int constitutionModifier = ((constitution - 10) / 2).floor();

   


    switch (characterClass) {
      case "Barbarian":
        return (12 + constitutionModifier).toString();
      case "Bard":
        return (8 + constitutionModifier).toString();
      case "Cleric":
        return (8 + constitutionModifier).toString();
      case "Druid":
        return (8 + constitutionModifier).toString();
      case "Fighter":
        return (10 + constitutionModifier).toString();
      case "Monk":
        return (8 + constitutionModifier).toString();
      case "Paladin":
        return (10 + constitutionModifier).toString();
      case "Ranger":
        return (10 + constitutionModifier).toString();
      case "Rogue":
        return (8 + constitutionModifier).toString();
      case "Sorcerer":
        return (6 + constitutionModifier).toString();
      case "Warlock":
        return (8 + constitutionModifier).toString();
      case "Wizard":
        return (6 + constitutionModifier).toString();
      default:
        return 'Unknown Class';
    }
  } 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(characterProvider);

    // If no armor is provided, assume "Robes".
    final startingArmor = (character.selectedArmor == null || character.selectedArmor!.isEmpty)
        ? "Robes"
        : character.selectedArmor;

    // Assuming starting kit is stored as a List<String>.
    final kitDisplay = (character.selectedKit is List<String>)
        ? (character.selectedKit as List<String>).join(", ")
        : character.selectedKit.toString();

    return Scaffold(
      appBar: MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  children: character.weapons
                      .map((weapon) => _buildSummaryTile(context, 'Weapon', weapon))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Spells & Cantrips',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                if (character.cantrips.isNotEmpty) ...[
                  Text(
                    'Cantrips',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Column(
                    children: character.cantrips
                        .map((cantrip) => _buildMagicTile(context, cantrip))
                        .toList(),
                  ),
                ],
                if (character.spells.isNotEmpty) ...[
                  const SizedBox(height: 15),
                  Text(
                    'Level 1 Spells',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Column(
                    children: character.spells
                        .map((spell) => _buildMagicTile(context, spell))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  'Starting Equipment',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                _buildSummaryTile(context, 'Armor', startingArmor?? ''),
                _buildSummaryTile(context, 'Kit/Instrument', kitDisplay),
                const SizedBox(height: 100), // Add extra space to prevent overlap
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text("Back"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _sendCharacterDataToFirestore(context, ref);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CampaignScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text("Finish"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildMagicTile(BuildContext context, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        tileColor: Theme.of(context).listTileTheme.tileColor,
        title: Text(
          name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
