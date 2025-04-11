import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/character_name.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
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
  final Color customColor = const Color(0xFF25291C);

  void _updateSelectedRace(String raceName) {
    setState(() {
      _selectedRace = raceName;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double availableHeight = MediaQuery.of(context).size.height -
        kToolbarHeight - // Height of the app bar
        kBottomNavigationBarHeight; // Height of the bottom navigation bar

    final characterName = ref.watch(characterProvider).name;

    return Scaffold(
      bottomNavigationBar: MainBottomNavBar(),
      appBar: MainAppbar(),
      drawer: MainDrawer(),
      body: SizedBox(
        height: availableHeight,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Race Selection for $characterName',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                    DropdownButton<String>(
                      value: _selectedRace,
                      dropdownColor: customColor,
                      elevation: 16,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      underline: Container(
                        height: 2,
                        color: customColor,
                      ),
                      onChanged: (String? newValue) {
                        _updateSelectedRace(newValue!);
                      },
                      items: <String>[
                        'Aasimar',
                        'Dragonborn',
                        'Dwarf',
                        'Elf',
                        'Gnome',
                        'Halfling',
                        'Human',
                        'Orc',
                        'Tiefling'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        );
                      }).toList(),
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
                  ],
                ),
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
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CharacterName())),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text("Back"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(characterProvider.notifier).updateSelectedRace(_selectedRace);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassSelection(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: const Text("Next"),
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
      ),
    );
  }
}