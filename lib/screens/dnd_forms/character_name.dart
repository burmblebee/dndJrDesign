import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/home_screen.dart';
import 'package:warlocks_of_the_beach/screens/campaign_screen.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import 'race_selection.dart';
import 'package:warlocks_of_the_beach/providers/character_provider.dart';

class CharacterName extends ConsumerStatefulWidget {
  const CharacterName({super.key});

  @override
  _CharacterNameState createState() => _CharacterNameState();
}

class _CharacterNameState extends ConsumerState<CharacterName> {

  final Color customColor = const Color(0xFF25291C);

  final TextEditingController _characterNameController =
      TextEditingController();

  @override
  void dispose() {
    _characterNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double availableHeight = MediaQuery.of(context).size.height -
        kToolbarHeight - // Height of the app bar
        kBottomNavigationBarHeight; // Height of the bottom navigation bar

    return Scaffold(
      appBar: MainAppbar(),
      bottomNavigationBar: MainBottomNavBar(initialIndex: 0,),
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
                    Image.asset('assets/dragon.png', height: 244), // Fixed usage
                    const SizedBox(height: 20),
                    const Text(
                      'Enter your character name:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _characterNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Character Name',
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
                      if (_characterNameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Character name cannot be empty!'),
                          ),
                        );
                        return;
                      }
                      ref.read(characterProvider.notifier).updateCharacterName(_characterNameController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RaceSelection(),
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
