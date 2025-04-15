import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:warlocks_of_the_beach/prelaunch_campaign_screen.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map<String, dynamic>?> _fetchCampaignDetails(String campaignId) async {
    try {
      final campaignDoc = await FirebaseFirestore.instance
          .collection('user_campaigns')
          .doc(campaignId)
          .get();

      if (campaignDoc.exists) {
        return campaignDoc.data();
      }
    } catch (e) {
      print('Error fetching campaign details: $e');
    }

    return null;
  }

  Future<Map<String, dynamic>?> _fetchLastPlayedData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final userId = user.uid;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return snapshot.data();
      }
    } catch (e) {
      print('Error fetching last played data: $e');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(),
      bottomNavigationBar: MainBottomNavBar(),
      drawer: MainDrawer(),
      backgroundColor: Color(0xFF464538),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Text(
                "Last Played",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () async {
                  final data = await _fetchLastPlayedData();
                  if (data != null &&
                      data.containsKey('last_campaign_player')) {
                    final lastCampaignId = data['last_campaign_player'];

                    // Fetch campaign details
                    final campaignDetails =
                    await _fetchCampaignDetails(lastCampaignId);
                    if (campaignDetails != null) {
                      final isDM = campaignDetails['DM'] ==
                          FirebaseAuth.instance.currentUser?.uid;
                      final colorHex = campaignDetails['color'] ??
                          '#6A11CB'; // Default color
                      final color =
                      Color(int.parse('0xFF${colorHex.substring(1)}'));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreLaunchCampaignScreen(
                            isDM: isDM,
                            campaignID: lastCampaignId,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to fetch campaign details.'),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No last played campaign found.'),
                      ),
                    );
                  }
                },
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: _fetchLastPlayedData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError || snapshot.data == null) {
                      return const Text(
                        "Error loading campaign details",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      );
                    }

                    final data = snapshot.data!;
                    final lastCampaignId = data['last_campaign_player'];

                    return FutureBuilder<Map<String, dynamic>?>(
                      future: _fetchCampaignDetails(lastCampaignId),
                      builder: (context, campaignSnapshot) {
                        if (campaignSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (campaignSnapshot.hasError ||
                            campaignSnapshot.data == null) {
                          return const Text(
                            "Error loading campaign details",
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          );
                        }

                        final campaignDetails = campaignSnapshot.data!;
                        final colorHex = campaignDetails['color'] ??
                            '#6A11CB'; // Default color
                        final color =
                        Color(int.parse('0xFF${colorHex.substring(1)}'));

                        return Container(
                          height: 170,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                color.withOpacity(0.7),
                                color.withOpacity(0.3),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                spreadRadius: 2,
                                color: Colors.black,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder<Map<String, dynamic>?>(
                future: _fetchLastPlayedData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      "Error loading last played data",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    );
                  }

                  final data = snapshot.data;
                  if (data == null ||
                      !data.containsKey('last_played') ||
                      !data.containsKey('last_campaign_player')) {
                    return const Text(
                      "No last played session found",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    );
                  }

                  final lastPlayed =
                  (data['last_played'] as Timestamp).toDate();
                  final lastCampaignId = data['last_campaign_player'];

                  return FutureBuilder<Map<String, dynamic>?>(
                    future: _fetchCampaignDetails(lastCampaignId),
                    builder: (context, campaignSnapshot) {
                      if (campaignSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (campaignSnapshot.hasError ||
                          campaignSnapshot.data == null) {
                        return const Text(
                          "Error loading campaign details",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        );
                      }

                      final campaignDetails = campaignSnapshot.data!;
                      final isDM = campaignDetails['DM'] ==
                          FirebaseAuth.instance.currentUser?.uid;
                      final colorHex = campaignDetails['color'] ??
                          '#6A11CB'; // Default color
                      final color =
                      Color(int.parse('0xFF${colorHex.substring(1)}'));

                      return Column(
                        children: [
                          Text(
                            "Last Played: ${lastPlayed.month}/${lastPlayed.day}/${lastPlayed.year} at ${lastPlayed.hour}:${lastPlayed.minute.toString().padLeft(2, '0')} ${lastPlayed.hour >= 12 ? 'PM' : 'AM'}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Role: ${isDM ? 'Dungeon Master' : 'Player'}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 40),
              Text(
                "Upcoming Session",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Navigate to another screen
                },
                child: Container(
                  height: 170,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/dog.webp'),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Scheduled for: 4/15/2025 at 6:30 PM ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}