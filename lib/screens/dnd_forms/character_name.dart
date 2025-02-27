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
    return Scaffold(
      appBar: MainAppbar(),
      bottomNavigationBar: MainBottomNavBar(),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                color: Colors.black,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                const SizedBox(width: 30),
                ElevatedButton.icon(
                  onPressed: () {
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const HomePage(),
            //           ),
            //         ); // Navigate backgit
            //       },
            //       child: const Text('Back'),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {
            //         if (_characterNameController.text.isNotEmpty) {
            //           ref
            //               .read(characterProvider.notifier)
            //               .updateCharacterName(_characterNameController.text);
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => RaceSelection(),
            //             ),
            //           ); // Navigate to RaceSelection
            //         } else {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             const SnackBar(
            //               content: Text('Character name cannot be empty!'),
            //             ),
            //           );
            //         }
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
