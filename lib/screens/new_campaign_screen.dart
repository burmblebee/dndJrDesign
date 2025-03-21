import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../models/campaign.dart';

class NewCampaignScreen extends StatefulWidget {
  const NewCampaignScreen({super.key});

  @override
  _NewCampaignScreenState createState() => _NewCampaignScreenState();
}

class _NewCampaignScreenState extends State<NewCampaignScreen> {
  final _createFormKey = GlobalKey<FormState>();
  final _joinFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _campaignCodeController = TextEditingController();
  File? _imageFile;
  bool _isDM = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create or Join Campaign'),
      ),
      body: SingleChildScrollView(
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
                          color: Theme.of(context).textTheme.bodyMedium?.color,
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
                    decoration:
                        const InputDecoration(labelText: 'Campaign Title'),
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
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        )),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveCampaignToFirestore,
                    child: Text('Save Campaign',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        )),
                  ),
                  // _imageFile != null
                  //     ? Image.file(_imageFile!)
                  //     : const Text('No image selected'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
