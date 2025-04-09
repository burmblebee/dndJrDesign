import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../widgets/navigation/main_appbar.dart';
import '../widgets/navigation/main_drawer.dart';
import '../widgets/navigation/bottom_navbar.dart';
import '../models/campaign.dart';
import '../combat/DMcombatScreen.dart';

enum ImageSourceOption { upload, link }

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
  final _imageLinkController = TextEditingController();
  File? _imageFile;
  String? _selectedCharacterId;
  ImageSourceOption _imageSourceOption = ImageSourceOption.upload;

  void rebuild() => setState(() {});

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

  Future<List<Map<String, dynamic>>> _fetchUserCharacters(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('app_user_profiles')
        .doc(userId)
        .collection('characters')
        .get();

    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Future<void> _saveCampaignToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_createFormKey.currentState!.validate()) {
      final campaignId = Uuid().v4();
      String? imageUrl;

      // Use the uploaded image if available
      if (_imageFile != null) {
        try {
          final storageRef = FirebaseStorage.instance.ref().child(
              'campaign_images/${user.uid}/$campaignId/${path.basename(_imageFile!.path)}');
          final uploadTask = await storageRef.putFile(_imageFile!);
          imageUrl = await uploadTask.ref.getDownloadURL();
        } catch (e) {
          print('Error uploading image: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
          return;
        }
      } else if (_imageLinkController.text.trim().isNotEmpty) {
        // Use the provided image link if no image is uploaded
        imageUrl = _imageLinkController.text.trim();
      }

      final campaign = Campaign(
        id: campaignId,
        imageUrl: imageUrl,
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
    if (user == null || _selectedCharacterId == null) return;

    if (_joinFormKey.currentState!.validate()) {
      final campaignDoc = await FirebaseFirestore.instance
          .collection('user_campaigns')
          .doc(joinCodeCampaignId)
          .get();

      if (campaignDoc.exists) {
        // Add player with character
        await FirebaseFirestore.instance
            .collection('user_campaigns')
            .doc(joinCodeCampaignId)
            .update({
          'players': FieldValue.arrayUnion([
            {
              'player': user.uid,
              'character': _selectedCharacterId,
            }
          ])
        });

        // Update user profile
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campaign code does not exist')),
        );
      }
    }
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
          imageUrl: data['imageUrl'],
          title: data['title'],
          isDM: data['DM'] == user.uid,
        ));
      }
    }

    yield campaigns;
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

                    // Optional Image URL Field
                    TextFormField(
                      controller: _imageLinkController,
                      decoration: const InputDecoration(
                        labelText: 'Optional: Image URL',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Optional Pick Image Button
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Optional: Pick Image'),
                    ),
                    if (_imageFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Selected Image: ${path.basename(_imageFile!.path)}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
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
                  child: Text('Join Campaign'),
                ),
              ]),
            ),
          ]),
        ),
      ),
    ).then((_) => rebuild());
  }

  String _gameType(bool isDm) => isDm ? 'Dungeon Master' : 'Player';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: const MainAppbar(),
      drawer: const MainDrawer(),
      bottomNavigationBar: const MainBottomNavBar(initialIndex: 3,),
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
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 50),
                  itemCount: campaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = campaigns[index];
                    return Column(children: [
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
                              builder: (_) =>
                                  DMCombatScreen(campaignId: campaign.id),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
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
                          child: campaign.imageUrl != null &&
                                  campaign.imageUrl!.isNotEmpty
                              ? Image.network(
                                  campaign.imageUrl!,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Text(
                                        'Failed to load image',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF6A11CB),
                                        Color(0xFF2575FC)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'No Image Available',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Center(
                          child:
                              Text('Your Role: ${_gameType(campaign.isDM)}')),
                    ]);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _createNewCampaignSheet(context),
            child: Text('Create a Campaign'),
          ),
          ElevatedButton(
            onPressed: () => _joinCampaignSheet(context),
            child: Text('Join a Campaign'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
