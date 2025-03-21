import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final List<Campaign> _campaigns = [];

  String _gameType(bool isDm) {
    return isDm ? 'Dungeon Master' : 'Player';
  }

  Future<List<Campaign>> _getCampaigns() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    // Fetch the list of campaign IDs from the user's profile
    final userCampaignsSnapshot = await FirebaseFirestore.instance
        .collection('app_user_profiles')
        .doc(user.uid)
        .collection('your_campaigns')
        .get();

    final campaignIds = userCampaignsSnapshot.docs.map((doc) => doc.id).toList();

    // Fetch the actual campaign data using the campaign IDs
    final campaigns = <Campaign>[];
    for (final campaignId in campaignIds) {
      final campaignSnapshot = await FirebaseFirestore.instance
          .collection('user_campaigns')
          .doc(campaignId)
          .get();

      if (campaignSnapshot.exists) {
        final campaignData = campaignSnapshot.data()!;
        campaigns.add(Campaign(
          id: campaignId,
          imageUrl: campaignData['imageUrl'],
          title: campaignData['title'],
          isDM: campaignData['DM'] == user.uid,
        ));
      }
    }

    return campaigns;
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
            child: FutureBuilder<List<Campaign>>(
              future: _getCampaigns(),
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
                                // Handles the tap - will link to another page later
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
                                child: campaign.imageUrl != null && campaign.imageUrl!.isNotEmpty
                                    ? Image.file(
                                        File(campaign.imageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/evocation-wizard-dnd-2024-2.webp',
                                        fit: BoxFit.cover,
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
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NewCampaignScreen(),
                  ),
                );
                setState(() {}); // Trigger a rebuild to refresh the campaigns
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