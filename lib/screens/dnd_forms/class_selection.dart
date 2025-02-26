import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/race_selection.dart';
import 'package:warlocks_of_the_beach/widgets/buttons/button_with_padding.dart';
import 'package:warlocks_of_the_beach/widgets/buttons/navigation_button.dart';
import 'package:warlocks_of_the_beach/widgets/dnd_form_widgets/class_data_loader.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/providers/character_provider.dart';
import 'background_selection.dart';

class ClassSelection extends ConsumerStatefulWidget {
  const ClassSelection({Key? key}) : super(key: key);

  @override
  _ClassSelectionState createState() => _ClassSelectionState();
}

class _ClassSelectionState extends ConsumerState<ClassSelection> {
  String selectedClassName = 'Sorcerer'; // Default class

  // Updates the selected class and calls setState
  void updateSelectedClass(String className) {
    setState(() {
      selectedClassName = className;
    });
  }

  final customColor = const Color(0xFF25291C);

  @override
  Widget build(BuildContext context) {
    final characterName = ref.watch(characterProvider).name;
    final race = ref.watch(characterProvider).race;

    return Scaffold(
      bottomNavigationBar: MainBottomNavBar(),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       NavigationButton(
      //         textContent: "Back",
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       NavigationButton(
      //         textContent: 'Next',
      //         onPressed: () {
      //           ref.read(characterProvider.notifier).updateSelectedClass(selectedClassName);
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => BackgroundScreen(
      //                 characterName: characterName,
      //                 className: selectedClassName,
      //                 raceName: race,
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: customColor,
        foregroundColor: Colors.white,
        title: Text(
          'Class Selection for $characterName',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            const Text(
              'Pick your class',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Center(
              child: Wrap(
                spacing: 10, // Space between buttons
                runSpacing: 10, // Space between rows
                children: <Widget>[
                  ButtonWithPadding(
                    onPressed: () => updateSelectedClass('Barbarian'),
                    textContent: 'Barbarian',
                    color: Color(0xFF25291C),
                  ),
                  ButtonWithPadding(
                    onPressed: () => updateSelectedClass('Bard'),
                    textContent: 'Bard',
                    color: Color(0xFF25291C),
                  ),
                  ButtonWithPadding(
                    onPressed: () => updateSelectedClass('Cleric'),
                    textContent: 'Cleric',
                    color: Color(0xFF25291C),
                  ),
                  ButtonWithPadding(
                    onPressed: () => updateSelectedClass('Druid'),
                    textContent: 'Druid',
                    color: Color(0xFF25291C),
                  ),
                  ButtonWithPadding(
                    onPressed: () => updateSelectedClass('Fighter'),
                    textContent: 'Fighter',
                    color: Color(0xFF25291C),
                  ),
                  ButtonWithPadding(
                    onPressed: () => updateSelectedClass('Monk'),
                    textContent: 'Monk',
                    color: Color(0xFF25291C),
                  ),
                  ButtonWithPadding(
                    onPressed: () => updateSelectedClass('Paladin'),
                    textContent: 'Paladin',
                    color: Color(0xFF25291C),
                  ),
                  ButtonWithPadding(
                    onPressed: () => updateSelectedClass('Ranger'),
                    textContent: 'Ranger',
                    color: Color(0xFF25291C),
                  ),
                  ButtonWithPadding(
                    onPressed: () => updateSelectedClass('Rogue'),
                    textContent: 'Rogue',
                    color: Color(0xFF25291C),
                  ),
                  ButtonWithPadding(
                    onPressed: () => updateSelectedClass('Sorcerer'),
                    textContent: 'Sorcerer',
                    color: Color(0xFF25291C),
                  ),
                  ButtonWithPadding(
                    onPressed: () => updateSelectedClass('Warlock'),
                    textContent: 'Warlock',
                    color: Color(0xFF25291C),
                  ),
                  ButtonWithPadding(
                    onPressed: () => updateSelectedClass('Wizard'),
                    textContent: 'Wizard',
                    color: Color(0xFF25291C),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: 325,
                width: 325,
                child: SingleChildScrollView(
                  child: ClassDataWidget(className: selectedClassName),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RaceSelection())),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
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
                        builder: (context) => BackgroundScreen(),
                      ),
                    );
                  },
                  label: const Text("Next"),
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) =>
            //                     RaceSelection())); // Navigate backgit
            //       },
            //       child: const Text('Back'),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         ref
            //             .read(characterProvider.notifier)
            //             .updateSelectedClass(selectedClassName);
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => BackgroundScreen(),
            //           ),
            //         ); // Navigate to RaceSelection
            //       },
            //       child: const Text('Next'),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
