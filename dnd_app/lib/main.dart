import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF464538), // Background color
      body: Column(
        children: [
          Container(
            height: 60,
            color: Color(0xFF25291C), // Top bar color
            //profile icon + adjustments
             child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.person, color: Colors.white),
                  onPressed: () {},
                ),
              ],
             ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15),
                  Text(
                    "Your Games",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      // Navigate to another screen
                    },
                    child: Container(
                      height: 190,
                      decoration: BoxDecoration(
                        image:DecorationImage(
                          image: AssetImage('assets/witch.jpg'),
                          fit:BoxFit.cover,
                          ),
                          border:Border.all(
                            color: Colors.black,
                            width:2,
                          ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Last Played: 2/3/2025 at 5:48 PM",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  SizedBox(height: 50), // Increased space
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
                      height: 190,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/dog.webp'),
                          fit:BoxFit.cover,
                          ),
                          border:Border.all(
                            color: Colors.black,
                            width:2,
                          ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Scheduled for: 2/12/2025 at 6:30 PM",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            color: Color(0xFF25291C), // Bottom section color
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.casino, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.folder, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.chair, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}