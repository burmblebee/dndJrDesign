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

  // Save selection to Firebase
  // void _saveSelections() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     print('User not authenticated');
  //     return;
  //   }
  //   final userId = user.uid;
  //   final docRef = FirebaseFirestore.instance.collection('app_user_profiles').doc(userId);

  //   try {
  //     await docRef.set({
  //       'background': _selectedBackground,
  //       'name': widget.characterName,
  //     }, SetOptions(merge: true));
  //   } catch (e) {
  //     print('Error saving background: $e');
  //   }
  // }\
  void updateSelectedBackground(String background) {
    setState(() {
      // _selectedBackground = background;
      ref.read(characterProvider.notifier).updateSelectedBackground(background);
    });
  }

  @override
  Widget build(BuildContext context) {
    final characterName = ref.watch(characterProvider).name;

    return Scaffold(
      appBar: MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
          Positioned(
            bottom: 16, 
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
                    ref.read(characterProvider.notifier).updateSelectedBackground(_selectedBackground);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpecificsScreen(),
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
    );
  }
}
