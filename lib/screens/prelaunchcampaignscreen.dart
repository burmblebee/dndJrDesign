import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/main_appbar.dart';
import '../widgets/main_drawer.dart';
import '../widgets/bottom_navbar.dart';
import 'campaign_screen.dart';

class PreLaunchCampaignScreen extends StatelessWidget {
  const PreLaunchCampaignScreen({super.key, required this.campaignID, required this.isDM});

  final isDM;
  final campaignID;

  Stream<List<players>> _getPlayers() async* {
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

            // Calendar Session information, should be pulled from the database
            const SizedBox(height: 20),
            const Text(
              'Next Scheduled Session: 2/13/2025 @ 6pm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            // Calendar Icon, should be a button that leads to calendar screen
            const SizedBox(height: 10),
            const Icon(Icons.calendar_today, size: 40),
            const SizedBox(height: 20),

            // Elevated Button to launch the campaign
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  // Should be a function that checks if the user is a DM or a player, and sorting them to the correctr screen depending on that.
                  MaterialPageRoute(builder: (context) => ((isDM) ? DMCombatScreen(campaignID: campaignID) : playerCombatScreen(campaignID: campaignID))),
                );
              },
              child: const Text('Launch Campaign'),
            ),
            
            // Should now be a for loop displaying all the players and characters in the campaign

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Your Notes'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Bag of Holding'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Players',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('TomatoSoupe'),
            ),
            const ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Sonrac'),
            ),
          ],
        ),
      ),
    );
  }
}
