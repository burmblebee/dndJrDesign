import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/home_screen.dart';

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
            tileColor: Color(0xFF25291C),
            leading: const Icon(Icons.home),
            title: const Text('Home', style: TextStyle(color: Colors.white),),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          const Divider(),
          ListTile(
            tileColor: Color(0xFF25291C),
            leading: const Icon(Icons.group),
            title: const Text('Character Creator', style: TextStyle(color: Colors.white),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/character_creator');
            },
          ),
          const Divider(),
          const Spacer(),
          const Divider(),
          ListTile(
            tileColor: Color(0xFF25291C),
            leading: const Icon(Icons.person),
            title: const Text('Profile', style: TextStyle(color: Colors.white),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
         
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Divider(),
                ListTile(
                  tileColor: Color(0xFF25291C),
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