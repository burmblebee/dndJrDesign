import '../widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import '../widgets/main_appbar.dart';
import '../widgets/main_drawer.dart';
import '../models/campaign.dart';
// import '../screens/new_campaign_screen.dart';


class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  _CampaignScreenState createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  //This is a hardcoded list of campaigns, but I will get somehting similar from fierbase later
  final List<Campaign> _campaigns = [
    Campaign(
        id: '1',
        imageUrl: 'assets/Wizard_Lady.jpg',
        title: 'Journey to Waterdeep',
        isDM: true),
    Campaign(
        id: '2',
        imageUrl: 'assets/evocation-wizard-dnd-2024-2.webp',
        title: 'The Lost Mines of Phandelver',
        isDM: false),
    Campaign(
        id: '3',
        imageUrl: 'assets/Wizard_Lady.jpg',
        title: 'The Curse of Strahd',
        isDM: false),
    Campaign(
        id: '4',
        imageUrl: 'assets/Wizard_Lady.jpg',
        title: 'The Rise of Tiamat',
        isDM: true),
    Campaign(
        id: '5',
        imageUrl: 'assets/Wizard_Lady.jpg',
        title: 'The Tomb of Annihilation',
        isDM: false),
    Campaign(
        id: '6',
        imageUrl: 'assets/Wizard_Lady.jpg',
        title: 'The Dragon Heist',
        isDM: true),
  ];

  String _gameType(bool isDm) {
    return isDm ? 'Dungeon Master' : 'Player';
  } //bascially a function to return the game type

  //for testing purposes, simulating a delay to get the campaigns from "firestore"
  Stream<List<Campaign>> _getCampaigns() async* {
    // Simulate a delay
    await Future.delayed(const Duration(seconds: 1));
    yield _campaigns;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: const MainAppbar(),
      drawer: const MainDrawer(),
      // bottomNavigationBar: const BottomNavBar(),
      bottomNavigationBar: const MainBottomNavBar(),
      backgroundColor: theme,
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 550,
            child: StreamBuilder<List<Campaign>>(
              stream: _getCampaigns(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); //funny circle loading icon
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text(
                          'No campaigns found')); //if no campaigns are found notifies the user
                }

                final campaigns = snapshot.data!;

                return ListView.builder(
                  //using a list view becuase I dont know how many campaigns there will be
                  itemCount: campaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = campaigns[index];
                    return Column(
                      children: [
                        SizedBox(height: 20),
                        Center(
                            child: Text(
                                'Campaign: ${campaign.title}')), //puts the name of the campaign over the image
                        GestureDetector(
                          onTap: () {
                            // Handles the tap - will link to another page later
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 2,
                                  color: Colors.black,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              campaign.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Center(
                            child: Text(
                                'Your Role: ${_gameType(campaign.isDM)}')), //puts the game type under the image
                      ],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 30), //end of the list view
          // Center(
          //   child: ElevatedButton(
          //     //set the button width
          //     style: ElevatedButton.styleFrom(
          //       minimumSize: const Size(200, 50),
          //       //add a shodow t the button 
          //       shadowColor: Colors.black,
          //       elevation: 10,
          //     ),
          //     onPressed: () {
          //       // Handles the tap - will link to another page later
          //     },
          //     child: Text(
          //       'Create a new campaign',
          //       style: TextStyle(
          //         color: Theme.of(context).textTheme.bodyMedium?.color,
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                shadowColor: Colors.black,
                elevation: 10,
              ),
              onPressed: () {
                // Routes to the NewCampaignScreen
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const NewCampaignScreen(),
                //   ),
                // );
              },
              child: Text(
                'New Campaign',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
