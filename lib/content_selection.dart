// screen with 2 buttons, one leading to npc list and one leading to item list
 import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';

import 'item/item_list.dart';
import 'npc/npc_list.dart';

class ContentSelection extends StatelessWidget {

const ContentSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Selection')),
      bottomNavigationBar: MainBottomNavBar(initialIndex: 2,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const NPCListScreen(),
                ));
              },
              child: const Text('NPC List'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const itemListScreen(),
                ));
              },
              child: const Text('Item List'),
            ),
          ],
        ),
      ),
    );
  }

}