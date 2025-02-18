import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/dnd_forms/user_character_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import '../../widgets/buttons/navigation_button.dart';
import 'package:http/http.dart' as http;

import '../../widgets/dnd_form_widgets/main_drawer.dart';


class ImageGenerator extends StatefulWidget {
  const ImageGenerator({super.key, required this.characterName});

  final characterName;

  @override
  _ImageGeneratorState createState() => _ImageGeneratorState();
}

class _ImageGeneratorState extends State<ImageGenerator> {
  //TODO: Fetch everything from firestore instead of hardcoding
  var selectedRace;
  var selectedClass;
  var selectedSkin;
  var selectedGender;
  var selectedHair;
  var characterName;
  var imageURL;

  @override
  void initState() {
    super.initState();
    _fetchTraits(); 
    // _fetchCharacterData();
    // prompt =
    //     'A dnd $selectedRace $selectedClass $selectedSkin $selectedGender with $selectedHair hair';
    // generateImage(prompt, 17);
  }


  void _fetchTraits() async {
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      final docRef = FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(currentUserUid)
          .collection('characters')
          .doc(widget.characterName);

      try {
        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data.containsKey('characterTraits')) {
            final traits = data['characterTraits'] as Map<String, dynamic>;

            // Update state with fetched data
            setState(() {
              // selectedRace = traits['race'] ?? ;
              // selectedClass = traits['class'] ?? selectedClass;
              selectedSkin = traits['skin'] ?? 'light';
              selectedGender = traits['gender'] ?? 'male';
              selectedHair = traits['hair'] ?? 'brown';
              characterName = widget.characterName; // Keep the provided name
            });
          }
        }
      } catch (e) {
        print('Error fetching traits: $e');
      }
      try {
        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data.containsKey('race')) {
            // final traits = data['characterTraits'] as Map<String, dynamic>;
            // final selectedRace = data['race'];
            // final selectedClass = data['class'];

            // Update state with fetched data
            setState(() {
               selectedRace = data['race'] ?? 'human';
               selectedClass = data['class'] ?? 'fighter';
            });
          }
        }
      } catch (e) {
        print('Error fetching traits: $e');
      }
      prompt =
        'A dnd $selectedRace $selectedClass $selectedSkin $selectedGender with $selectedHair hair';
        generateImage(prompt, 17);

    }
  }
// void _fetchCharacterData() async {
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
//           final data = docSnapshot.data();
//           if (data != null && data.containsKey('race')) {
//             // final traits = data['characterTraits'] as Map<String, dynamic>;
//             // final selectedRace = data['race'];
//             // final selectedClass = data['class'];

//             // Update state with fetched data
//             setState(() {
//                selectedRace = data['race'] ?? 'human';
//                selectedClass = data['class'] ?? 'fighter';
//             });
//           }
//         }
//       } catch (e) {
//         print('Error fetching traits: $e');
//       }
//     }
//   }


  late String prompt = '';
  final Color customColor = const Color.fromARGB(255, 138, 28, 20);

  // final TextEditingController _controller = TextEditingController();
  final controller = ConfettiController();

  String _imageUrl = '';
  bool _isLoading = false;
  String _statusMessage = '';

  final String apiKey = 'jdsoZhEdWDXOYXT2CTLzVvCV5nXSeAD6';

  

  Future<String> createTask() async {
    final url = Uri.parse('https://api.luan.tools/api/tasks/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({'use_target_image': false}),
    );

    //print('Create Task Response: ${response.body}'); // Debugging output
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['id']; // Return task ID
    } else {
      throw Exception('Failed to create task: ${response.body}');
    }
  }

  Future<void> updateTask(String taskId, String prompt, int styleId) async {
    final url = Uri.parse('https://api.luan.tools/api/tasks/$taskId');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'input_spec': {
          'style': styleId,
          'prompt': prompt,
          //    'target_image_weight': 0.1,
          'width': 1000,
          'height': 1000,
        },
      }),
    );

    //  print('Update Task Response: ${response.body}'); // Debugging output
    if (response.statusCode != 200) {
      throw Exception('Failed to update task: ${response.body}');
    }
  }

  Future<String> checkTaskStatus(String taskId) async {
    final url = Uri.parse('https://api.luan.tools/api/tasks/$taskId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );

    //  print('Check Task Status Response: ${response.body}'); // Debugging output
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final state = data['state'];

      if (state == 'completed') {
        return data['result']; // Return image URL when completed
      } else if (state == 'failed') {
        //   print('Task failed: ${data['reason']}'); // Log the failure reason
        throw Exception('Image generation failed: ${data['reason']}');
      } else {
        return 'generating'; // Still generating
      }
    } else {
      throw Exception('Failed to check task status: ${response.body}');
    }
  }

  Future<void> generateImage(String prompt, int styleId) async {
    try {
      setState(() {
        _isLoading = true;
        _statusMessage = 'Generating image...';
      });

      // Step 1: Create Task
      String taskId = await createTask();
      //   print('Task created with ID: $taskId');

      // Step 2: Update Task with prompt and style
      await updateTask(taskId, prompt, styleId);
      //  print('Task updated with prompt and style');

      // Step 3: Poll task status until completed
      String state = 'generating';
      while (state == 'generating') {
        await Future.delayed(
            Duration(seconds: 4)); // Wait before checking again
        state = await checkTaskStatus(taskId);

        if (state != 'generating') {
          //      print('Generated image URL: $state'); // Debugging output
          setState(() {
            _imageUrl = state;
            _isLoading = false;
            _statusMessage = '';
          });
        } else {
          setState(() {
            _statusMessage = 'Still generating...';
          });
        }
      }
    } catch (e) {
      //   print('Error during image generation: $e'); // Log the error
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error: $e';
      });
    }
    if (_imageUrl.isNotEmpty) {
      Confetti.launch(
        context,
        options: ConfettiOptions(
            particleCount: 300,
            spread: 70,
            y: 0.6,
            colors: [
              customColor,
              Colors.black,
              Colors.deepPurple
            ]),
      );
    }

    //send imageURL to firestore
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      final docRef = FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(currentUserUid)
          .collection('characters')
          .doc(widget.characterName); // Use the UID directly

      try {
        await docRef.set({
          'imageUrl': _imageUrl,
        }, SetOptions(merge: true)); // Merge ensures only this field is updated
      } catch (e) {
        print('Error saving imageURL: $e');
      }
    }
  }

//   Future<String?> _getImageURL() async {
//   final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

//   if (currentUserUid != null) {
//     try {
//       final docSnapshot = await FirebaseFirestore.instance
//           .collection('app_user_profiles')
//           .doc(currentUserUid)
//           .collection('characters')
//           .doc(widget.characterName)
//           .get();

//       if (docSnapshot.exists) {
//         return docSnapshot.data()?['imageURL'] as String?;
//       } else {
//         debugPrint('Document does not exist.');
//       }
//     } catch (e) {
//       debugPrint('Error fetching imageURL: $e');
//     }
    
//   }
//   return null;
// }

// void _fetchImageURL() async {
//   final url = await _getImageURL();
//   setState(() {
//     imageURL = url;
//   });
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearly Done'),
        backgroundColor: customColor,foregroundColor: Colors.white,
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: Row(
        children: [
          NavigationButton(
            textContent: "Back",
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 30),
          NavigationButton(
            onPressed: () {
              //TODO: Push next screen
              //TODO: Send url to firestore
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserCharacterScreen(), // Pass characterName
                ),
              );
            },
            textContent: 'Finish',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 400,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(characterName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24, overflow: TextOverflow.ellipsis)),
                  ),
                ),
                Text(_statusMessage),
                if (_imageUrl.isNotEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Image.network(
                        _imageUrl,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const CircularProgressIndicator();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                      const SizedBox(height: 62),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
