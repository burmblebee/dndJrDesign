import 'package:warlocks_of_the_beach/providers/character_provider.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/character_other.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/summarization_screen.dart';
import 'package:warlocks_of_the_beach/widgets/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/loaders/alignment_data_loader.dart';
import '../../widgets/buttons/navigation_button.dart';
import '../../widgets/loaders/lifestyle_data_loader.dart';

class CharacterTraitScreen extends ConsumerStatefulWidget {
  CharacterTraitScreen({super.key});

  

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CharacterTraitScreenState();
  }
}

class _CharacterTraitScreenState extends ConsumerState<CharacterTraitScreen> {
  List<String> alignments = [
    'Lawful Good',
    'Neutral Good',
    'Chaotic Good',
    'Lawful Neutral',
    'True Neutral',
    'Chaotic Neutral',
    'Lawful Evil',
    'Neutral Evil',
    'Chaotic Evil'
  ];
  List<String> lifestyles = [
    'Wretched',
    'Squalid',
    'Miserable',
    'Poor',
    'Modest',
    'Comfortable',
    'Wealthy',
    'Aristocratic'
  ];
  late Widget mainContent;
  late var chosenAlignment = 'Lawful Good';
  late var chosenLifestyle = 'Wretched';
  final customColor = const Color.fromARGB(255, 138, 28, 20);

  //details controllers
  final TextEditingController _faithController = TextEditingController();

  //physical controllers
  final TextEditingController _hairController = TextEditingController();
  final TextEditingController _eyesController = TextEditingController();
  final TextEditingController _skinController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  //personal controllers
  final TextEditingController _personalityTraitsController =
      TextEditingController();
  final TextEditingController _idealsController = TextEditingController();
  final TextEditingController _bondsController = TextEditingController();
  final TextEditingController _flawsController = TextEditingController();

  //notes controllers
  final TextEditingController _organizationsController =
      TextEditingController();
  final TextEditingController _alliesController = TextEditingController();
  final TextEditingController _enemiesController = TextEditingController();
  final TextEditingController _backstoryController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();

  String _currentSection = "Details";

  void _saveSelections(WidgetRef ref) {
    ref.read(characterProvider.notifier).updateTrait('alignment', chosenAlignment);
    ref.read(characterProvider.notifier).updateTrait('faith', _faithController.text);
    ref.read(characterProvider.notifier).updateTrait('lifestyle', chosenLifestyle);
    ref.read(characterProvider.notifier).updateTrait('hair', _hairController.text);
    ref.read(characterProvider.notifier).updateTrait('eyes', _eyesController.text);
    ref.read(characterProvider.notifier).updateTrait('skin', _skinController.text);
    ref.read(characterProvider.notifier).updateTrait('height', _heightController.text);
    ref.read(characterProvider.notifier).updateTrait('weight', _weightController.text);
    ref.read(characterProvider.notifier).updateTrait('age', _ageController.text);
    ref.read(characterProvider.notifier).updateTrait('gender', _genderController.text);
    ref.read(characterProvider.notifier).updateTrait('personalityTraits', _personalityTraitsController.text);
    ref.read(characterProvider.notifier).updateTrait('ideals', _idealsController.text);
    ref.read(characterProvider.notifier).updateTrait('bonds', _bondsController.text);
    ref.read(characterProvider.notifier).updateTrait('flaws', _flawsController.text);
    ref.read(characterProvider.notifier).updateTrait('organization', _organizationsController.text);
    ref.read(characterProvider.notifier).updateTrait('allies', _alliesController.text);
    ref.read(characterProvider.notifier).updateTrait('enemies', _enemiesController.text);
    ref.read(characterProvider.notifier).updateTrait('backstory', _backstoryController.text);
    ref.read(characterProvider.notifier).updateTrait('other', _otherController.text);
  }

  Widget detailsScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Alignment',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            DropdownButton(
              items: alignments
                  .map((alignment) => DropdownMenuItem(
                        value: alignment,
                        child: Text(alignment),
                      ))
                  .toList(),
              onChanged: (alignment) =>
                  setState(() => chosenAlignment = alignment.toString()),
              value: chosenAlignment,
            ),
            AlignmentDataWidget(alignment: chosenAlignment),
            const SizedBox(height: 35),
            const Text(
              'Faith',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _faithController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Faith',
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20),
            const Text(
              'Lifestyle',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),
            DropdownButton(
              items: lifestyles
                  .map((lifestyle) => DropdownMenuItem(
                        value: lifestyle,
                        child: Text(lifestyle),
                      ))
                  .toList(),
              value: chosenLifestyle,
              onChanged: (lifestyle) =>
                  setState(() => chosenLifestyle = lifestyle.toString()),
            ),
            LifestyleDataWidget(lifestyle: chosenLifestyle),
          ],
        ),
      ),
    );
  }

  Widget physicalScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Hair',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _hairController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Hair',
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            const Text(
              'Eyes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _eyesController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Eyes',
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            const Text(
              'Skin',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _skinController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Skin',
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            const Text(
              'Height',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Height',
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            const Text(
              'Weight',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Weight (lbs)',
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            const Text(
              'Age',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Age (years)',
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            const Text(
              'Gender',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _genderController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Gender',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget personalScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize
            .min, // Ensures the column only takes as much space as needed
        children: [
          const Text(
            'Personality Traits',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _personalityTraitsController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Personality Traits',
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next, // Move to the next field
          ),
          const SizedBox(height: 20),
          const Text(
            'Ideals',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _idealsController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ideals',
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          const Text(
            'Bonds',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _bondsController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Bonds',
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          const Text(
            'Flaws',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _flawsController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Flaws',
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done, // Done for the last field
          ),
        ],
      ),
    );
  }

  Widget notesScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Organizations',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _organizationsController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Organizations',
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          const Text(
            'Allies',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _alliesController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Allies',
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          const Text(
            'Enemies',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _enemiesController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enemies',
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          const Text(
            'Backstory',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _backstoryController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Backstory',
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          const Text(
            'Other Notes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _otherController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Other Notes',
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentSection == 'Details') {
      mainContent = detailsScreen();
    }
    if (_currentSection == 'Physical') {
      mainContent = physicalScreen();
    }
    if (_currentSection == 'Personal') {
      mainContent = personalScreen();
    }
    if (_currentSection == 'Notes') {
      mainContent = notesScreen();
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SegmentedButton<String>(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context).listTileTheme.tileColor!;
                    }
                    return Colors.grey;
                  },
                ),
                foregroundColor: const WidgetStatePropertyAll(Colors.white),
              ),
              showSelectedIcon: false,
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(
                  value: 'Details',
                  label: Center(child: Text('Details')),
                ),
                ButtonSegment<String>(
                  value: 'Physical',
                  label: Center(child: Text('Physical')),
                ),
                ButtonSegment<String>(
                  value: 'Personal',
                  label: Center(child: Text('Personal')),
                ),
                ButtonSegment<String>(
                  value: 'Notes',
                  label: Center(child: Text('Notes')),
                ),
              ],
              selected: {_currentSection},
              emptySelectionAllowed: false,
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _currentSection = newSelection.first;
                });
              },
            ),
            mainContent,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text("Back"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    _saveSelections(ref);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SummarizationScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text("Next"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:warlocks_of_the_beach/providers/character_provider.dart';
// import 'package:warlocks_of_the_beach/screens/dnd_forms/character_other.dart';
// import 'package:warlocks_of_the_beach/widgets/main_appbar.dart';
// import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
// import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';

// import '../../screens/dnd_forms/image_generator.dart';
// import 'package:flutter/material.dart';
// import '../../widgets/loaders/alignment_data_loader.dart';
// import '../../widgets/buttons/navigation_button.dart';
// import '../../widgets/loaders/lifestyle_data_loader.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CharacterTraitScreen extends StatefulWidget {
//   CharacterTraitScreen({super.key, required this.characterName});

//   final characterName;

//   @override
//   State<StatefulWidget> createState() {
//     return _CharacterTraitScreenState();
//   }
// }

// class _CharacterTraitScreenState extends State<CharacterTraitScreen> {
//   List<String> alignments = [
//     'Lawful Good',
//     'Neutral Good',
//     'Chaotic Good',
//     'Lawful Neutral',
//     'True Neutral',
//     'Chaotic Neutral',
//     'Lawful Evil',
//     'Neutral Evil',
//     'Chaotic Evil'
//   ];
//   List<String> lifestyles = [
//     'Wretched',
//     'Squalid',
//     'Miserable',
//     'Poor',
//     'Modest',
//     'Comfortable',
//     'Wealthy',
//     'Aristocratic'
//   ];
//   late Widget mainContent;
//   late var chosenAlignment = 'Lawful Good';
//   late var chosenLifestyle = 'Wretched';
//   final customColor = const Color.fromARGB(255, 138, 28, 20);

//   //details controllers
//   final TextEditingController _faithController = TextEditingController();

//   //physical controllers
//   final TextEditingController _hairController = TextEditingController();
//   final TextEditingController _eyesController = TextEditingController();
//   final TextEditingController _skinController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _genderController = TextEditingController();

//   //personal controllers
//   final TextEditingController _personalityTraitsController =
//       TextEditingController();
//   final TextEditingController _idealsController = TextEditingController();
//   final TextEditingController _bondsController = TextEditingController();
//   final TextEditingController _flawsController = TextEditingController();

//   //notes controllers
//   final TextEditingController _organizationsController =
//       TextEditingController();
//   final TextEditingController _alliesController = TextEditingController();
//   final TextEditingController _enemiesController = TextEditingController();
//   final TextEditingController _backstoryController = TextEditingController();
//   final TextEditingController _otherController = TextEditingController();

//   String _currentSection = "Details";

//   void _saveSelections() async {
//     final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUserUid != null) {
//       final docRef = FirebaseFirestore.instance
//           .collection('app_user_profiles')
//           .doc(currentUserUid)
//           .collection('characters')
//           .doc(widget.characterName); // Use the UID directly

//       final Map<String, String> traitsToSave = {
//         'alignment': chosenAlignment,
//         'faith': _faithController.text,
//         'lifestyle': chosenLifestyle,
//         'hair': _hairController.text,
//         'eyes': _eyesController.text,
//         'skin': _skinController.text,
//         'height': _heightController.text,
//         'weight': _weightController.text,
//         'age': _ageController.text,
//         'gender': _genderController.text,
//         'personalityTraits': _personalityTraitsController.text,
//         'ideals': _idealsController.text,
//         'bonds': _bondsController.text,
//         'flaws': _flawsController.text,
//         'organization': _organizationsController.text,
//         'allies': _alliesController.text,
//         'enemies': _enemiesController.text,
//         'backstory': _backstoryController.text,
//         'other': _otherController.text
//       };

//       try {
//         await docRef.set({
//           'characterTraits': traitsToSave,
//         }, SetOptions(merge: true)); // Merge ensures only this field is updated
//       } catch (e) {
//         print('Error saving traits: $e');
//       }
//     }
//   }

//   Widget detailsScreen() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Alignment',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             DropdownButton(
//               items: alignments
//                   .map((alignment) => DropdownMenuItem(
//                         value: alignment,
//                         child: Text(alignment),
//                       ))
//                   .toList(),
//               onChanged: (alignment) =>
//                   setState(() => chosenAlignment = alignment.toString()),
//               value: chosenAlignment,
//             ),
//             AlignmentDataWidget(alignment: chosenAlignment),
//             const SizedBox(height: 35),
//             const Text(
//               'Faith',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _faithController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Faith',
//               ),
//               keyboardType: TextInputType.text,
//               textInputAction: TextInputAction.done,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Lifestyle',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 5),
//             DropdownButton(
//               items: lifestyles
//                   .map((lifestyle) => DropdownMenuItem(
//                         value: lifestyle,
//                         child: Text(lifestyle),
//                       ))
//                   .toList(),
//               value: chosenLifestyle,
//               onChanged: (lifestyle) =>
//                   setState(() => chosenLifestyle = lifestyle.toString()),
//             ),
//             LifestyleDataWidget(lifestyle: chosenLifestyle),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget physicalScreen() {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Hair',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _hairController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Hair',
//               ),
//               keyboardType: TextInputType.text,
//               textInputAction: TextInputAction.next,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Eyes',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _eyesController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Eyes',
//               ),
//               keyboardType: TextInputType.text,
//               textInputAction: TextInputAction.next,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Skin',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _skinController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Skin',
//               ),
//               keyboardType: TextInputType.text,
//               textInputAction: TextInputAction.next,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Height',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _heightController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Height',
//               ),
//               keyboardType: TextInputType.text,
//               textInputAction: TextInputAction.next,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Weight',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _weightController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Weight (lbs)',
//               ),
//               keyboardType: TextInputType.text,
//               textInputAction: TextInputAction.next,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Age',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _ageController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Age (years)',
//               ),
//               keyboardType: TextInputType.text,
//               textInputAction: TextInputAction.next,
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Gender',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _genderController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Gender',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget personalScreen() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize
//             .min, // Ensures the column only takes as much space as needed
//         children: [
//           const Text(
//             'Personality Traits',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _personalityTraitsController,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Personality Traits',
//             ),
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.next, // Move to the next field
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Ideals',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _idealsController,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Ideals',
//             ),
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.next,
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Bonds',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _bondsController,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Bonds',
//             ),
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.next,
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Flaws',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _flawsController,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Flaws',
//             ),
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.done, // Done for the last field
//           ),
//         ],
//       ),
//     );
//   }

//   Widget notesScreen() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text(
//             'Organizations',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _organizationsController,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Organizations',
//             ),
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.next,
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Allies',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _alliesController,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Allies',
//             ),
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.next,
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Enemies',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _enemiesController,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Enemies',
//             ),
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.next,
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Backstory',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _backstoryController,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Backstory',
//             ),
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.next,
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Other Notes',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: _otherController,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Other Notes',
//             ),
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.done,
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_currentSection == 'Details') {
//       mainContent = detailsScreen();
//     }
//     if (_currentSection == 'Physical') {
//       mainContent = physicalScreen();
//     }
//     if (_currentSection == 'Personal') {
//       mainContent = personalScreen();
//     }
//     if (_currentSection == 'Notes') {
//       mainContent = notesScreen();
//     }
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: MainAppbar(),
//       drawer: const MainDrawer(),
//       bottomNavigationBar: MainBottomNavBar(),

//       // bottomNavigationBar: Row(
//       //   children: [
//       //     NavigationButton(
//       //       onPressed: () {
//       //         Navigator.pop(context);
//       //       },
//       //       textContent: 'Back',
//       //     ),
//       //     const SizedBox(width: 30),
//       //     NavigationButton(
//       //       textContent: "Next",
//       //       onPressed: () {
//       //         _saveSelections();
//       //         // Navigator.push(
//       //         //     context,
//       //         //     MaterialPageRoute(
//       //         //       builder: (context) => ImageGenerator(characterName: widget.characterName,)
//       //         //     ),
//       //         //   );
//       //         Navigator.push(
//       //             context,
//       //             MaterialPageRoute(
//       //                 builder: (context) =>
//       //                     CharacterOther(characterName: 'characterName')));
//       //       },
//       //     ),
//       //   ],
//       // ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             SegmentedButton<String>(
//               style: ButtonStyle(
//                 backgroundColor: WidgetStateProperty.resolveWith<Color>(
//                   (states) {
//                     if (states.contains(WidgetState.selected)) {
//                       return customColor;
//                     }
//                     return Colors.grey;
//                   },
//                 ),
//                 foregroundColor: const WidgetStatePropertyAll(Colors.white),
//               ),
//               showSelectedIcon: false,
//               segments: const <ButtonSegment<String>>[
//                 ButtonSegment<String>(
//                   value: 'Details',
//                   label: Center(child: Text('Details')),
//                 ),
//                 ButtonSegment<String>(
//                   value: 'Physical',
//                   label: Center(child: Text('Physical')),
//                 ),
//                 ButtonSegment<String>(
//                   value: 'Personal',
//                   label: Center(child: Text('Personal')),
//                 ),
//                 ButtonSegment<String>(
//                   value: 'Notes',
//                   label: Center(child: Text('Notes')),
//                 ),
//               ],
//               selected: {_currentSection},
//               emptySelectionAllowed: false,
//               onSelectionChanged: (Set<String> newSelection) {
//                 setState(() {
//                   _currentSection = newSelection.first;
//                 });
//               },
//             ),
//             mainContent,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () => Navigator.pop(context),
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   label: const Text("Back"),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(width: 30),
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // ref.read(characterProvider.notifier).updateSpells({
//                     //   'cantrips': selectedCantrips.toList(),
//                     //   'spells': selectedSpells.toList(),
//                     // });
                    
//                     Navigator.push(
                      
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => CharacterTraitScreen(
//                             characterName:
//                                 'HARDCODED SPELL SELECTION LINE 688'),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.arrow_forward, color: Colors.white),
//                   label: const Text("Next"),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
