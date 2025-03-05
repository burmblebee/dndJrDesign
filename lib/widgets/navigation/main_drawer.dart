import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/screens/profile.dart';
import '../../home_screen.dart';
import '../../screens/dnd_forms/character_name.dart';

class MainDrawer extends StatelessWidget{
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context).drawerTheme;

    return Drawer(
      
      backgroundColor: Color(0xFF25291C),
      child: Column(
        children: [
          AppBar(
            // backgroundColor: Color(0xFF25291C),
            backgroundColor: theme.backgroundColor,
            title: const Text('Warlocks of the Beach', style: TextStyle(color: Colors.white),),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home', style: TextStyle(color: Colors.white),),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('Character Creator', style: TextStyle(color: Colors.white),),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CharacterName(),
                ),
              );
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile', style: TextStyle(color: Colors.white),),
            onTap: () {
             Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout', style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
                const Divider(),
                Container(
                  height: 60,
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}