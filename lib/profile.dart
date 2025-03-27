import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warlocks_of_the_beach/schedule.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/bottom_navbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_appbar.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/main_drawer.dart';
import 'edit_profile.dart';
import 'event.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}



class _ProfilePageState extends State<ProfilePage> {
  
  final Map<DateTime, List<Event>> testEvents = {
  DateTime(2025, 3, 26): [
    Event("Morning Meeting"),
    Event("Lunch with Team"),
  ],
  DateTime(2025, 3, 27): [
    Event("Code Review"),
  ],
};

  String username = "";
  String name = "";
  String email = "";
  String phone = "";
  String gender = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print("Fetching user profile for user ID: ${user.uid}");
        DocumentSnapshot userProfile = await FirebaseFirestore.instance
            .collection('app_user_profiles')
            .doc(user.uid)
            .get();

        if (userProfile.exists) {
          print("User profile found: ${userProfile.data()}");
          setState(() {
            username = userProfile['username'] ?? "";
            name = userProfile['name'] ?? "";
            email = user.email ?? "";
            phone = userProfile['phone'] ?? "";
            gender = userProfile['gender'] ?? "";
            isLoading = false;
          });
        } else {
          print("User profile does not exist");
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print("No user is currently signed in");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _goToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfile(
          username: username,
          name: name,
          phone: phone,
          gender: gender,
        ),
      ),
    );
    if (result != null && result is Map<String, String>) {
      setState(() {
        username = result['username'] ?? username;
        name = result['name'] ?? name;
        phone = result['phone'] ?? phone;
        gender = result['gender'] ?? gender;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(),
      bottomNavigationBar: MainBottomNavBar(),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //image + "edit profile" button
                    Image.asset(
                      'assets/profile.png',
                      width: 100,
                    ),
                    TextButton(
                      onPressed: _goToEditProfile,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF25291C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    TextButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Schedule(events: testEvents),
                        ),
                      ); // Navigate to RaceSelection
                    }, child: Text('Schedule Session')),
        
                    //info section
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
        
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        //makes it left aligned
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile Information',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 9, 0, 0),
                            ),
                          ),
        
                          //space between the title and row
                          SizedBox(height: 8),
                          _buildInfoRow("Username:", username),
                          _buildInfoRow("Name:", name),
        
                          //Personal Info area
                          SizedBox(height: 10),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                            endIndent: 20,
                          ),
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 9, 0, 0),
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow("Email:", email),
                          _buildInfoRow("Phone:", phone),
                          _buildInfoRow("Gender:", gender),
        
                          //Preferences area
                          SizedBox(height: 10),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                            endIndent: 20,
                          ),
                          Text(
                            'Preferences',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 9, 0, 0),
                            ),
                          ),
        
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Mode:',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: Text(
                                  'Dark',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Expanded(
                                  child: Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                              )),
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Language:',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: Text(
                                  'English',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Expanded(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                            endIndent: 20,
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile(
                                    username: username,
                                    name: name,
                                    phone: phone,
                                    gender: gender,
                                  )),
                        );
                      },
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
        Expanded(
            flex: 9,
            child: Text(value,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
