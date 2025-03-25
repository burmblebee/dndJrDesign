import 'package:flutter/material.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';

class BrowseItems extends StatefulWidget {
  const BrowseItems({Key? key}) : super(key: key);

  @override
  _BrowseItemsState createState() => _BrowseItemsState();
}

class _BrowseItemsState extends State<BrowseItems> {

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(),
      drawer: MainDrawer(),
      bottomNavigationBar: MainBottomNavBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5,),
            TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Items',
                  prefixIcon: Icon(Icons.search, size: 20, color: Theme.of(context).iconTheme.color,),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            const SizedBox(height: 15),
            const Text(
              'Popular Items',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160, // Set a fixed height for the horizontal list
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(width: 160, color: Colors.red),
                  Container(width: 160, color: Colors.blue),
                  Container(width: 160, color: Colors.green),
                  Container(width: 160, color: Colors.yellow),
                  Container(width: 160, color: Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'All Items',
              style: TextStyle(fontSize: 18),
            ),
            
          ],
        ),
      ),
    );
  }
}