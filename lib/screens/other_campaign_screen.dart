import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/screens/Compendium/monster_compendium.dart';
import 'package:warlocks_of_the_beach/screens/Compendium/spell_compendium.dart';
import 'package:warlocks_of_the_beach/screens/character_sheet/character_sheet.dart';
import 'package:warlocks_of_the_beach/screens/notes_stuff/notes.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/combat_nav_bar.dart';

class OtherCampaignScreen extends StatefulWidget {
  final bool isDM;
  final String campaignID;

  const OtherCampaignScreen({
    Key? key,
    required this.isDM,
    required this.campaignID,
  }) : super(key: key);

  @override
  State<OtherCampaignScreen> createState() => _OtherCampaignScreenState();
}

class _OtherCampaignScreenState extends State<OtherCampaignScreen> {
  String characterId = '';

  @override
  void initState() {
    super.initState();
    _fetchCharacterID();
  }

  Future<void> _fetchCharacterID() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final campaignDoc = await FirebaseFirestore.instance
          .collection('user_campaigns')
          .doc(widget.campaignID)
          .get();

      if (campaignDoc.exists) {
        final campaignData = campaignDoc.data();
        if (campaignData != null && campaignData['players'] is List) {
          final players = campaignData['players'] as List;

          // Find the player's entry where the playerID matches the current user's ID
          final playerEntry = players.firstWhere(
            (player) => player['player'] == user.uid,
            orElse: () => null,
          );

          if (playerEntry != null) {
            setState(() {
              characterId = playerEntry['character'] ?? '';
            });
            print('Character ID fetched: $characterId');
          } else {
            print('No matching player entry found for the current user.');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No character found for this campaign.'),
              ),
            );
          }
        } else {
          print('Players list is missing or invalid.');
        }
      } else {
        print('Campaign document does not exist.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Campaign does not exist.'),
          ),
        );
      }
    } catch (e) {
      print('Error fetching character ID: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch character ID: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<String> _fetchCharacterIDFuture() async {
    if (characterId.isNotEmpty) return characterId; // Return cached characterId if already fetched

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return '';

      final campaignDoc = await FirebaseFirestore.instance
          .collection('user_campaigns')
          .doc(widget.campaignID)
          .get();

      if (campaignDoc.exists) {
        final campaignData = campaignDoc.data();
        if (campaignData != null && campaignData['players'] is List) {
          final players = campaignData['players'] as List;

          // Find the player's entry where the playerID matches the current user's ID
          final playerEntry = players.firstWhere(
            (player) => player['player'] == user.uid,
            orElse: () => null,
          );

          if (playerEntry != null) {
            characterId = playerEntry['character'] ?? '';
            return characterId;
          }
        }
      }
    } catch (e) {
      print('Error fetching character ID: $e');
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    // Create your custom Tab widgets.
    final List<Tab> tabs = <Tab>[
      if (!widget.isDM)
        Tab(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person),
                SizedBox(height: 4),
                Text(
                  'Character\nSheet',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      Tab(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.book),
              SizedBox(height: 4),
              Text(
                'Monsters',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
      Tab(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.auto_stories),
              SizedBox(height: 4),
              Text(
                'Spells',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
      Tab(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.note),
              SizedBox(height: 4),
              Text(
                'Notes',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
      Tab(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.backpack),
              SizedBox(height: 4),
              Text(
                'Bag of\nHolding',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    ];

    // TabViews: Use your FutureBuilder for the CharacterSheet tab
    final List<Widget> tabViews = <Widget>[
      if (!widget.isDM)
        FutureBuilder<String>(
          future: _fetchCharacterIDFuture(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No character found for this campaign.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return CharacterSheet(
                characterID: snapshot.data!,
                inSession: true,
              );
            }
          },
        ),
      MonsterCompendium(),
      SpellCompendium(),
      Notes(campaignId: widget.campaignID),
      // Replace with your BagOfHolding widget or desired content.
      const Center(child: Text('Bag of Holding')),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        bottomNavigationBar: CombatBottomNavBar(),
        appBar: AppBar(
          title: const Text('Campaign Overview'),
          bottom: TabBar(
            isScrollable: false,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: tabViews,
        ),
      ),
    );
  }
}




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:warlocks_of_the_beach/screens/Compendium/monster_compendium.dart';
// import 'package:warlocks_of_the_beach/screens/Compendium/spell_compendium.dart';
// import 'package:warlocks_of_the_beach/screens/character_sheet/character_sheet.dart';
// import 'package:warlocks_of_the_beach/screens/notes_stuff/notes.dart';
// import 'package:warlocks_of_the_beach/widgets/navigation/combat_nav_bar.dart';

// class OtherCampaignScreen extends StatefulWidget {
//   final bool isDM;
//   final String campaignID;

//   const OtherCampaignScreen({
//     Key? key,
//     required this.isDM,
//     required this.campaignID,
//   }) : super(key: key);

//   @override
//   State<OtherCampaignScreen> createState() => _OtherCampaignScreenState();
// }

// class _OtherCampaignScreenState extends State<OtherCampaignScreen> {
//   String characterId = '';

//   @override
//   void initState() {
//     super.initState();
//     _fetchCharacterID();
//   }

//   Future<void> _fetchCharacterID() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;

//       final campaignDoc = await FirebaseFirestore.instance
//           .collection('user_campaigns')
//           .doc(widget.campaignID)
//           .get();

//       if (campaignDoc.exists) {
//         final campaignData = campaignDoc.data();
//         if (campaignData != null && campaignData['players'] is List) {
//           final players = campaignData['players'] as List;

//           // Find the player's entry where the playerID matches the current user's ID
//           final playerEntry = players.firstWhere(
//             (player) => player['player'] == user.uid,
//             orElse: () => null,
//           );

//           if (playerEntry != null) {
//             setState(() {
//               characterId = playerEntry['character'] ?? '';
//             });
//             print('Character ID fetched: $characterId');
//           } else {
//             print('No matching player entry found for the current user.');
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('No character found for this campaign.'),
//               ),
//             );
//           }
//         } else {
//           print('Players list is missing or invalid.');
//         }
//       } else {
//         print('Campaign document does not exist.');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Campaign does not exist.'),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error fetching character ID: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to fetch character ID: $e'),
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tabs = <Tab>[
//       if (!widget.isDM)
//         const Tab(
//           icon: Icon(Icons.person),
//           child: Center(
//             child: Text('Character\nSheet', style: TextStyle(fontSize: 10),),
//           ),
//         ),
//       const Tab(icon: Icon(Icons.book), child: Center(child: Text('Monsters', style: TextStyle(fontSize: 10),))),
//       const Tab(icon: Icon(Icons.auto_stories), child: Center(child: Text('Spells', style: TextStyle(fontSize: 10),))),
//       const Tab(icon: Icon(Icons.note), child: Center(child: Text('Notes', style: TextStyle(fontSize: 10),))),
//       const Tab(icon: Icon(Icons.backpack), child: Center(child: Text('Bag of\nHolding', style: TextStyle(fontSize: 10),))),
//     ];

//     final tabViews = <Widget>[
//       if (!widget.isDM)
//         FutureBuilder<String>(
//           future: _fetchCharacterIDFuture(), // Use a FutureBuilder for the CharacterSheet
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text(
//                   'Error: ${snapshot.error}',
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               );
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'No character found for this campaign.',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               );
//             } else {
//               return CharacterSheet(
//                 characterID: snapshot.data!,
//                 inSession: true,
//               );
//             }
//           },
//         ),
//       MonsterCompendium(),
//       SpellCompendium(),
//       Notes(campaignId: widget.campaignID),
//       // BagOfHolding(campaignId: widget.campaignID, characterId: snapshot.data!),
//       const Center(child: Text('Bag of Holding')), //bee comment this out and use the one above it
//     ];

//     return DefaultTabController(
//       length: tabs.length,
//       child: Scaffold(
//         bottomNavigationBar: CombatBottomNavBar(),
//         appBar: AppBar(
//           title: const Text('Campaign Overview'),
//           bottom: TabBar(
//             isScrollable: false,
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: Colors.white,
//             tabs: tabs,
//           ),
//         ),
//         body: TabBarView(
//           children: tabViews,
//         ),
//       ),
//     );
//   }

//   Future<String> _fetchCharacterIDFuture() async {
//     if (characterId.isNotEmpty) return characterId; // Return cached characterId if already fetched

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return '';

//       final campaignDoc = await FirebaseFirestore.instance
//           .collection('user_campaigns')
//           .doc(widget.campaignID)
//           .get();

//       if (campaignDoc.exists) {
//         final campaignData = campaignDoc.data();
//         if (campaignData != null && campaignData['players'] is List) {
//           final players = campaignData['players'] as List;

//           // Find the player's entry where the playerID matches the current user's ID
//           final playerEntry = players.firstWhere(
//             (player) => player['player'] == user.uid,
//             orElse: () => null,
//           );

//           if (playerEntry != null) {
//             characterId = playerEntry['character'] ?? '';
//             return characterId;
//           }
//         }
//       }
//     } catch (e) {
//       print('Error fetching character ID: $e');
//     }

//     return '';
//   }
// }
