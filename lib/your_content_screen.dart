// screen with 2 buttons, one leading to npc list and one leading to item list
 import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:warlocks_of_the_beach/screens/campaign_screen.dart';
import 'package:warlocks_of_the_beach/screens/character_sheet/character_list.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';

import 'item/item_list.dart';
import 'npc/npc_list.dart';

class ContentSelection extends StatelessWidget {

const ContentSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Selection')),
      drawer: MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,

              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xFFD4C097).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NPCListScreen(),
                          ),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => itemListScreen(),
                          ),
                        );
                      } else if (index == 2) {
                        // Navigate to Characters
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CharacterList(),
                          ),
                        );
                      } else if (index == 3) {
                        // Navigate to Campaigns that user dms? For now just all campaigns
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CampaignScreen(),
                          ),
                        );
                      }
                    },
                    child:(index == 0) ? const Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.dragon, size: 50),
                          Text(
                            'NPCs',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ) : (index == 1) ?  const Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.sackXmark, size: 50),
                          Text(
                            'Items',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ) : (index == 2) ?
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(Icons.people, size: 50),
                          const Text(
                            'Characters',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ) : const Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.dungeon, size: 50),
                          Text(
                            'Campaigns',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(context, MaterialPageRoute(
            //       builder: (context) => const NPCListScreen(),
            //     ));
            //   },
            //   child: const Text('NPC List'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(context, MaterialPageRoute(
            //       builder: (context) => const itemListScreen(),
            //     ));
            //   },
            //   child: const Text('Item List'),
            // ),
//           ],
//         ),
//       ),
//     );
//   }
//
 }
}
