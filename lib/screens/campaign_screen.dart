import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/combat/dm_combat_screen.dart';
import 'package:warlocks_of_the_beach/combat/player_combat_screen.dart';
import '../combat/sync_test.dart';
import '../widgets/navigation/main_appbar.dart';
import '../widgets/navigation/main_drawer.dart';
import '../widgets/navigation/bottom_navbar.dart';
import '../models/campaign.dart';
import 'new_campaign_screen.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  _CampaignScreenState createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  // final List<Campaign> _campaigns = [
  //   Campaign(
  //       id: '1',
  //       imageUrl: 'assets/Wizard_Lady.jpg',
  //       title: 'Journey to Waterdeep',
  //       isDM: true),
  //   Campaign(
  //       id: '2',
  //       imageUrl: 'assets/evocation-wizard-dnd-2024-2.webp',
  //       title: 'The Lost Mines of Phandelver',
  //       isDM: false),
  //   Campaign(
  //       id: '3',
  //       imageUrl: 'assets/Wizard_Lady.jpg',
  //       title: 'The Curse of Strahd',
  //       isDM: false),
  //   Campaign(
  //       id: '4',
  //       imageUrl: 'assets/Wizard_Lady.jpg',
  //       title: 'The Rise of Tiamat',
  //       isDM: true),
  //   Campaign(
  //       id: '5',
  //       imageUrl: 'assets/Wizard_Lady.jpg',
  //       title: 'The Tomb of Annihilation',
  //       isDM: false),
  //   Campaign(
  //       id: '6',
  //       imageUrl: 'assets/Wizard_Lady.jpg',
  //       title: 'The Dragon Heist',
  //       isDM: true),
  // ];
  final List<Campaign> _campaigns = [];

  String _gameType(bool isDm) {
    return isDm ? 'Dungeon Master' : 'Player';
  }

  Stream<List<Campaign>> _getCampaigns() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield _campaigns;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: const MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: const MainBottomNavBar(),
      backgroundColor: theme,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Campaign>>(
              stream: _getCampaigns(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No campaigns found'));
                }

                final campaigns = snapshot.data!;

                return Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 50),
                      itemCount: campaigns.length,
                      itemBuilder: (context, index) {
                        final campaign = campaigns[index];
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Campaign: ${campaign.title}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SyncTest(campaignId: '',),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                      spreadRadius: 2,
                                      color: Colors.black,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: (campaign.imageUrl != null) ? Image.asset(
                                  campaign.imageUrl!,
                                  fit: BoxFit.cover,
                                ) : const Icon(Icons.image, size: 100, color: Colors.grey,  // Placeholder icon
                                 ),
                              ),
                            ),
                            Center(
                                child: Text(
                                    'Your Role: ${_gameType(campaign.isDM)}',
                                    style: const TextStyle(fontSize: 16))),
                          ],
                        );
                      },
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                theme.withAlpha(255), //fully opaque
                                theme.withAlpha(0), //fully transparent
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                shadowColor: Colors.black,
                elevation: 10,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NewCampaignScreen(),
                  ),
                );
              },
              child: Text(
                'Create or Join a New Campaign',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
