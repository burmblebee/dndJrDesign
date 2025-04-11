import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/widgets/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'specifics_screen.dart';
import '../../data/character creator data/background_data.dart';
import '../../widgets/loaders/background_data_loader.dart';
import '../../widgets/buttons/navigation_button.dart';
import '../../widgets/navigation/main_drawer.dart';
import 'package:warlocks_of_the_beach/providers/character_provider.dart';

class BackgroundScreen extends ConsumerStatefulWidget {
  const BackgroundScreen({super.key});

  @override
  _BackgroundScreenState createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends ConsumerState<BackgroundScreen> {
  final backgrounds = BackgroundData;
  final Color customColor = const Color(0xFF25291C);
  String _selectedBackground = 'Acolyte';

  void updateSelectedBackground(String background) {
    setState(() {
      ref.read(characterProvider.notifier).updateSelectedBackground(background);
    });
  }

  @override
  Widget build(BuildContext context) {
    final characterName = ref.watch(characterProvider).name;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjusted height to include 40px buffer above BottomNav
    final availableHeight = screenHeight -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        40;

    return Scaffold(
      appBar: const MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: const MainBottomNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: availableHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Background Selection for $characterName",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Pick your background',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      DropdownButton<String>(
                        value: _selectedBackground,
                        items: backgrounds.keys
                            .map((background) => DropdownMenuItem(
                                  value: background,
                                  child: Text(background),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedBackground = value!),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Container(
                          width: 350,
                          height: 350,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SingleChildScrollView(
                            child: BackgroundDataLoader(
                              backgroundName: _selectedBackground,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: const Text("Back"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(characterProvider.notifier).updateSelectedBackground(_selectedBackground);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SpecificsScreen(),
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
              const SizedBox(height: 20), // Final 20px to reach total of 40px bottom margin
            ],
          ),
        ),
      ),
    );
  }
}
