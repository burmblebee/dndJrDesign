import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/rpg_awesome_icons.dart';
import 'package:warlocks_of_the_beach/screens/character_sheet/popup_dice_roller.dart';
import 'package:warlocks_of_the_beach/widgets/editable_text_field.dart';
import '../../services/spell_service.dart';
import '../../services/class_service.dart';

class CharacterSheet extends StatefulWidget {
  final String characterID;
  final bool inSession;
  const CharacterSheet(
      {Key? key, required this.characterID, required this.inSession})
      : super(key: key);

  @override
  _CharacterSheetState createState() => _CharacterSheetState();
}

class _CharacterSheetState extends State<CharacterSheet>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool canPop = false;
  Map<String, dynamic>? characterData;
  bool isLoading = true;
  final Map<String, String> _spellDescriptionCache = {};
  String errorMessage = '';
  Set<String> selectedSpells = {};
  Set<String> selectedCantrips = {};
  Set<String> selectedWeapons = {};
  String strengthScore = '10';
  String dexterityScore = '10';
  String constitutionScore = '10';
  String intelligenceScore = '10';
  String wisdomScore = '10';
  String charismaScore = '10';
  String strengthModifier = '0';
  String dexterityModifier = '0';
  String constitutionModifier = '0';
  String intelligenceModifier = '0';
  String wisdomModifier = '0';
  String charismaModifier = '0';
  int armorClass = 0; // New variable to store the final AC
  Set<String> proficiencies = {};
  Set<String> languages = {};
  final int proficiencyBonus = 2;
  String characterClass = '';
  String background = '';
  String alignment = '';
  String faith = '';
  String lifestyle = '';
  String hair = '';
  String eyes = '';
  String skin = '';
  String height = '';
  String weight = '';
  String age = '';
  String gender = '';
  String personalityTraits = '';
  String ideals = '';
  String bonds = '';
  String flaws = '';
  String organizations = '';
  String allies = '';
  String enemies = '';
  String backstory = '';
  String other = '';
  String userPack = '';
  String hp = '';
  String ac = '';
  String hitDice = '';

  final Map<String, String> packDescriptions = {
    "Scholar’s Pack":
        "backpack, book of lore, ink and quill, and a small knife",
    "Dungeoneer’s Pack":
        "backpack, crowbar, hammer, 10 pitons, 10 torches, 5 days of rations, 50 feet of hempen rope",
    "Explorer’s Pack":
        "backpack, bedroll, mess kit, tinderbox, 10 torches, 10 days of rations, 50 feet of hempen rope",
    "Priest’s Pack":
        "backpack, prayer book, incense (5 sticks), vestments for religious ceremonies",
    "Entertainer’s Pack": "backpack, costume, disguise kit",
    "Burglar’s Pack":
        "backpack, crowbar, hammer, 10 pitons, 10 torches, and 5 days of rations"
  };

  final Map<String, List<String>> classSavingThrowProficiencies = {
    "Barbarian": ["Strength", "Constitution"],
    "Bard": ["Dexterity", "Charisma"],
    "Cleric": ["Wisdom", "Charisma"],
    "Druid": ["Intelligence", "Wisdom"],
    "Fighter": ["Strength", "Constitution"],
    "Monk": ["Strength", "Dexterity"],
    "Paladin": ["Wisdom", "Charisma"],
    "Ranger": ["Strength", "Dexterity"],
    "Rogue": ["Dexterity", "Intelligence"],
    "Sorcerer": ["Constitution", "Charisma"],
    "Warlock": ["Wisdom", "Charisma"],
    "Wizard": ["Intelligence", "Wisdom"],
  };
  final Map<String, TextEditingController> _traitsControllers = {};

  final List<String> _traitKeys = [
    'Background',
    'Alignment',
    'Faith',
    'Lifestyle',
    'Hair',
    'Eyes',
    'Skin',
    'Height',
    'Weight',
    'Age',
    'Gender',
    'Personality Traits',
    'Ideals',
    'Bonds',
    'Flaws',
    'Organizations',
    'Allies',
    'Enemies',
    'Backstory',
    'Other',
  ];

  final List<String> simpleWeapons = [
    'Club',
    'Dagger',
    'Greatclub',
    'Handaxe',
    'Javelin',
    'Light Hammer',
    'Mace',
    'Quarterstaff',
    'Sickle',
    'Spear',
    'Light Crossbow',
    'Dart',
    'Shortbow',
    'Sling',
    'Blowgun',
  ];

  final List<String> martialWeapons = [
    'Battleaxe',
    'Flail',
    'Glaive',
    'Greataxe',
    'Greatsword',
    'Halberd',
    'Lance',
    'Longsword',
    'Maul',
    'Morningstar',
    'Pike',
    'Rapier',
    'Scimitar',
    'Shortsword',
    'Trident',
    'War Pick',
    'Warhammer',
    'Whip',
    'Hand Crossbow',
    'Heavy Crossbow',
    'Longbow',
    'Net',
  ];

  final Map<String, String> simpleWeaponDamage = {
    'Club': '1d4',
    'Dagger': '1d4',
    'Greatclub': '2d4',
    'Handaxe': '1d6',
    'Javelin': '1d6',
    'Light Hammer': '1d4',
    'Mace': '1d6',
    'Quarterstaff': '1d6',
    'Sickle': '1d4',
    'Spear': '1d6',
    'Light Crossbow': '1d8',
    'Dart': '1d4',
    'Shortbow': '1d6',
    'Sling': '1d4',
    'Blowgun': '1',
  };

  final Map<String, String> martialWeaponDamage = {
    'Battleaxe': '1d8',
    'Flail': '1d8',
    'Glaive': '1d10',
    'Greataxe': '1d12',
    'Greatsword': '2d6',
    'Halberd': '1d10',
    'Lance': '1d12',
    'Longsword': '1d8',
    'Maul': '2d6',
    'Morningstar': '1d8',
    'Pike': '1d10',
    'Rapier': '1d8',
    'Scimitar': '1d6',
    'Shortsword': '1d6',
    'Trident': '1d6',
    'War Pick': '1d8',
    'Warhammer': '1d8',
    'Whip': '1d4',
    'Hand Crossbow': '1d6',
    'Heavy Crossbow': '1d10',
    'Longbow': '1d8',
    'Net': '0',
  };

  final Map<String, String> weaponModifiers = {
    'Club': 'Strength',
    'Dagger': 'Dexterity or Strength',
    'Greatclub': 'Strength',
    'Handaxe': 'Dexterity or Strength',
    'Javelin': 'Dexterity or Strength',
    'Light Hammer': 'Dexterity or Strength',
    'Mace': 'Strength',
    'Quarterstaff': 'Strength',
    'Sickle': 'Strength',
    'Spear': 'Dexterity or Strength',
    'Light Crossbow': 'Dexterity',
    'Dart': 'Dexterity',
    'Shortbow': 'Dexterity',
    'Sling': 'Dexterity',
    'Blowgun': 'Dexterity',
    'Battleaxe': 'Strength',
    'Flail': 'Strength',
    'Glaive': 'Strength',
    'Greataxe': 'Strength',
    'Greatsword': 'Strength',
    'Halberd': 'Strength',
    'Lance': 'Strength',
    'Longsword': 'Strength',
    'Maul': 'Strength',
    'Morningstar': 'Strength',
    'Pike': 'Strength',
    'Rapier': 'Dexterity',
    'Scimitar': 'Dexterity',
    'Shortsword': 'Dexterity',
    'Trident': 'Dexterity or Strength',
    'War Pick': 'Strength',
    'Warhammer': 'Strength',
    'Whip': 'Dexterity',
    'Hand Crossbow': 'Dexterity',
    'Heavy Crossbow': 'Dexterity',
    'Longbow': 'Dexterity',
    'Net': 'Dexterity',
  };

  @override
  void initState() {
    super.initState();
    _fetchCharacterData();
    _traitsControllers['Background'] = TextEditingController(text: background);
    _traitsControllers['Alignment'] = TextEditingController(text: alignment);
    _traitsControllers['Faith'] = TextEditingController(text: faith);
    _traitsControllers['Lifestyle'] = TextEditingController(text: lifestyle);
    _traitsControllers['Hair'] = TextEditingController(text: hair);
    _traitsControllers['Eyes'] = TextEditingController(text: eyes);
    _traitsControllers['Skin'] = TextEditingController(text: skin);
    _traitsControllers['Height'] = TextEditingController(text: height);
    _traitsControllers['Weight'] = TextEditingController(text: weight);
    _traitsControllers['Age'] = TextEditingController(text: age);
    _traitsControllers['Gender'] = TextEditingController(text: gender);
    _traitsControllers['Personality Traits'] =
        TextEditingController(text: personalityTraits);
    _traitsControllers['Ideals'] = TextEditingController(text: ideals);
    _traitsControllers['Bonds'] = TextEditingController(text: bonds);
    _traitsControllers['Flaws'] = TextEditingController(text: flaws);
    _traitsControllers['Organizations'] =
        TextEditingController(text: organizations);
    _traitsControllers['Allies'] = TextEditingController(text: allies);
    _traitsControllers['Enemies'] = TextEditingController(text: enemies);
    _traitsControllers['Backstory'] = TextEditingController(text: backstory);
    _traitsControllers['Other'] = TextEditingController(text: other);
  }

  Future<void> _fetchCharacterData() async {
    final User user = FirebaseAuth.instance.currentUser!;
    final uuid = user.uid;
    try {
      DocumentSnapshot characterSnapshot = await FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(uuid)
          .collection('characters')
          .doc(widget.characterID)
          .get();

      setState(() {
        characterData = characterSnapshot.data() as Map<String, dynamic>?;
        isLoading = false;

        proficiencies = Set<String>.from(characterData?["proficiencies"] ?? []);
        languages = Set<String>.from(characterData?["languages"] ?? []);
        final String characterClass = characterData?["class"] ?? "Unknown";

        // Set the scores for easy access.
        strengthScore =
            characterData?["abilityScores"]["Strength"]?.toString() ?? '10';
        dexterityScore =
            characterData?["abilityScores"]["Dexterity"]?.toString() ?? '10';
        constitutionScore =
            characterData?["abilityScores"]["Constitution"]?.toString() ?? '10';
        intelligenceScore =
            characterData?["abilityScores"]["Intelligence"]?.toString() ?? '10';
        wisdomScore =
            characterData?["abilityScores"]["Wisdom"]?.toString() ?? '10';
        charismaScore =
            characterData?["abilityScores"]["Charisma"]?.toString() ?? '10';

        // Calculate modifiers.
        strengthModifier = (strengthScore == '8' || strengthScore == '9')
            ? '-1'
            : ((int.parse(strengthScore) - 10) ~/ 2).toString();
        dexterityModifier = (dexterityScore == '8' || dexterityScore == '9')
            ? '-1'
            : ((int.parse(dexterityScore) - 10) ~/ 2).toString();
        constitutionModifier =
            (constitutionScore == '8' || constitutionScore == '9')
                ? '-1'
                : ((int.parse(constitutionScore) - 10) ~/ 2).toString();
        intelligenceModifier =
            (intelligenceScore == '8' || intelligenceScore == '9')
                ? '-1'
                : ((int.parse(intelligenceScore) - 10) ~/ 2).toString();
        wisdomModifier = (wisdomScore == '8' || wisdomScore == '9')
            ? '-1'
            : ((int.parse(wisdomScore) - 10) ~/ 2).toString();
        charismaModifier = (charismaScore == '8' || charismaScore == '9')
            ? '-1'
            : ((int.parse(charismaScore) - 10) ~/ 2).toString();

        // Set the selected spells, cantrips, and weapons.
        for (var spell in characterData?["spells"] ?? []) {
          selectedSpells.add(spell);
        }
        for (var cantrip in characterData?["cantrips"] ?? []) {
          selectedCantrips.add(cantrip);
        }
        for (var weapon in characterData?["weapons"] ?? []) {
          selectedWeapons.add(weapon);
        }
        hp = characterData?["hp"]?.toString() ?? '0';
        ac = characterData?["ac"]?.toString() ?? '0';
        hitDice = characterData?["hitDice"]?.toString() ?? '0';

        // --- Update Traits ---
        // Update your local trait variables.
        background = characterData?["background"]?.toString() ?? '';
        alignment = characterData?["alignment"]?.toString() ?? '';
        faith = characterData?["faith"]?.toString() ?? '';
        lifestyle = characterData?["lifestyle"]?.toString() ?? '';
        hair = characterData?["hair"]?.toString() ?? '';
        eyes = characterData?["eyes"]?.toString() ?? '';
        skin = characterData?["skin"]?.toString() ?? '';
        height = characterData?["height"]?.toString() ?? '';
        weight = characterData?["weight"]?.toString() ?? '';
        age = characterData?["age"]?.toString() ?? '';
        gender = characterData?["gender"]?.toString() ?? '';
        personalityTraits =
            characterData?["personalityTraits"]?.toString() ?? '';
        ideals = characterData?["ideals"]?.toString() ?? '';
        bonds = characterData?["bonds"]?.toString() ?? '';
        flaws = characterData?["flaws"]?.toString() ?? '';
        organizations = characterData?["organizations"]?.toString() ?? '';
        allies = characterData?["allies"]?.toString() ?? '';
        enemies = characterData?["enemies"]?.toString() ?? '';
        backstory = characterData?["backstory"]?.toString() ?? '';
        other = characterData?["other"]?.toString() ?? '';

        // Now update the trait controllers.
        _traitsControllers['Background']?.text = background;
        _traitsControllers['Alignment']?.text = alignment;
        _traitsControllers['Faith']?.text = faith;
        _traitsControllers['Lifestyle']?.text = lifestyle;
        _traitsControllers['Hair']?.text = hair;
        _traitsControllers['Eyes']?.text = eyes;
        _traitsControllers['Skin']?.text = skin;
        _traitsControllers['Height']?.text = height;
        _traitsControllers['Weight']?.text = weight;
        _traitsControllers['Age']?.text = age;
        _traitsControllers['Gender']?.text = gender;
        _traitsControllers['Personality Traits']?.text = personalityTraits;
        _traitsControllers['Ideals']?.text = ideals;
        _traitsControllers['Bonds']?.text = bonds;
        _traitsControllers['Flaws']?.text = flaws;
        _traitsControllers['Organizations']?.text = organizations;
        _traitsControllers['Allies']?.text = allies;
        _traitsControllers['Enemies']?.text = enemies;
        _traitsControllers['Backstory']?.text = backstory;
        _traitsControllers['Other']?.text = other;
      });
    } catch (e) {
      print('Error fetching character data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveCharacterData() async {
    final User user = FirebaseAuth.instance.currentUser!;
    final uuid = user.uid;
    final docRef = FirebaseFirestore.instance
        .collection('app_user_profiles')
        .doc(uuid)
        .collection('characters')
        .doc(widget.characterID);
    final traitData = {
      'background': _traitsControllers['Background']?.text ?? '',
      'alignment': _traitsControllers['Alignment']?.text ?? '',
      'faith': _traitsControllers['Faith']?.text ?? '',
      'lifestyle': _traitsControllers['Lifestyle']?.text ?? '',
      'hair': _traitsControllers['Hair']?.text ?? '',
      'eyes': _traitsControllers['Eyes']?.text ?? '',
      'skin': _traitsControllers['Skin']?.text ?? '',
      'height': _traitsControllers['Height']?.text ?? '',
      'weight': _traitsControllers['Weight']?.text ?? '',
      'age': _traitsControllers['Age']?.text ?? '',
      'gender': _traitsControllers['Gender']?.text ?? '',
      'personalityTraits': _traitsControllers['Personality Traits']?.text ?? '',
      'ideals': _traitsControllers['Ideals']?.text ?? '',
      'bonds': _traitsControllers['Bonds']?.text ?? '',
      'flaws': _traitsControllers['Flaws']?.text ?? '',
      'organizations': _traitsControllers['Organizations']?.text ?? '',
      'allies': _traitsControllers['Allies']?.text ?? '',
      'enemies': _traitsControllers['Enemies']?.text ?? '',
      'backstory': _traitsControllers['Backstory']?.text ?? '',
      'other': _traitsControllers['Other']?.text ?? '',
    };

    try {
      await docRef.set(
          {
            'abilityScores': {
              'Strength': int.parse(strengthScore),
              'Dexterity': int.parse(dexterityScore),
              'Constitution': int.parse(constitutionScore),
              'Intelligence': int.parse(intelligenceScore),
              'Wisdom': int.parse(wisdomScore),
              'Charisma': int.parse(charismaScore),
            },
            'modifiers': {
              'Strength': int.parse(strengthModifier),
              'Dexterity': int.parse(dexterityModifier),
              'Constitution': int.parse(constitutionModifier),
              'Intelligence': int.parse(intelligenceModifier),
              'Wisdom': int.parse(wisdomModifier),
              'Charisma': int.parse(charismaModifier),
            },
            'hp': int.tryParse(hp) ?? 0,
            'ac': int.tryParse(ac) ?? 0,
            'hitDice': hitDice,
            'proficiencies': proficiencies.toList(),
            'languages': languages.toList(),
            'spells': selectedSpells,
            'cantrips': selectedCantrips,
            'weapons': selectedWeapons,
            ...traitData,
          },
          SetOptions(
              merge: true)); // merge: true prevents overwriting other fields

      print("Character data saved successfully!");
    } catch (e) {
      print("Error saving character data: $e");
    }
  }

  String _calculateModifier(String scoreStr) {
    final int score = int.tryParse(scoreStr) ?? 10;
    final int mod = ((score - 10) / 2).floor();
    return mod >= 0 ? '+$mod' : '$mod';
  }

  @override
  Widget build(BuildContext context) {
    super.build(
        context); // call the funny super.build to ensure the mixin works properly
    return PopScope(
      canPop: canPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(characterData?['name'] ?? 'Character Sheet'),
          leading: widget.inSession
              ? IconButton(
                  onPressed: () {},
                  icon: const SizedBox.shrink(), // Creates an invisible icon
                ) // Remove the back button if inSession is true
              : IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      canPop = true;
                    });
                    Navigator.of(context).pop();
                  },
                ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save), // Save icon
              onPressed: _saveCharacterData, // Call the save function
              tooltip: 'Save Character', // Tooltip for accessibility
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : DefaultTabController(
                length: 5,
                child: Column(
                  children: [
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: const TabBar(
                        isScrollable: false,
                        tabs: [
                          Tab(child: Text('Stats')),
                          Tab(child: Text('Spells')),
                          Tab(child: Text('Combat')),
                          Tab(child: Text('Pouch')),
                          Tab(child: Text('Traits')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildStatsTab(),
                          _buildSpellsTab(),
                          _buildCombatTab(),
                          _buildInventoryTab(),
                          _buildTraitsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     // Roll 2d6 using the popup dice roller
        //     int? result = 0;
        //     if (result != null) {
        //       // Show the result in a dialog
        //       showDialog(
        //         context: context,
        //         builder: (context) => AlertDialog(
        //           title: const Text("Dice Roll Result"),
        //           content: Text("You rolled: $result"),
        //           actions: [
        //             TextButton(
        //               onPressed: () => Navigator.of(context).pop(),
        //               child: const Text("OK"),
        //             ),
        //           ],
        //         ),
        //       );
        //     }
        //   },
        //   backgroundColor: Colors.blue,
        //   child: const Icon(Icons.casino), // Dice icon
        // ),
      ),
    );
  }

  Widget _buildStatsTab() {
    // Retrieve character details
    final String name = characterData?['name'] ?? 'Unknown Name';
    final String charClass = characterData?['class'] ?? 'Unknown Class';
    final int level = characterData?['level'] ?? 1;

    final int initiative = int.parse(dexterityModifier);
    final int speed = 30;
    // final String hitDice = "1d8";
    final int proficiency = 2;

    final int strengthSave = calculateSavingThrow("Strength", strengthModifier);
    final int dexSave = calculateSavingThrow("Dexterity", dexterityModifier);
    final int conSave =
        calculateSavingThrow("Constitution", constitutionModifier);
    final int intSave =
        calculateSavingThrow("Intelligence", intelligenceModifier);
    final int wisSave = calculateSavingThrow("Wisdom", wisdomModifier);
    final int chaSave = calculateSavingThrow("Charisma", charismaModifier);

    // Define a map of skills with their associated ability key.
    final Map<String, String> skillAbilities = {
      "Acrobatics": "dexterity",
      "Animal Handling": "wisdom",
      "Arcana": "intelligence",
      "Athletics": "strength",
      "Deception": "charisma",
      "History": "intelligence",
      "Insight": "wisdom",
      "Intimidation": "charisma",
      "Investigation": "intelligence",
      "Medicine": "wisdom",
      "Nature": "intelligence",
      "Perception": "wisdom",
      "Performance": "charisma",
      "Persuasion": "charisma",
      "Religion": "intelligence",
      "Sleight of Hand": "dexterity",
      "Stealth": "dexterity",
      "Survival": "wisdom",
    };

    // Helper function to format modifiers (e.g. +3 or -1).
    String formatModifier(String modStr) {
      final int mod = int.parse(modStr);
      return mod >= 0 ? "+$mod" : "$mod";
    }

    // Build a list of skill cards.
    List<Widget> buildSkillCards() {
      List<Widget> cards = [];
      skillAbilities.forEach((skill, ability) {
        String mod;
        switch (ability) {
          case "strength":
            mod = strengthModifier;
            break;
          case "dexterity":
            mod = dexterityModifier;
            break;
          case "constitution":
            mod = constitutionModifier;
            break;
          case "intelligence":
            mod = intelligenceModifier;
            break;
          case "wisdom":
            mod = wisdomModifier;
            break;
          case "charisma":
            mod = charismaModifier;
            break;
          default:
            mod = "0";
        }

        // Add proficiency bonus if the character is proficient in the skill.
        int skillMod = int.parse(mod);
        if (proficiencies.contains(skill)) {
          skillMod += proficiencyBonus;
        }

        cards.add(_buildSkillCard(skill, formatModifier(skillMod.toString())));
      });
      return cards;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // -- Character Info Section --
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Editable character name.
                  EditableTextField(
                    initialText: name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        characterData?['name'] =
                            newValue.isEmpty ? name : newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$charClass",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    "Level: $level",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // -- Top Section: Combat Stats --
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTopStatCard(
                "Initiative",
                "$initiative",
                onChanged: (newValue) {
                  // Example: update initiative (if applicable)
                },
              ),
              _buildTopStatCard(
                "HP",
                "$hp",
                onChanged: (newValue) {
                  setState(() {
                    hp = newValue;
                  });
                },
              ),
              _buildTopStatCard(
                "Speed",
                "$speed",
                onChanged: (newValue) {
                  // Example: update speed (if needed)
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTopStatCard("Hit Dice", hitDice, onChanged: (newValue) {
                setState(() {
                  hitDice = newValue;
                });
              }),
              _buildTopStatCard("AC", "$armorClass", onChanged: (newValue) {
                setState(() {
                  armorClass = int.tryParse(newValue) ?? armorClass;
                });
              }),
              _buildTopStatCard("Prof.", "+$proficiency",
                  onChanged: (newValue) {
                // Remove '+' sign and then update if needed.
              }),
            ],
          ),
          const SizedBox(height: 16),

          // -- Ability Scores Section --
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAbilityScoreCard(
                      "Strength",
                      strengthScore,
                      strengthModifier,
                      "$strengthSave",
                      onChanged: (newVal) {
                        setState(() {
                          strengthScore = newVal;
                          strengthModifier = _calculateModifier(strengthScore);
                        });
                      },
                    ),
                    _buildAbilityScoreCard(
                      "Dexterity",
                      dexterityScore,
                      dexterityModifier,
                      "$dexSave",
                      onChanged: (newVal) {
                        setState(() {
                          dexterityScore = newVal;
                          dexterityModifier =
                              _calculateModifier(dexterityScore);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAbilityScoreCard(
                      "Constitution",
                      constitutionScore,
                      constitutionModifier,
                      "$conSave",
                      onChanged: (newVal) {
                        setState(() {
                          constitutionScore = newVal;
                          constitutionModifier =
                              _calculateModifier(constitutionScore);
                        });
                      },
                    ),
                    _buildAbilityScoreCard(
                      "Intelligence",
                      intelligenceScore,
                      intelligenceModifier,
                      "$intSave",
                      onChanged: (newVal) {
                        setState(() {
                          intelligenceScore = newVal;
                          intelligenceModifier =
                              _calculateModifier(intelligenceScore);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAbilityScoreCard(
                      "Wisdom",
                      wisdomScore,
                      wisdomModifier,
                      "$wisSave",
                      onChanged: (newVal) {
                        setState(() {
                          wisdomScore = newVal;
                          wisdomModifier = _calculateModifier(wisdomScore);
                        });
                      },
                    ),
                    _buildAbilityScoreCard(
                      "Charisma",
                      charismaScore,
                      charismaModifier,
                      "$chaSave",
                      onChanged: (newVal) {
                        setState(() {
                          charismaScore = newVal;
                          charismaModifier = _calculateModifier(charismaScore);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // -- Skills Section --
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Skills",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 8),
          // Use a GridView to show skills in multiple columns.
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 3.5,
            children: buildSkillCards(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStatCard(String label, String value,
      {void Function(String)? onChanged}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            EditableTextField(
              initialText: value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbilityScoreCard(
      String ability, String score, String mod, String save,
      {void Function(String)? onChanged}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              ability,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 4),
            // Editable field for the ability score.
            EditableTextField(
              initialText: score,
              style: const TextStyle(fontSize: 18),
              onChanged: onChanged,
            ),
            Text(
              "Mod: $mod",
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              "Save: $save",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCard(String skill, String mod) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      margin: const EdgeInsets.all(4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                skill,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              mod,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryTab() {
    // In a real app, you'd likely store the user's pack type in a variable.
    // For demonstration, we're just using "Scholar’s Pack".

    // Retrieve the string for the user's pack; provide a fallback if necessary.
    final String packItemsString = packDescriptions[userPack] ?? "";

    // Split the string by commas and trim whitespace from each item.
    final List<String> packItems =
        packItemsString.split(',').map((item) => item.trim()).toList();

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        // Header for the pack name.
        ListTile(
          title: Text(
            userPack,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const Divider(),
        // Create a list tile for each item in the pack.
        ...packItems.map((item) => Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                leading: const Icon(Icons.check_box_outlined),
                title: Text(item),
              ),
            )),
      ],
    );
  }

  Widget _buildSpellsTab() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedCantrips.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '    Cantrips:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            for (var cantrip in selectedCantrips) buildSpellTile(cantrip, true),
          ],
          if (selectedSpells.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '    Level 1 Spells:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            for (var spell in selectedSpells) buildSpellTile(spell, false),
          ],
          if (selectedCantrips.isEmpty && selectedSpells.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No spells selected.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCombatTab() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            if (selectedWeapons.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '    Weapons:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              for (var weapon in selectedWeapons)
                _buildWeaponTile(weapon), // Use the weapon tile builder
            ],
          ],
        ),
      ),
    );
    // return Center(
    //     child: Column(
    //   children: [
    //     if (selectedWeapons.isNotEmpty) ...[
    //       const Padding(
    //         padding: EdgeInsets.symmetric(vertical: 8.0),
    //         child: Text(
    //           '    Weapons:',
    //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //       for (var weapon in selectedWeapons) Text(weapon),
    //     ],
    //   ],
    // ));
  }

  Widget _buildTraitsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: _traitKeys
            .map((title) => _buildSummaryTile(context, title))
            .toList(),
      ),
    );
  }

  Widget buildSpellTile(String spellName, bool isCantrip) {
    bool isSelected = isCantrip
        ? selectedCantrips.contains(spellName)
        : selectedSpells.contains(spellName);

    if (_spellDescriptionCache.containsKey(spellName)) {
      String description = _spellDescriptionCache[spellName]!;
      String summary = _buildSummary(description);
      return _buildTile(spellName, summary, isSelected, isCantrip);
    } else {
      return FutureBuilder<String>(
        future: _getSpellDescription(spellName),
        builder: (context, snapshot) {
          String summary = 'Loading description...';
          if (snapshot.hasData) {
            String description = snapshot.data!;
            summary = _buildSummary(description);
          }
          return _buildTile(spellName, summary, isSelected, isCantrip);
        },
      );
    }
  }

  Future<String> _getSpellDescription(String spellName) async {
    if (_spellDescriptionCache.containsKey(spellName)) {
      return _spellDescriptionCache[spellName]!;
    }
    String? desc = await SpellService.getSpellDescription(spellName);
    String finalDesc = desc ?? 'No description available.';
    _spellDescriptionCache[spellName] = finalDesc;
    return finalDesc;
  }

  Widget _buildTile(
      String spellName, String summary, bool isSelected, bool isCantrip) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.grey[850],
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.wandMagic,
            color: Theme.of(context).iconTheme.color),
        title: Text(
          spellName,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          summary,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        trailing: IconButton(
          icon: Icon(Icons.info_outline,
              color: Theme.of(context).iconTheme.color),
          onPressed: () {
            _showSpellInfoDialog(context, spellName);
          },
        ),
      ),
    );
  }

  Future<void> _showSpellInfoDialog(
      BuildContext context, String spellName) async {
    String description = await _getSpellDescription(spellName);
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
            child: _buildFormattedDescription(description),
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

  Widget _buildFormattedDescription(String description) {
    List<Widget> lineWidgets = [];
    for (var line in description.split('\n')) {
      String cleanLine = line.replaceAll('*', '').trim();
      if (cleanLine.isEmpty) continue;
      if (cleanLine.contains(':')) {
        var parts = cleanLine.split(RegExp(r':\s*'));
        if (parts.length >= 2) {
          String header = parts[0] + ":";
          String detail = parts.sublist(1).join(": ");
          lineWidgets.add(
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: header + " ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: detail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          lineWidgets.add(
            Text(
              cleanLine,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          );
        }
      } else {
        lineWidgets.add(
          Text(
            cleanLine,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        );
      }
      lineWidgets.add(const SizedBox(height: 8));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lineWidgets,
    );
  }

  String _buildSummary(String description) {
    List<String> lines = description
        .split('\n')
        .map((line) => line.replaceAll('*', '').trim())
        .toList();
    String schoolInfo = lines.firstWhere(
      (line) => line.toLowerCase().startsWith('school:'),
      orElse: () => '',
    );
    String classInfo = lines.firstWhere(
      (line) => line.toLowerCase().startsWith('class:'),
      orElse: () => '',
    );
    String rangeInfo = lines.firstWhere(
      (line) => line.toLowerCase().startsWith('range:'),
      orElse: () => '',
    );
    List<String> infoParts = [];
    if (schoolInfo.isNotEmpty) infoParts.add(schoolInfo);
    if (classInfo.isNotEmpty) infoParts.add(classInfo);
    if (rangeInfo.isNotEmpty) infoParts.add(rangeInfo);
    String summary = infoParts.join(' | ');
    if (summary.isEmpty) {
      summary = description.split('\n').take(3).join('\n');
    }
    return summary;
  }

  Widget _buildWeaponTile(String weaponName) {
    final String damage = simpleWeaponDamage[weaponName] ??
        martialWeaponDamage[weaponName] ??
        'Unknown';
    final String attackModifier = _getWeaponAttackModifier(weaponName);
    final String modifierType = weaponModifiers[weaponName] ?? 'Strength';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: Theme.of(context).listTileTheme.tileColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weapon Icon
            FaIcon(
              _getWeaponIcon(weaponName),
              size: 40,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 12),

            // Weapon Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weapon Name
                  Text(
                    weaponName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Damage and Attack Modifier
                  Text(
                    'Damage: $damage + $attackModifier',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Modifier Type
                  Text(
                    'Modifier: $modifierType',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                // Roll to hit, then prompt to see if user wants to roll damage
                showDiceRollPopup(
                  context,
                  "1d20", // Attack roll dice (always a d20 for weapon attacks)
                  modifier: int.parse(attackModifier), // Attack roll modifier
                  attackRollDamage: damage,
                  isAttack: true,
                ).then((result) {
                  //just some logging
                  if (result != null) {
                    print("Final Result: $result");
                  }
                });
              },
              icon: const Icon(Icons.casino),
            ),

            // Attack Modifier Display
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).iconTheme.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'To Hit',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '+$attackModifier',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTile(BuildContext context, String title) {
    final controller = _traitsControllers[title]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          filled: true,
          fillColor: Theme.of(context).listTileTheme.tileColor,
          border: const OutlineInputBorder(),
        ),
        maxLines: null, // allows for multiline input
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  IconData _getWeaponIcon(String weapon) {
    final lower = weapon.toLowerCase();
    if (lower.contains('sword') ||
        lower.contains('rapier') ||
        lower.contains('scimitar') ||
        lower.contains('shortsword') ||
        lower.contains('longsword') ||
        lower.contains('greatsword')) {
      return RpgAwesomeIcons.crossedSwords;
    } else if (lower.contains('axe')) {
      return RpgAwesomeIcons.batteredAxe;
    } else if (lower.contains('bow') || lower.contains('crossbow')) {
      return RpgAwesomeIcons.arrowCluster;
    } else if (lower.contains('dagger')) {
      return RpgAwesomeIcons.knife;
    } else if (lower.contains('club') ||
        lower.contains('mace') ||
        lower.contains('hammer') ||
        lower.contains('flail')) {
      return FontAwesomeIcons.hammer;
    } else if (lower.contains('spear') || lower.contains('javelin')) {
      return FontAwesomeIcons.solidCircle; // placeholder
    }
    return FontAwesomeIcons.crosshairs; // fallback
  }

  String _getWeaponAttackModifier(String weaponName) {
    int returnModifier = 0;
    String modifierType = weaponModifiers[weaponName] ?? 'Strength';
    switch (modifierType) {
      case 'Strength':
        returnModifier = int.parse(strengthModifier) + 2;
        return returnModifier
            .toString(); // +2 is the proficiency bonus for simplicity
      case 'Dexterity':
        returnModifier = int.parse(dexterityModifier) + 2;
        return returnModifier.toString();
      case 'Dexterity or Strength':
        if (int.parse(dexterityScore) >= int.parse(strengthScore)) {
          returnModifier = int.parse(dexterityModifier) + 2;
          return returnModifier.toString(); //use Dexterity if it's higher
        } else {
          returnModifier = int.parse(strengthModifier) + 2;
          return returnModifier.toString(); //otherwise use Strength
        }
      default:
        return '0'; // trust ol default we all know and love :)
    }
  }

  int calculateSavingThrow(String ability, String modifier) {
    int save = int.parse(modifier); // Start with the ability modifier
    if (classSavingThrowProficiencies[characterClass]?.contains(ability) ??
        false) {
      save += proficiencyBonus; // Add proficiency bonus if proficient
    }
    return save;
  }
}
