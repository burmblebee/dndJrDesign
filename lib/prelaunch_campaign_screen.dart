import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/schedule.dart';
import '../widgets/main_appbar.dart';
import '../widgets/navigation/main_drawer.dart';
import '../widgets/navigation/bottom_navbar.dart';
import '../combat/dm_combat_screen.dart';
import '../combat/player_combat_screen.dart';
import '../combat/create_combat.dart';
import '../screens/notes.dart';
import 'item/bag_of_holding.dart';

class PreLaunchCampaignScreen extends StatelessWidget {
  const PreLaunchCampaignScreen(
      {super.key, required this.campaignID, required this.isDM});

  final bool isDM;
  final String campaignID;

  Stream<List<String>> _getPlayers() async* {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      yield [];
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('user_campaigns')
        .doc(campaignID)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      final playersList = data['players'] as List<dynamic>;
      final players = playersList.map((player) => player.toString()).toList();
      yield players;
    } else {
      yield [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: const MainBottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Next Scheduled Session: 2/13/2025 @ 6pm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Schedule(events: {})),
                  );
                },
                icon: const Icon(Icons.calendar_today, size: 40),
                label: const Text('Session Calendar'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => isDM
                          ? DMCombatScreen(campaignId: campaignID)
                          : PlayerCombatScreen(campaignId: campaignID),
                    ),
                  );
                },
                child: const Text('Launch Campaign'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Notes(campaignId: campaignID, isDm: isDM),
                    ),
                  );
                },
                icon: const Icon(Icons.note, size: 40),
                label: const Text('Notes'),
              ),
              const SizedBox(height: 10),
              if (isDM) ...[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddCombat(campaignId: campaignID)),
                    );
                  },
                  child: const Text('Add Combat'),
                ),
                const SizedBox(height: 10),
                Text(
                  'Campaign Invite Code: $campaignID',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BagOfHolding(campaignId: campaignID, isDM: isDM),
                    ),
                  );
                },
                icon: const Icon(Icons.backpack, size: 40),
                label: const Text('Bag of Holding'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Players',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<List<String>>(
                stream: _getPlayers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No players found');
                  } else {
                    final players = snapshot.data!;
                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: players.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return FutureBuilder<String>(
                          future: getPlayerInfo(players[index], index),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const ListTile(
                                leading: Icon(Icons.account_circle),
                                title: Text('Loading...'),
                              );
                            } else if (snapshot.hasError) {
                              return ListTile(
                                leading: const Icon(Icons.error),
                                title: Text('Error: ${snapshot.error}'),
                              );
                            } else {
                              return ListTile(
                                leading: const Icon(Icons.account_circle),
                                title: Text(snapshot.data ?? 'Unknown player'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getPlayerInfo(String player, int index) async {
    //pull player and character ids from firestore
    // Remove the curly braces
    player = player.replaceAll('{', '').replaceAll('}', '');

    // Split the string into key-value pairs
    List<String> pairs = player.split(', ');

    // Create a map from the key-value pairs
    Map<String, String> parsedMap = {
      for (var pair in pairs) pair.split(': ')[0]: pair.split(': ')[1],
    };

    // Access the values
    String characterId = parsedMap['character']!;
    String playerId = parsedMap['player']!;
    //pull player username using id
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('app_user_profiles')
        .doc(playerId).get();
    String playerName = "Player $index"; // Default value

// Check if the document exists and contains the 'username' field
    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      playerName = data.containsKey('username') ? data['username'] : playerName;
    }


    //pull character name using ids
    DocumentSnapshot characterDoc = await FirebaseFirestore.instance
        .collection('app_user_profiles')
        .doc(playerId)
        .collection('characters')
        .doc(characterId)
        .get();
    String characterName = characterDoc['name'];

    return "Character: $characterName\nPlayer: $playerName";
  }

}
