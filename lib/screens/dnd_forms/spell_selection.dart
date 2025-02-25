import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import '../../widgets/loaders/cantrip_data_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/buttons/navigation_button.dart';

class CantripSelection extends StatefulWidget {
  const CantripSelection({super.key, required this.characterName});

  final String characterName;

  @override
  _CantripSelectionState createState() => _CantripSelectionState();
}

class _CantripSelectionState extends State<CantripSelection> {
  late String characterClass;
  late List<String> knownCantrips = [];  // Initialize as empty list

  late Widget mainContent;
  late String cantripOne = "None";
  late String cantripTwo = "None";
  late String cantripThree = "None";
  late String cantripFour = "None";
  final customColor = const Color.fromARGB(255, 35, 20, 19);

  String _currentSection = 'Cantrip 1';

  // Define the cantrips for each class directly here
  final Map<String, Map<String, dynamic>> spellsByClass = {
    "Barbarian": {
      "Cantrips": [], // No spellcasting for Barbarians by default
    },
    "Bard": {
      "Cantrips": [
        "None", "Blade Ward", "Dancing Lights", "Friends", "Light", "Mage Hand", "Mending", 
        "Message", "Minor Illusion", "Prestidigitation", "True Strike", "Vicious Mockery",
      ],
    },
    "Cleric": {
      "Cantrips": [
        "None", "Guidance", "Light", "Mending", "Resistance", "Sacred Flame", "Spare the Dying", 
        "Thaumaturgy",
      ],
    },
    "Druid": {
      "Cantrips": [
        "None", "Control Flames", "Create Bonfire", "Druidcraft", "Frostbite", "Guidance", "Gust", 
        "Magic Stone", "Mending", "Mold Earth", "Poison Spray", "Produce Flame", "Resistance", 
        "Shape Water", "Shillelagh", "Thorn Whip",
      ],
    },
    "Sorcerer": {
      "Cantrips": [
        "None", "Acid Splash", "Blade Ward", "Chill Touch", "Dancing Lights", "Fire Bolt", "Friends", 
        "Light", "Mage Hand", "Mending", "Message", "Minor Illusion", "Poison Spray", 
        "Prestidigitation", "Ray of Frost", "Shocking Grasp", "True Strike",
      ],
    },
    "Warlock": {
      "Cantrips": [
        "None", "Blade Ward", "Chill Touch", "Create Bonfire", "Eldritch Blast", "Friends", 
        "Mage Hand", "Minor Illusion", "Prestidigitation", "True Strike",
      ],
    },
    "Wizard": {
      "Cantrips": [
        "None", "Acid Splash", "Blade Ward", "Chill Touch", "Control Flames", "Create Bonfire", 
        "Dancing Lights", "Fire Bolt", "Friends", "Frostbite", "Gust", "Light", "Mage Hand", 
        "Mending", "Message", "Minor Illusion", "Mold Earth", "Poison Spray", "Prestidigitation", 
        "Ray of Frost", "Shape Water", "Shocking Grasp", "Thunderclap", "True Strike",
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _getClass();
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
            // Populate the knownCantrips based on class
            knownCantrips = spellsByClass[characterClass]?['Cantrips'] ?? [];
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

  void _saveSelections() async {
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      final docRef = FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(currentUserUid)
          .collection('characters')
          .doc(widget.characterName); // Use the UID directly

      try {
        await docRef.set({
          'cantripOne': cantripOne,
          'cantripTwo': cantripTwo,
          'cantripThree': cantripThree,
          'cantripFour': cantripFour,
        }, SetOptions(merge: true)); // Merge ensures only this field is updated
      } catch (e) {
        print('Error saving cantrips: $e');
      }
    }
  }

  Widget cantripSelectionScreen(String cantrip, Function(String?) onChanged) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select $cantrip',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: cantrip == "Cantrip 1" ? cantripOne :
                     cantrip == "Cantrip 2" ? cantripTwo :
                     cantrip == "Cantrip 3" ? cantripThree : cantripFour,
              hint: Text('Select your $cantrip cantrip'),
              items: knownCantrips.isNotEmpty
                  ? knownCantrips.map((String cantripName) {
                      return DropdownMenuItem<String>(
                        value: cantripName,
                        child: Text(cantripName),
                      );
                    }).toList()
                  : [DropdownMenuItem<String>(value: "None", child: Text("No Cantrips Available"))],
              onChanged: onChanged,
            ),
            if (cantrip == "Cantrip 1" && cantripOne != "None")
              CantripDataLoader(cantripName: cantripOne, className: characterClass),
            if (cantrip == "Cantrip 2" && cantripTwo != "None")
              CantripDataLoader(cantripName: cantripTwo, className: characterClass),
            if (cantrip == "Cantrip 3" && cantripThree != "None")
              CantripDataLoader(cantripName: cantripThree, className: characterClass),
            if (cantrip == "Cantrip 4" && cantripFour != "None")
              CantripDataLoader(cantripName: cantripFour, className: characterClass),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentSection == 'Cantrip 1') {
      mainContent = cantripSelectionScreen("Cantrip 1", (newValue) {
        setState(() {
          cantripOne = newValue ?? "None";
        });
      });
    } else if (_currentSection == 'Cantrip 2') {
      mainContent = cantripSelectionScreen("Cantrip 2", (newValue) {
        setState(() {
          cantripTwo = newValue ?? "None";
        });
      });
    } else if (_currentSection == 'Cantrip 3') {
      mainContent = cantripSelectionScreen("Cantrip 3", (newValue) {
        setState(() {
          cantripThree = newValue ?? "None";
        });
      });
    } else if (_currentSection == 'Cantrip 4') {
      mainContent = cantripSelectionScreen("Cantrip 4", (newValue) {
        setState(() {
          cantripFour = newValue ?? "None";
        });
      });
    } else {
      mainContent = Container();
    }

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text("Cantrip Selection"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSelections,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Text(
            widget.characterName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 35),
          mainContent,
        ],
      ),
    );
  }
}












// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dnd_character_creator/widgets/loaders/cantrip_data_loader.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../../widgets/dnd_form_widgets/main_drawer.dart';
// import 'package:dnd_character_creator/widgets/buttons/navigation_button.dart';

// class CantripSelection extends StatefulWidget {
//   const CantripSelection({super.key, required this.characterName});

//   final characterName;

//   @override
//   _CantripSelectionState createState() => _CantripSelectionState();
// }

// class _CantripSelectionState extends State<CantripSelection> {
//   final List<String> cantrips = [
//     'None',
//     'Fire Bolt',
//     'Prestidigitation',
//     'Mage Hand',
//     'Light',
//     'Shocking Grasp',
//     'Ray of Frost',
//     // Add other cantrips here
//   ];

//   late Widget mainContent;
//   late var cantripOne = "None";
//   late var cantripTwo = "None";
//   late var cantripThree = "None";
//   late var cantripFour = "None";
//   final customColor = const Color.fromARGB(255, 138, 28, 20);

//   final TextEditingController _firstCantripController = TextEditingController();
//   final TextEditingController _secondCantripController = TextEditingController();
//   final TextEditingController _thirdCantripController = TextEditingController();
//   final TextEditingController _fourthCantripController = TextEditingController();

//   String _currentSection = 'Cantrip 1';
//   late Future<String> _classNameFuture;

//   // Fetch className from Firestore for the selected character
//   Future<String> _fetchClassName() async {
//     final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUserUid != null) {
//       final docRef = FirebaseFirestore.instance
//           .collection('app_user_profiles')
//           .doc(currentUserUid)
//           .collection('characters')
//           .doc(widget.characterName);

//       try {
//         final docSnapshot = await docRef.get();
//         if (docSnapshot.exists) {
//           return docSnapshot.get('className') ?? 'Unknown Class';
//         }
//         return 'Unknown Class'; // Default if className is not found
//       } catch (e) {
//         print('Error fetching class name: $e');
//         return 'Error';
//       }
//     }
//     return 'Error'; // Default if no user UID
//   }

//   void _saveSelections() async {
//     final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUserUid != null) {
//       final docRef = FirebaseFirestore.instance
//           .collection('app_user_profiles')
//           .doc(currentUserUid)
//           .collection('characters')
//           .doc(widget.characterName); // Use the UID directly

//       try {
//         await docRef.set({
//           'cantripOne': cantripOne,
//           'cantripTwo': cantripTwo,
//           'cantripThree': cantripThree,
//           'cantripFour': cantripFour,
//         }, SetOptions(merge: true)); // Merge ensures only this field is updated
//       } catch (e) {
//         print('Error saving cantrips: $e');
//       }
//     }
//   }

//   Widget cantripOneScreen(String className) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Cantrip 1',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             DropdownButton<String>(
//               value: cantripOne,
//               hint: Text('Select a cantrip'),
//               items: cantrips.map((String cantrip) {
//                 return DropdownMenuItem<String>(
//                   value: cantrip,
//                   child: Text(cantrip),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   cantripOne = newValue ?? "None";
//                 });
//               },
//             ),
//             if (cantripOne.isNotEmpty)
//               CantripDataLoader(
//                 className: className,
//                 cantripName: cantripOne,
//               ),
//             const SizedBox(height: 35),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget cantripTwoScreen(String className) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Cantrip 2',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             DropdownButton<String>(
//               value: cantripTwo,
//               hint: Text('Select a cantrip'),
//               items: cantrips.map((String cantrip) {
//                 return DropdownMenuItem<String>(
//                   value: cantrip,
//                   child: Text(cantrip),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   cantripTwo = newValue ?? "None";
//                 });
//               },
//             ),
//             if (cantripTwo.isNotEmpty)
//               CantripDataLoader(
//                 className: className,
//                 cantripName: cantripTwo,
//               ),
//             const SizedBox(height: 35),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget cantripThreeScreen(String className) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Cantrip 3',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             DropdownButton<String>(
//               value: cantripThree,
//               hint: Text('Select a cantrip'),
//               items: cantrips.map((String cantrip) {
//                 return DropdownMenuItem<String>(
//                   value: cantrip,
//                   child: Text(cantrip),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   cantripThree = newValue ?? "None";
//                 });
//               },
//             ),
//             if (cantripThree.isNotEmpty)
//               CantripDataLoader(
//                 className: className,
//                 cantripName: cantripThree,
//               ),
//             const SizedBox(height: 35),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget cantripFourScreen(String className) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Cantrip 4',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//             const SizedBox(height: 10),
//             DropdownButton<String>(
//               value: cantripFour,
//               hint: Text('Select a cantrip'),
//               items: cantrips.map((String cantrip) {
//                 return DropdownMenuItem<String>(
//                   value: cantrip,
//                   child: Text(cantrip),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   cantripFour = newValue ?? "None";
//                 });
//               },
//             ),
//             if (cantripFour.isNotEmpty)
//               CantripDataLoader(
//                 className: className,
//                 cantripName: cantripFour,
//               ),
//             const SizedBox(height: 35),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String>(
//       future: _fetchClassName(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text("Cantrip Selection"),
//             ),
//             body: const Center(child: CircularProgressIndicator()),
//           );
//         } else if (snapshot.hasError) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text("Cantrip Selection"),
//             ),
//             body: Center(child: Text('Error: ${snapshot.error}')),
//           );
//         } else if (snapshot.hasData) {
//           String className = snapshot.data!;
//           if (_currentSection == 'Cantrip 1') {
//             mainContent = cantripOneScreen(className);
//           } else if (_currentSection == 'Cantrip 2') {
//             mainContent = cantripTwoScreen(className);
//           } else if (_currentSection == 'Cantrip 3') {
//             mainContent = cantripThreeScreen(className);
//           } else if (_currentSection == 'Cantrip 4') {
//             mainContent = cantripFourScreen(className);
//           }
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text("Cantrip Selection"),
//             ),
//             drawer: const MainDrawer(),
//             body: mainContent,
//             bottomNavigationBar: Padding(
//               padding: const EdgeInsets.all(8.0),
//               // child: NavigationButton(
//               //   buttonText: 'Save',
//               //   onPressed: _saveSelections,
//               // ),
//             ),
//           );
//         }
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text("Cantrip Selection"),
//           ),
//           body: const Center(child: Text('No data found')),
//         );
//       },
//     );
//   }
// }
