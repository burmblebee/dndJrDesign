import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/buttons/button_with_padding.dart';
import 'package:warlocks_of_the_beach/widgets/dnd_form_widgets/race_data_loader.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import 'package:warlocks_of_the_beach/providers/character_provider.dart';
import 'class_selection.dart';

class RaceSelection extends ConsumerStatefulWidget {
  const RaceSelection({super.key});

  @override
  _RaceSelectionState createState() => _RaceSelectionState();
}

class _RaceSelectionState extends ConsumerState<RaceSelection> {
  String _selectedRace = 'Elf'; // Default race
  final Color customColor = const Color.fromARGB(255, 138, 28, 20);

  void _updateSelectedRace(String raceName) {
    setState(() {
      _selectedRace = raceName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final characterName = ref.watch(characterProvider).name;

    return Scaffold(
      bottomNavigationBar: MainBottomNavBar(),
      appBar: MainAppbar(),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Race Selection for $characterName',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Pick your race',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var race in [
                  'Aasimar',
                  'Dragonborn',
                  'Dwarf',
                  'Elf',
                  'Gnome',
                  'Halfling',
                  'Human',
                  'Orc',
                  'Tiefling'
                ])
                  ButtonWithPadding(
                    onPressed: () => _updateSelectedRace(race),
                    textContent: race,
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: 350,
                width: 350,
                child: SingleChildScrollView(
                  child: RaceDataLoader(raceName: _selectedRace),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassSelection(
                          characterName: characterName,
                          race: _selectedRace,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Next"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customColor,
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




// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
// import 'package:warlocks_of_the_beach/widgets/buttons/button_with_padding.dart';
// import 'package:warlocks_of_the_beach/widgets/dnd_form_widgets/race_data_loader.dart';
// import 'package:warlocks_of_the_beach/widgets/navigation/main_appbar.dart';
// import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
// import 'package:warlocks_of_the_beach/providers/character_provider.dart';
// import 'class_selection.dart';

// class RaceSelection extends ConsumerStatefulWidget {
//   const RaceSelection({super.key});

//   @override
//   _RaceSelectionState createState() => _RaceSelectionState();
// }

// class _RaceSelectionState extends ConsumerState<RaceSelection> {
//   String _selectedRace = 'Elf'; // Default race
//   final Color customColor = const Color.fromARGB(255, 138, 28, 20);

//   // Updates the selected race and calls setState
//   void _updateSelectedRace(String raceName) {
//     setState(() {
//       _selectedRace = raceName;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final characterName = ref.watch(characterProvider).name;

//     return SingleChildScrollView(
//       child: Scaffold(
//         bottomNavigationBar: MainBottomNavBar(),
//         appBar: MainAppbar(),
//         drawer: MainDrawer(),
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 const SizedBox(height: 20),
//                 const Center(
//                   child: Text(
//                     'Pick your race',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Wrap(
//                   spacing: 10,
//                   runSpacing: 10,
//                   children: [
//                     ButtonWithPadding(
//                       onPressed: () => _updateSelectedRace('Aasimar'),
//                       textContent: 'Aasimar',
//                     ),
//                     ButtonWithPadding(
//                       onPressed: () => _updateSelectedRace('Dragonborn'),
//                       textContent: 'Dragonborn',
//                     ),
//                     ButtonWithPadding(
//                       onPressed: () => _updateSelectedRace('Dwarf'),
//                       textContent: 'Dwarf',
//                     ),
//                     ButtonWithPadding(
//                       onPressed: () => _updateSelectedRace('Elf'),
//                       textContent: 'Elf',
//                     ),
//                     ButtonWithPadding(
//                       onPressed: () => _updateSelectedRace('Gnome'),
//                       textContent: 'Gnome',
//                     ),
//                     ButtonWithPadding(
//                       onPressed: () => _updateSelectedRace('Halfling'),
//                       textContent: 'Halfling',
//                     ),
//                     ButtonWithPadding(
//                       onPressed: () => _updateSelectedRace('Human'),
//                       textContent: 'Human',
//                     ),
//                     ButtonWithPadding(
//                       onPressed: () => _updateSelectedRace('Orc'),
//                       textContent: 'Orc',
//                     ),
//                     ButtonWithPadding(
//                       onPressed: () => _updateSelectedRace('Tiefling'),
//                       textContent: 'Tiefling',
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: SizedBox(
//                     height: 350,
//                     width: 350,
//                     child: SingleChildScrollView(
//                       child: RaceDataLoader(raceName: _selectedRace),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Positioned(
//               left: 25,
//               bottom: 25,
//               child: FloatingActionButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Icon(Icons.arrow_back),
//               ),
//             ),
//             Positioned(
//               right: 25,
//               bottom: 25,
//               child: FloatingActionButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ClassSelection(
//                         characterName: characterName,
//                         race: _selectedRace,
//                       ),
//                     ),
//                   );
//                 },
//                 child: const Icon(Icons.arrow_forward),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
