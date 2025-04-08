import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:warlocks_of_the_beach/prelaunch_campaign_screen.dart';
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
  final List<Campaign> _campaigns = [];
  final _createFormKey = GlobalKey<FormState>();
  final _joinFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _campaignCodeController = TextEditingController();
  File? _imageFile;
  bool _isDM = false;

  void rebuild() {
    setState(() {});
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage =
      await File(pickedFile.path).copy('${directory.path}/$fileName');
      setState(() {
        _imageFile = savedImage;
      });
    }
  }

  Future<void> _saveCampaignToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    if (_createFormKey.currentState!.validate()) {
      final campaign = Campaign(
        id: Uuid().v4(),
        imageUrl: _imageFile?.path,
        title: _titleController.text,
        isDM: _isDM,
      );

      await FirebaseFirestore.instance
          .collection('app_user_profiles')
          .doc(user.uid)
          .collection('your_campaigns')
          .doc(campaign.id)
          .set({
        'your role': _isDM ? 'DM' : 'Player',
        'campaign_code': campaign.id,
      });

      await FirebaseFirestore.instance
          .collection('user_campaigns')
          .doc(campaign.id)
          .set({
        'title': campaign.title,
        'imageUrl': campaign.imageUrl,
        'DM': user.uid,
        'players': [],
        'createdDate': DateTime.now(),
      });

      Navigator.of(context).pop();
    }
  }

  Future<void> _joinCampaign(String joinCodeCampaignId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    if (_joinFormKey.currentState!.validate()) {
      final campaignDoc = await FirebaseFirestore.instance
          .collection('user_campaigns')
          .doc(joinCodeCampaignId)
          .get();
      if (campaignDoc.exists) {
        // Add the user to the campaign
        await FirebaseFirestore.instance
            .collection('user_campaigns')
            .doc(joinCodeCampaignId)
            .update({
          'players': FieldValue.arrayUnion([user.uid]),
        });

        // Add the campaign to the user's profile
        await FirebaseFirestore.instance
            .collection('app_user_profiles')
            .doc(user.uid)
            .collection('your_campaigns')
            .doc(joinCodeCampaignId)
            .set({
          'your role': 'Player',
          'campaign_code': joinCodeCampaignId,
        });

        Navigator.of(context).pop();
      } else {
        // Show an error message if the campaign code does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campaign code does not exist')),
        );
      }
    }
  }

  String _gameType(bool isDm) {
    return isDm ? 'Dungeon Master' : 'Player';
  }

  Stream<List<Campaign>> _getCampaigns() async* {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      yield [];
      return;
    }

    // Fetch the list of campaign IDs from the user's profile
    final userCampaignsSnapshot = await FirebaseFirestore.instance
        .collection('app_user_profiles')
        .doc(user.uid)
        .collection('your_campaigns')
        .get();

    final campaignIds =
    userCampaignsSnapshot.docs.map((doc) => doc.id).toList();

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

    yield campaigns;
  }

  void _createNewCampaignSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Join a Campaign", style: TextStyle(fontSize: 24)),
                  const Divider(color: Colors.grey),
                  Form(
                    key: _joinFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _campaignCodeController,
                          decoration:
                          const InputDecoration(labelText: 'Campaign Code'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a campaign code';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () =>
                              _joinCampaign(_campaignCodeController.text),
                          child: Text('Join Campaign',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text("Create a New Campaign", style: TextStyle(fontSize: 24)),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Form(
                    key: _createFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                              labelText: 'Campaign Title'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a campaign title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Pick Image',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              )),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _saveCampaignToFirestore,
                          child: Text('Save Campaign',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              )),
                        ),
                        // _imageFile != null
                        //     ? Image.file(_imageFile!)
                        //     : const Text('No image selected'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }).then((value) => rebuild());
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
                                    builder: (context) => PreLaunchCampaignScreen(campaignID: campaign.id, isDM: campaign.isDM),
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
                                child: campaign.imageUrl != null &&
                                    campaign.imageUrl!.isNotEmpty
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
              onPressed: () {
                _createNewCampaignSheet(context);
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
