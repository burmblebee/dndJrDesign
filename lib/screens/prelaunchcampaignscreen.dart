import 'package:flutter/material.dart';
import '../widgets/main_appbar.dart';
import '../widgets/main_drawer.dart';
import '../widgets/bottom_navbar.dart';
import 'campaign_screen.dart';

class PreLaunchCampaignScreen extends StatelessWidget {
  const PreLaunchCampaignScreen({super.key});

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
            Image.asset('assets/Wizard_Lady.jpg'),
            const SizedBox(height: 20),
            const Text(
              'Next Scheduled Session: 2/13/2025 @ 6pm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Icon(Icons.calendar_today, size: 40),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CampaignScreen()),
                );
              },
              child: const Text('Launch Campaign'),
            ),
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
