import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/dnd_forms/character_trait_selection.dart';
import '../../widgets/buttons/navigation_button.dart';
import '../../widgets/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CantripSelection extends StatefulWidget {
  const CantripSelection({super.key, required this.characterName});

  final String characterName;

  @override
  _CantripSelectionState createState() => _CantripSelectionState();
}

class _CantripSelectionState extends State<CantripSelection> {
  late List<String> currentCantrips;
  late String? characterClass;
  
  late String cantripOne = "None";
  late String cantripTwo = "None";
  late String cantripThree = "None";
  late String cantripFour = "None";

  final customColor = const Color.fromARGB(255, 138, 28, 20);

  final List<String> clericCantrips = [
    'None',
    'Guidance',
    'Light',
    'Mending',
    'Resistance',
    'Sacred Flame',
    'Spare the Dying',
    'Thaumaturgy',
  ];
  final List<String> warlockCantrips = [
    'None',
    'Blade Ward',
    'Chill Touch',
    'Create Bonfire',
    'Eldritch Blast',
    'Friends',
    'Mage Hand',
    'Minor Illusion',
    'Prestidigitation',
    'True Strike',
  ];
  final List<String> druidCantrips = [
    'None',
    'Druidcraft',
    'Guidance',
    'Mending',
    'Poison Spray',
    'Produce Flame',
    'Resistance',
    'Shillelagh',
    'Thorn Whip',
  ];
  final List<String> wizardCantrips = [
    'None',
    'Acid Splash',
    'Blade Ward',
    'Chill Touch',
    'Control Flames',
    'Create Bonfire',
    'Dancing Lights',
    'Fire Bolt',
    'Friends',
    'Frostbite',
    'Gust',
    'Light',
    'Mage Hand',
    'Mending',
    'Message',
    'Minor Illusion',
    'Mold Earth',
    'Poison Spray',
    'Prestidigitation',
    'Ray of Frost',
    'Shape Water',
    'Shocking Grasp',
    'Thunderclap',
    'True Strike',
  ];
  final List<String> sorcererCantrips = [
    'None',
    'Acid Splash',
    'Blade Ward',
    'Chill Touch',
    'Dancing Lights',
    'Fire Bolt',
    'Friends',
    'Light',
    'Mage Hand',
    'Mending',
    'Message',
    'Minor Illusion',
    'Poison Spray',
    'Prestidigitation',
    'Ray of Frost',
    'Shocking Grasp',
    'True Strike',
  ];
  final List<String> bardCantrips = [
    'None',
    'Blade Ward',
    'Dancing Lights',
    'Friends',
    'Light',
    'Mage Hand',
    'Mending',
    'Message',
    'Minor Illusion',
    'Prestidigitation',
    'True Strike',
    'Vicious Mockery',
  ];

  @override
  void initState() {
    super.initState();
    currentCantrips = [];
    _getClass();
    setCantrips(characterClass!);
  }

  Future<void> _getClass() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User not authenticated');
      return;
    }
    final currentUserUid = user.uid;

    try {
      final docRef = FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(currentUserUid)
          .collection('characters')
          .doc(widget.characterName);

      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('class')) {
          setState(() {
            characterClass = data['class'];
            setCantrips(characterClass!);
          });
        } else {
          print('Class field does not exist in the document');
        }
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error getting class: $e');
    }
  }

  void setCantrips(String className) {
    switch (className) {
      case 'Cleric':
        currentCantrips = clericCantrips;
        break;
      case 'Warlock':
        currentCantrips = warlockCantrips;
        break;
      case 'Druid':
        currentCantrips = druidCantrips;
        break;
      case 'Wizard':
        currentCantrips = wizardCantrips;
        break;
      case 'Sorcerer':
        currentCantrips = sorcererCantrips;
        break;
      case 'Bard':
        currentCantrips = bardCantrips;
        break;
      default:
        currentCantrips = ['None'];
    }
  }

  void _saveSelections() async {
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      final docRef = FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(currentUserUid)
          .collection('characters')
          .doc(widget.characterName);

      try {
        await docRef.set({
          'cantripOne': cantripOne,
          'cantripTwo': cantripTwo,
          'cantripThree': cantripThree,
          'cantripFour': cantripFour,
        }, SetOptions(merge: true));
      } catch (e) {
        print('Error saving cantrips: $e');
      }
    }
  }

  Widget dropdownSelection(
      String title, String selectedValue, Function(String?) onChanged) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedValue,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: currentCantrips
                  .map((cantrip) =>
                  DropdownMenuItem(value: cantrip, child: Text(cantrip)))
                  .toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cantrip Selection'),
        backgroundColor: customColor,
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavigationButton(
            textContent: "Back",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          NavigationButton(
            textContent: 'Next',
            onPressed: () {
                 _saveSelections(); // Save class selection before navigating
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterTraitScreen(characterName: widget.characterName,),
                ),
              );
            },
          ),
        ],
      ),

      body: characterClass == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            dropdownSelection(
              'Cantrip 1',
              cantripOne,
                  (value) => setState(() => cantripOne = value!),
            ),
            dropdownSelection(
              'Cantrip 2',
              cantripTwo,
                  (value) => setState(() => cantripTwo = value!),
            ),
            dropdownSelection(
              'Cantrip 3',
              cantripThree,
                  (value) => setState(() => cantripThree = value!),
            ),
            dropdownSelection(
              'Cantrip 4',
              cantripFour,
                  (value) => setState(() => cantripFour = value!),
            ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: customColor,
            //     foregroundColor: Colors.white,
            //   ),
            //   onPressed: (){},// _saveSelections,
            //   child: const Text('Save Cantrips'),
            // ),
          ],
        ),
      ),

    );
  }
}







// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dnd_character_creator/screens/dnd_forms/character_trait_selection.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../../widgets/dnd_form_widgets/main_drawer.dart';
// import 'package:dnd_character_creator/widgets/buttons/navigation_button.dart';

// class CantripSelection extends StatefulWidget {
//   const CantripSelection({super.key, required this.characterName});

//   final String characterName;

//   @override
//   _CantripSelectionState createState() => _CantripSelectionState();
// }

// class _CantripSelectionState extends State<CantripSelection> {
//   late List<String> currentCantrips;
//   late String? characterClass;
//   String _currentSection = 'Cantrip 1';

//   late String cantripOne = "None";
//   late String cantripTwo = "None";
//   late String cantripThree = "None";
//   late String cantripFour = "None";

//   final customColor = const Color.fromARGB(255, 138, 28, 20);

//   final List<String> clericCantrips = [
//     'None',
//     'Guidance',
//     'Light',
//     'Mending',
//     'Resistance',
//     'Sacred Flame',
//     'Spare the Dying',
//     'Thaumaturgy',
//   ];
//   final List<String> warlockCantrips = [
//     'None',
//     'Blade Ward',
//     'Chill Touch',
//     'Create Bonfire',
//     'Eldritch Blast',
//     'Friends',
//     'Mage Hand',
//     'Minor Illusion',
//     'Prestidigitation',
//     'True Strike',
//   ];
//   final List<String> druidCantrips = [
//     'None',
//     'Druidcraft',
//     'Guidance',
//     'Mending',
//     'Poison Spray',
//     'Produce Flame',
//     'Resistance',
//     'Shillelagh',
//     'Thorn Whip',
//   ];
//   final List<String> wizardCantrips = [
//     'None',
//     'Acid Splash',
//     'Blade Ward',
//     'Chill Touch',
//     'Control Flames',
//     'Create Bonfire',
//     'Dancing Lights',
//     'Fire Bolt',
//     'Friends',
//     'Frostbite',
//     'Gust',
//     'Light',
//     'Mage Hand',
//     'Mending',
//     'Message',
//     'Minor Illusion',
//     'Mold Earth',
//     'Poison Spray',
//     'Prestidigitation',
//     'Ray of Frost',
//     'Shape Water',
//     'Shocking Grasp',
//     'Thunderclap',
//     'True Strike',
//   ];
//   final List<String> sorcererCantrips = [
//     'None',
//     'Acid Splash',
//     'Blade Ward',
//     'Chill Touch',
//     'Dancing Lights',
//     'Fire Bolt',
//     'Friends',
//     'Light',
//     'Mage Hand',
//     'Mending',
//     'Message',
//     'Minor Illusion',
//     'Poison Spray',
//     'Prestidigitation',
//     'Ray of Frost',
//     'Shocking Grasp',
//     'True Strike',
//   ];
//   final List<String> bardCantrips = [
//     'None',
//     'Blade Ward',
//     'Dancing Lights',
//     'Friends',
//     'Light',
//     'Mage Hand',
//     'Mending',
//     'Message',
//     'Minor Illusion',
//     'Prestidigitation',
//     'True Strike',
//     'Vicious Mockery',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     currentCantrips = [];
//     _getClass();
//   }

//   Future<void> _getClass() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       print('User not authenticated');
//       return;
//     }
//     final currentUserUid = user.uid;

//     try {
//       final docRef = FirebaseFirestore.instance
//           .collection('app_user_profiles')
//           .doc(currentUserUid)
//           .collection('characters')
//           .doc(widget.characterName);

//       final docSnapshot = await docRef.get();
//       if (docSnapshot.exists) {
//         final data = docSnapshot.data();
//         if (data != null && data.containsKey('class')) {
//           setState(() {
//             characterClass = data['class'];
//             setCantrips(characterClass!);
//           });
//         } else {
//           print('Class field does not exist in the document');
//         }
//       } else {
//         print('Document does not exist');
//       }
//     } catch (e) {
//       print('Error getting class: $e');
//     }
//   }

//   void setCantrips(String className) {
//     switch (className) {
//       case 'Cleric':
//         currentCantrips = clericCantrips;
//         break;
//       case 'Warlock':
//         currentCantrips = warlockCantrips;
//         break;
//       case 'Druid':
//         currentCantrips = druidCantrips;
//         break;
//       case 'Wizard':
//         currentCantrips = wizardCantrips;
//         break;
//       case 'Sorcerer':
//         currentCantrips = sorcererCantrips;
//         break;
//       case 'Bard':
//         currentCantrips = bardCantrips;
//         break;
//       default:
//         currentCantrips = ['None'];
//     }
//   }

//   void _saveSelections() async {
//     final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUserUid != null) {
//       final docRef = FirebaseFirestore.instance
//           .collection('app_user_profiles')
//           .doc(currentUserUid)
//           .collection('characters')
//           .doc(widget.characterName);

//       try {
//         await docRef.set({
//           'cantripOne': cantripOne,
//           'cantripTwo': cantripTwo,
//           'cantripThree': cantripThree,
//           'cantripFour': cantripFour,
//         }, SetOptions(merge: true));
//       } catch (e) {
//         print('Error saving cantrips: $e');
//       }
//     }
//   }

//   Widget dropdownSelection(
//       String title, String selectedValue, Function(String?) onChanged) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             DropdownButtonFormField<String>(
//               value: selectedValue,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               items: currentCantrips
//                   .map((cantrip) =>
//                       DropdownMenuItem(value: cantrip, child: Text(cantrip)))
//                   .toList(),
//               onChanged: onChanged,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cantrip Selection'),
//         backgroundColor: customColor,
//       ),
//       drawer: const MainDrawer(),

//       body: characterClass == null
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   dropdownSelection(
//                     'Cantrip 1',
//                     cantripOne,
//                     (value) => setState(() => cantripOne = value!),
//                   ),
//                   dropdownSelection(
//                     'Cantrip 2',
//                     cantripTwo,
//                     (value) => setState(() => cantripTwo = value!),
//                   ),
//                   dropdownSelection(
//                     'Cantrip 3',
//                     cantripThree,
//                     (value) => setState(() => cantripThree = value!),
//                   ),
//                   dropdownSelection(
//                     'Cantrip 4',
//                     cantripFour,
//                     (value) => setState(() => cantripFour = value!),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: customColor,
//                     ),
//                     onPressed: _saveSelections,
//                     child: const Text('Save Cantrips'),
//                   ),
//                 ],
//               ),
//             ),
//       bottomNavigationBar: BottomAppBar(
//         padding: const EdgeInsets.all(
//           16.0,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             NavigationButton(
//               textContent: "Back",
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             NavigationButton(
//               textContent: 'Next',
//               onPressed: () {
//                 _saveSelections(); // Save class selection before navigating
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CharacterTraitScreen(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

