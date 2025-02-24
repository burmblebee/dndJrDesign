import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'specifics_screen.dart';
import '../../data/character creator data/background_data.dart';
import '../../widgets/loaders/background_data_loader.dart';
import '../../widgets/buttons/navigation_button.dart';
import '../../widgets/navigation/main_drawer.dart';

class BackgroundScreen extends StatefulWidget {
  const BackgroundScreen({super.key, required this.characterName, required this.className, required this.raceName});
  final String characterName;
  final String className;
  final String raceName;

  @override
  State<StatefulWidget> createState() => _BackgroundScreenState();
}

class _BackgroundScreenState extends State<BackgroundScreen> {
  final backgrounds = BackgroundData;
  final Color customColor = const Color.fromARGB(255, 138, 28, 20);
  String _selectedBackground = 'Acolyte';

  // Save selection to Firebase
  void _saveSelections() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated');
      return;
    }
    final userId = user.uid;
    final docRef = FirebaseFirestore.instance.collection('app_user_profiles').doc(userId);

    try {
      await docRef.set({
        'background': _selectedBackground,
        'name': widget.characterName,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving background: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Background for ${widget.characterName}"),
        backgroundColor: customColor,
        foregroundColor: Colors.white,
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavigationButton(
              onPressed: () => Navigator.pop(context),
              textContent: 'Back',
            ),
            NavigationButton(
              textContent: "Next",
              onPressed: () {
                _saveSelections();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpecificsScreen(
                      characterName: widget.characterName,
                      className: widget.className,
                      raceName: widget.raceName,
                      backgroundName: _selectedBackground,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Pick your background',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: _selectedBackground,
            items: backgrounds.keys.map((background) => DropdownMenuItem(
              value: background,
              child: Text(background),
            )).toList(),
            onChanged: (value) => setState(() => _selectedBackground = value!),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
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
        ],
      ),
    );
  }
}
