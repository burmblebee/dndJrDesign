import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/schedule.dart';
import '../widgets/main_appbar_prelaunch.dart';
import '../widgets/navigation/main_drawer.dart';
import '../widgets/navigation/bottom_navbar.dart';
import '../combat/dm_combat_screen.dart';
import '../combat/player_combat_screen.dart';
import '../combat/create_combat.dart';
import '../screens/notes_prelaunch.dart';
import 'combat/combat_provider.dart';
import 'item/bag_of_holding_prelaunch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Funny logos ¯\_(ツ)_/¯

class PreLaunchCampaignScreen extends ConsumerWidget {
  const PreLaunchCampaignScreen({
    super.key,
    required this.campaignID,
    required this.isDM,
  });

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
  Widget build(BuildContext context, WidgetRef ref) {
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
              if (isDM) ...[
                Text(
                  'Campaign Invite Code: $campaignID',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Schedule(events: {}),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_today, size: 40),
                label: const Text('Session Calendar'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  final combatNotifier =
                  ref.read(combatProvider(campaignID).notifier);
                  await combatNotifier.startCombat(campaignID);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => isDM
                          ? DMCombatScreen(campaignId: campaignID)
                          : PlayerCombatScreen(campaignId: campaignID),
                    ),
                  );
                },
                icon: Icon(FontAwesomeIcons.handFist, size: 40,),
                label: const Text('Launch Campaign'),
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
                            AddCombat(campaignId: campaignID),
                      ),
                    );
                  },
                  child: const Text('Add Combat'),
                ),
                const SizedBox(height: 10),
              ],
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BagOfHolding(
                          campaignId: campaignID, isDM: isDM),
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
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return FutureBuilder<String>(
                          future: getPlayerInfo(players[index], index),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                                title:
                                Text(snapshot.data ?? 'Unknown player'),
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
    player = player.replaceAll('{', '').replaceAll('}', '');
    List<String> pairs = player.split(', ');
    Map<String, String> parsedMap = {
      for (var pair in pairs) pair.split(': ')[0]: pair.split(': ')[1],
    };

    String characterId = parsedMap['character']!;
    String playerId = parsedMap['player']!;

    DocumentSnapshot characterDoc = await FirebaseFirestore.instance
        .collection('app_user_profiles')
        .doc(playerId)
        .collection('characters')
        .doc(characterId)
        .get();
    String characterName = characterDoc['name'];
    return characterName;
  }
}