import 'package:flutter/material.dart';

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
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Browse Content', style: TextStyle(color: Colors.white),),
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
                  leading: const Icon(Icons.book),
                  title: const Text('Your Content', style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.campaign),
                  title: const Text('Campaigns', style: TextStyle(color: Colors.white),),
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}