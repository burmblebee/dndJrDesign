// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io'; // Import the dart:io package
// import '../widgets/main_appbar.dart';
// import '../widgets/main_drawer.dart';
// import '../widgets/bottom_navbar.dart';

// class NewCampaignScreen extends StatefulWidget {
//   const NewCampaignScreen({super.key});

//   @override
//   _NewCampaignScreenState createState() => _NewCampaignScreenState();
// }

// class _NewCampaignScreenState extends State<NewCampaignScreen> {
//   final _formKeyJoinCode = GlobalKey<FormState>();
//   final _formKeyNewCampaign = GlobalKey<FormState>();
//   final _joinCodeController = TextEditingController();
//   final _campaignNameController = TextEditingController();
//   final _campaignDescriptionController = TextEditingController();
//   bool _isPublic = false;
//   XFile? _imageFile;

//   @override
//   void dispose() {
//     _joinCodeController.dispose();
//     _campaignNameController.dispose();
//     _campaignDescriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _imageFile = pickedFile;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context).primaryColor;

//     return Scaffold(
//       appBar: const MainAppbar(),
//       drawer: const MainDrawer(),
//       bottomNavigationBar: const MainBottomNavBar(),
//       backgroundColor: theme,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Form(
//                   key: _formKeyJoinCode,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Center(
//                         child: Text(
//                           'Do you have a join code?',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _joinCodeController,
//                         decoration: const InputDecoration(

//                           border: OutlineInputBorder(),
//                           labelText: 'Enter join code',
//                           labelStyle: TextStyle(color: Colors.white),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                         ),
//                         style: const TextStyle(color: Colors.white),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a join code';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_formKeyJoinCode.currentState!.validate()) {
//                             // Process the join code
//                             print('Join code: ${_joinCodeController.text}');
//                           }
//                         },
//                         child: const Center(child: Text('Submit Join Code')),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Form(
//                   key: _formKeyNewCampaign,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Center(
//                         child: Text(
//                           'Create a new campaign',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _campaignNameController,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Campaign Name',
//                           labelStyle: TextStyle(color: Colors.white),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                         ),
//                         style: const TextStyle(color: Colors.white),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a campaign name';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       TextFormField(
//                         controller: _campaignDescriptionController,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Description',
//                           labelStyle: TextStyle(color: Colors.white),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                         ),
//                         style: const TextStyle(color: Colors.white),
//                         maxLines: 3,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a description';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             'Public',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           Switch(
//                             value: _isPublic,
//                             onChanged: (value) {
//                               setState(() {
//                                 _isPublic = value;
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: _pickImage,
//                         child: const Center(child: Text('Pick an Image')),
//                       ),
//                       if (_imageFile != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: Image.file(
//                             File(_imageFile!.path), // Ensure File is imported from dart:io
//                             height: 100,
//                           ),
//                         ),
//                       const SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           if (_formKeyNewCampaign.currentState!.validate()) {
//                             // Process the new campaign
//                             print('Campaign Name: ${_campaignNameController.text}');
//                             print('Description: ${_campaignDescriptionController.text}');
//                             print('Is Public: $_isPublic');
//                             if (_imageFile != null) {
//                               print('Image Path: ${_imageFile!.path}');
//                             }
//                           }
//                         },
//                         child: const Center(child: Text('Submit New Campaign')),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }