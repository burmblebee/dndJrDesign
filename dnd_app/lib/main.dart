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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              //image + "edit profile" button
              Image.asset(
            'assets/profile.png',
              width:100,
                ),
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfile()),
                  );
                },
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
                ) ,
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
                padding: EdgeInsets.only(left:20),
                child: Align(
                alignment: Alignment.centerLeft,
                child:Text(
                    'Profile Information',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 9, 0, 0)
                       ),
                  ),
              ),
                  ),
            ],
          ),
        ),
    );
  }
}