import '../../screens/auth/screen_auth.dart';
import '../../screens/dnd_forms/character_name.dart';
import '../../screens/dnd_forms/user_character_screen.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});
  final customColor = const Color.fromARGB(255, 138, 28, 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: customColor,
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/dragon.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 18,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Character',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    Text(
                      'Builder',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.group,
              size: 26,
              color: customColor,
            ),
            title: Text(
              'Your Characters',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: customColor,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserCharacterScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add,
              size: 26,
              color: customColor,
            ),
            title: Text(
              'New Character',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: customColor,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterName(),
                ),
              );
            },
          ),
          const Spacer(),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 26,
              color: customColor,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: customColor,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ScreenAuth(),
              //   ),
              // );
            },
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}





// import 'package:dnd_character_creator/screens/auth/screen_auth.dart';
// import 'package:dnd_character_creator/screens/dnd_forms/character_name.dart';
// import 'package:dnd_character_creator/screens/dnd_forms/user_character_screen.dart';
// import 'package:flutter/material.dart';

// class MainDrawer extends StatelessWidget {
//   const MainDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           DrawerHeader(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(colors: [
//                 Theme.of(context).colorScheme.primaryContainer,
//                 Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8)
//               ], begin: Alignment.topLeft, end: Alignment.bottomRight),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.construction,
//                   size: 48,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 const SizedBox(
//                   width: 18,
//                 ),
//                 Text(
//                   'Character Builder',
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: Icon(
//               Icons.group,
//               size: 26,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//             title: Text(
//               'Your Characters',
//               style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                     color: Theme.of(context).colorScheme.onSurface,
//                     fontSize: 24,
//                   ),
//             ),
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => UserCharacterScreen()
//                   ),
//                 );
//             },
//           ),
//           ListTile(
//             leading: Icon(
//               Icons.add,
//               size: 26,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//             title: Text(
//               'New Character',
//               style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                     color: Theme.of(context).colorScheme.onSurface,
//                     fontSize: 24,
//                   ),
//             ),
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CharacterName(
//                     ),
//                   ),
//                 );
//             },
//           ),
//           const Spacer(),
//           Column(
//             children: [
//               // ListTile(
//               //   leading: Icon(
//               //     Icons.person,
//               //     size: 26,
//               //     color: Theme.of(context).colorScheme.onSurface,
//               //   ),
//               //   title: Text(
//               //     'Profile',
//               //     style: Theme.of(context).textTheme.titleLarge!.copyWith(
//               //           color: Theme.of(context).colorScheme.onSurface,
//               //           fontSize: 24,
//               //         ),
//               //   ),
//               //   onTap: () {},
//               // ),
//               ListTile(
//                 leading: Icon(
//                   Icons.logout,
//                   size: 26,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//                 title: Text(
//                   'Logout',
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         color: Theme.of(context).colorScheme.onSurface,
//                         fontSize: 24,
//                       ),
//                 ),
//                 onTap: () {
//                   //push to the logout screen at Auth()
//                   Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ScreenAuth(),
//                   ),
//                 );
//                 },
//               ),
//               const SizedBox(height: 30)
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
