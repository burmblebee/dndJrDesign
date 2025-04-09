import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/race_selection.dart';
import 'package:warlocks_of_the_beach/widgets/loaders/class_data_loader.dart';

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
  final customColor = const Color(0xFF25291C);
  final List<String> classOptions = [
    'Barbarian',
    'Bard',
    'Cleric',
    'Druid',
    'Fighter',
    'Monk',
    'Paladin',
    'Ranger',
    'Rogue',
    'Sorcerer',
    'Warlock',
    'Wizard',
  ];

  @override
  Widget build(BuildContext context) {
    final characterName = ref.watch(characterProvider).name;

    return Scaffold(
      bottomNavigationBar: MainBottomNavBar(),
      appBar: MainAppbar(),
      drawer: MainDrawer(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    'Class Selection for $characterName',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Pick your class',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: DropdownButton<String>(
                      value: selectedClassName,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      underline: Container(
                        height: 2,
                        color: customColor,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedClassName = newValue!;
                        });
                      },
                      items: classOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RaceSelection()),
                  ),
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
                ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(characterProvider.notifier)
                        .updateSelectedClass(selectedClassName);
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
          ),
        ],
      ),
    );
  }
}
