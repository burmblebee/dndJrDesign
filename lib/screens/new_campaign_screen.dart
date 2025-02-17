import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/screens/campaign_screen.dart';
import 'package:warlocks_of_the_beach/widgets/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/main_drawer.dart';

class NewCampaignScreen extends StatefulWidget {
  const NewCampaignScreen({super.key});

  @override
  State<NewCampaignScreen> createState() => _NewCampaignScreenState();
}

class _NewCampaignScreenState extends State<NewCampaignScreen> {
  String? selectedCharacter;
  final List<String> characters = ['Character 1', 'Character 2', 'Character 3'];

  TextEditingController joinCodeController = TextEditingController();
  TextEditingController campaignNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(),
      drawer: MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Text(
              'Want to join a campaign?\n Enter the join code here:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 350,
            child: TextField(
              controller: joinCodeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter join code',
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
              shadowColor: Colors.black,
              elevation: 10,
            ),
            onPressed: () {
              // Process the join code
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CampaignScreen()));
            },
            child: Text(
              'Submit Join Code',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Optionally: Select a character to join with:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 350,
            child: DropdownButton<String>(
              value: selectedCharacter,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCharacter = newValue!;
                });
              },
              items: characters.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Select a character'),
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          SizedBox(height: 30),
          Center(
            child: Text(
              'Create a new campaign:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 350,
            child: TextFormField(
              controller: campaignNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Campaign Name',
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
              shadowColor: Colors.black,
              elevation: 10,
            ),
            onPressed: () {
              // Process the new campaign
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CampaignScreen()));
            },
            child: Text(
              'Create New Campaign',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
