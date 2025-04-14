import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../prelaunch_campaign_screen.dart';
import '../widgets/navigation/main_appbar.dart';
import '../widgets/navigation/main_drawer.dart';
import '../widgets/navigation/bottom_navbar.dart';
import '../models/campaign.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  _CampaignScreenState createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  final _createFormKey = GlobalKey<FormState>();
  final _joinFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _campaignCodeController = TextEditingController();
  String? _selectedCharacterId;
  Color _selectedColor = Colors.blue; // Default color

  void rebuild() => setState(() {});

  Future<void> _saveCampaignToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_createFormKey.currentState!.validate()) {
      final campaignId = Uuid().v4();

      final campaign = Campaign(
        id: campaignId,
        imageUrl: null, // No image URL
        title: _titleController.text,
        isDM: true,
      );

      // Save campaign reference in the user's profile
      await FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(user.uid)
          .collection('your_campaigns')
          .doc(campaignId)
          .set({
        'your role': 'DM',
        'campaign_code': campaignId,
      });

      // Save campaign details in the global campaigns collection
      await FirebaseFirestore.instance
          .collection('user_campaigns')
          .doc(campaignId)
          .set({
        'title': campaign.title,
        'color':
        '#${_selectedColor.value.toRadixString(16).substring(2)}', // Save color as hex
        'DM': user.uid,
        'players': [],
        'createdDate': DateTime.now(),
      });

      Navigator.of(context).pop();
    }
  }

  Future<void> _joinCampaign(String joinCodeCampaignId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_selectedCharacterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a character before joining!')),
      );
      return;
    }

    if (_joinFormKey.currentState!.validate()) {
      // Remove spaces from the join code
      final sanitizedJoinCode = joinCodeCampaignId.replaceAll(' ', '');

      final campaignDoc = await FirebaseFirestore.instance
          .collection('user_campaigns')
          .doc(sanitizedJoinCode)
          .get();

      if (campaignDoc.exists) {
        // Add player with character to the campaign
        await FirebaseFirestore.instance
            .collection('user_campaigns')
            .doc(sanitizedJoinCode)
            .update({
          'players': FieldValue.arrayUnion([
            {
              'player': user.uid,
              'character': _selectedCharacterId,
            }
          ])
        });

        // Save campaign reference in the user's profile
        await FirebaseFirestore.instance
            .collection('app_user_profiles')
            .doc(user.uid)
            .collection('your_campaigns')
            .doc(sanitizedJoinCode)
            .set({
          'your role': 'Player',
          'campaign_code': sanitizedJoinCode,
        });

        // Close the modal
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully joined the campaign!')),
        );
      } else {
        // Show error message for invalid join code
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid campaign code. Please try again.')),
        );
      }
    }
  }

  Future<List<Map<String, dynamic>>> _fetchUserCharacters(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('app_user_profiles')
        .doc(userId)
        .collection('characters')
        .get();

    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  void _createNewCampaignSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Create a New Campaign",
                style: const TextStyle(fontSize: 24),
              ),
              const Divider(color: Colors.grey),
              Form(
                key: _createFormKey,
                child: Column(
                  children: [
                    // Campaign Title Field
                    TextFormField(
                      controller: _titleController,
                      decoration:
                      const InputDecoration(labelText: 'Campaign Title'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a campaign title'
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Color Picker
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Pick a Color'),
                              content: SingleChildScrollView(
                                child: BlockPicker(
                                  pickerColor: _selectedColor,
                                  onColorChanged: (color) {
                                    setState(() {
                                      _selectedColor = color;
                                    });
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Done'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Pick Campaign Color'),
                    ),
                    const SizedBox(height: 20),

                    // Save Campaign Button
                    ElevatedButton(
                      onPressed: _saveCampaignToFirestore,
                      child: const Text('Save Campaign'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) => rebuild());
  }

  void _joinCampaignSheet(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final characters = await _fetchUserCharacters(user.uid);
    if (characters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Create a character first!')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Text("Join a Campaign", style: TextStyle(fontSize: 24)),
            const Divider(color: Colors.grey),
            Form(
              key: _joinFormKey,
              child: Column(children: [
                TextFormField(
                  controller: _campaignCodeController,
                  decoration: const InputDecoration(labelText: 'Campaign Code'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a campaign code'
                      : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration:
                  const InputDecoration(labelText: 'Select Character'),
                  items: characters.map((char) {
                    return DropdownMenuItem<String>(
                      value: char['id'],
                      child: Text(char['name'] ?? 'Unnamed'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCharacterId = val;
                    });
                  },
                  validator: (val) =>
                  val == null ? 'Please select a character' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _joinCampaign(_campaignCodeController.text),
                  child: const Text('Join Campaign'),
                ),
              ]),
            ),
          ]),
        ),
      ),
    ).then((_) => rebuild());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: const MainBottomNavBar(initialIndex: 3),
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
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 50),
                  itemCount: campaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = campaigns[index];
                    final colorHex =
                        campaign.imageUrl ?? '#6A11CB'; // Default color if none
                    final color =
                    Color(int.parse('0xFF${colorHex.substring(1)}'));

                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Campaign: ${campaign.title}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                 PreLaunchCampaignScreen(campaignID: campaign.id, isDM: campaign.isDM)
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  color.withOpacity(0.7),
                                  color.withOpacity(0.3),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(color: Colors.black),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 2,
                                  color: Colors.black,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                              'Your Role: ${campaign.isDM ? 'Dungeon Master' : 'Player'}'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _createNewCampaignSheet(context),
            child: const Text('Create a Campaign'),
          ),
          ElevatedButton(
            onPressed: () => _joinCampaignSheet(context),
            child: const Text('Join a Campaign'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Stream<List<Campaign>> _getCampaigns() async* {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      yield [];
      return;
    }

    final userCampaignsSnapshot = await FirebaseFirestore.instance
        .collection('app_user_profiles')
        .doc(user.uid)
        .collection('your_campaigns')
        .get();

    final campaignIds =
    userCampaignsSnapshot.docs.map((doc) => doc.id).toList();

    final campaigns = <Campaign>[];
    for (final campaignId in campaignIds) {
      final campaignSnapshot = await FirebaseFirestore.instance
          .collection('user_campaigns')
          .doc(campaignId)
          .get();

      if (campaignSnapshot.exists) {
        final data = campaignSnapshot.data()!;
        campaigns.add(Campaign(
          id: campaignId,
          imageUrl: data['color'], // Use color instead of imageUrl
          title: data['title'],
          isDM: data['DM'] == user.uid,
        ));
      }
    }

    yield campaigns;
  }
}
