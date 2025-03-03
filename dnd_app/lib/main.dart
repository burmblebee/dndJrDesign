import 'package:flutter/material.dart';
import 'edit_profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<ProfilePage> {
  String username = "LuvleeGabs";
  String name = "Gabs";
  String email = "Gabriela.cisneros@calbaptist.edu";
  String phone = "951-735-3499";
  String gender = "Female";

  void _goToEditProfile() async{
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
      body: Center(
        child: Column(
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
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 6),
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

                  //Preferenes area
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
                          'language:',
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
                      ),),

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
              onPressed:  () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfile(
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
    );
  }
   Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
        Expanded(flex: 9, child: Text(value, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}