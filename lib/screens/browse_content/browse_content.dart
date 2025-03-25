import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import 'package:warlocks_of_the_beach/screens/browse_content/browse_items.dart'; // Corrected import

class BrowseContent extends StatefulWidget {
  const BrowseContent({Key? key}) : super(key: key);

  @override
  _BrowseContentState createState() => _BrowseContentState();
}

class _BrowseContentState extends State<BrowseContent> {
  
final itemsImage = 'assets/evocation-wizard-dnd-2024-2.webp';  
final spellsImage = 'assets/evocation-wizard-dnd-2024-2.webp';
final characterSheetImage = 'assets/evocation-wizard-dnd-2024-2.webp';


  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scaffold(
      appBar: MainAppbar(),
      drawer: MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            const Text(
              'Browse Items',
              style: TextStyle(fontSize: 18),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BrowseItems()));
              },
              child: Container(
                margin: const EdgeInsets.all(8.0),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: 2,
                      color: Colors.black,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.asset(
                  itemsImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 30),

            const Text(
              'Browse Premade Character Sheets',
              style: TextStyle(fontSize: 18),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(8.0),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: 2,
                      color: Colors.black,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.asset(
                  characterSheetImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 30),
            const Text(
              'Browse Custom Spells',
              style: TextStyle(fontSize: 18),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(8.0),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: 2,
                      color: Colors.black,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.asset(
                  spellsImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}


// import 'package:flutter/material.dart';
// import 'package:warlocks_of_the_beach/screens/browse_content_screens/browse_items.dart';
// import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
// import 'package:warlocks_of_the_beach/widgets/navigation/main_appbar.dart';
// import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';

// class BrowseContent extends StatefulWidget {
//   const BrowseContent({Key? key}) : super(key: key);

//   @override
//   _BrowseContentState createState() => _BrowseContentState();
// }

// class _BrowseContentState extends State<BrowseContent> {
//   final itemsImage = 'assets/evocation-wizard-dnd-2024-2.webp';
//   final spellsImage = 'assets/evocation-wizard-dnd-2024-2.webp';
//   final characterSheetImage = 'assets/evocation-wizard-dnd-2024-2.webp';

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         child: Scaffold(
//       appBar: MainAppbar(),
//       drawer: MainDrawer(),
//       bottomNavigationBar: MainBottomNavBar(),
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 15),
//             const Text(
//               'Browse Items',
//               style: TextStyle(fontSize: 18),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => BrowseItems()));
//               },
//               child: Container(
//                 margin: const EdgeInsets.all(8.0),
//                 height: 200,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black, width: 1),
//                   boxShadow: const [
//                     BoxShadow(
//                       spreadRadius: 2,
//                       color: Colors.black,
//                       blurRadius: 5,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Image.asset(
//                   itemsImage,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),

//             SizedBox(height: 30),

//             const Text(
//               'Browse Premade Character Sheets',
//               style: TextStyle(fontSize: 18),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: Container(
//                 margin: const EdgeInsets.all(8.0),
//                 height: 200,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black, width: 1),
//                   boxShadow: const [
//                     BoxShadow(
//                       spreadRadius: 2,
//                       color: Colors.black,
//                       blurRadius: 5,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Image.asset(
//                   characterSheetImage,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             const Text(
//               'Browse Custom Spells',
//               style: TextStyle(fontSize: 18),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: Container(
//                 margin: const EdgeInsets.all(8.0),
//                 height: 200,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black, width: 1),
//                   boxShadow: const [
//                     BoxShadow(
//                       spreadRadius: 2,
//                       color: Colors.black,
//                       blurRadius: 5,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Image.asset(
//                   spellsImage,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }
