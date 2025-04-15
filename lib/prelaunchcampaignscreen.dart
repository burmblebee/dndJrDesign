import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/main_appbar.dart';
import '../widgets/navigation/main_drawer.dart';
import '../widgets/navigation/bottom_navbar.dart';
import '../combat/dm_combat_screen.dart';
import '../combat/player_combat_screen.dart';
import '../combat/create_combat.dart';
import '../screens/notes.dart';
import '../screens/bag_of_holding.dart';
import '../screens/notes.dart';
import '../screens/schedule.dart';

class PreLaunchCampaignScreen extends StatelessWidget {
  const PreLaunchCampaignScreen({super.key, required this.campaignID, required this.isDM});

  final bool isDM;
  final String campaignID;

  Stream<List<String>> _getPlayers() async* {
    final user = FirebaseAuth.instance.currentUser;

    if(user == null) {
      yield[];
      return;
    }

    final snapshot = await FirebaseFirestore.instance.collection('user_campaigns').doc(campaignID).get();

    if(snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      final playersList = data['players'] as List<dynamic>;
      final players = playersList.map((player) => player.toString()).toList();
      yield players;
    } else {
      yield[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: const MainBottomNavBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image asset (should be replaced with a campaign image)
            Image.asset('assets/Wizard_Lady.jpg'),

            // Calendar Session information, should be pulled from the database (Currently Isn't)
            const SizedBox(height: 20),
            const Text(
              'Next Scheduled Session: 2/13/2025 @ 6pm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            // Calendar Icon that is a button that leads to the schedule screen 
            // (Might need to be changed depending on what Gabby says is the correct calendar screen)
            const SizedBox(height: 10),
            ElevatedButton.icon( // Changed to ElevatedButton.icon to see if it is more clear that it is a button
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Schedule()));
              },
              icon: const Icon(Icons.calendar_today, size: 40),
              label: const Text('Session Calendar'),
            ),
            //IconButton(
            //  onPressed: () {
            //    Navigator.push(context, MaterialPageRoute(builder: (context) => const Schedule()));
            //  },
            //   icon: const Icon(Icons.calendar_today, size: 40)),
            //const SizedBox(height: 10),
            //ElevatedButton(onPressed: () {
            //  Navigator.push(context, MaterialPageRoute(builder: (context) => const Schedule()));
            //}, child: const Text('Session Calendar')),
            const SizedBox(height: 20),

            // Elevated Button to launch the campaign, Want to make the button more impressive
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  // Should be a function that checks if the user is a DM or a player, and sorting them to the correctr screen depending on that.
                  MaterialPageRoute(builder: (context) => ((isDM) ? DMCombatScreen(campaignId: campaignID) : PlayerCombatScreen(campaignId: campaignID))),
                );
              },
              child: const Text('Launch Campaign'),
            ),

            // Note Screen Button, should be a button that leads to the note screen
            const SizedBox(height: 10),
            //const Icon(Icons.note, size: 40), // ITS JUST GONNA STAY SIDEWAYS
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  Notes(campaignId: campaignID, isDM: isDM)),
                );
              },
              icon: const Icon(Icons.note, size: 40),
              label: const Text('Notes'),
            ),
            const SizedBox(height: 10),

            // DM Combat Screen button, should only be visible to the DM
            // Check to see if works because I cannot check this (Michael 4/7/25 1:29pm){Works!}
            if (isDM) ... [
             ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCombat(campaignID: campaignID)),
                  );
                },
                child: const Text('DM Combat Screen'),
              ),
              const SizedBox(height: 10),
              Center( // Centered Text to hopefully make it look better
                child: Text(
                  'Campaign Invite Code: $campaignID',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],

            // Bag of Holding button (Consider switching icon to Icons.shopping_bag)
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BagOfHolding()));
              },
              icon: const Icon(Icons.backpack, size: 40),
              label: const Text('Bag of Holding'),
            ),

            // Title card for the player list
            const SizedBox(height: 20),
            const Text(
              'Your Players',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            // A list of players in the campaign, should be pulled from the database
            //const SizedBox(height: 20), {Commented out to see if it looks better}
            StreamBuilder<List<String>>(
              stream: _getPlayers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show a loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show an error message
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No players found'); // Handle empty data
                } else {
                  final players = snapshot.data!;
                  return Column(
                    children: players.map((player) {
                      return Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.account_circle),
                            title: Text(player),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}