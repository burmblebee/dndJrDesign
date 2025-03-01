import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
              onPressed: () {
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
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Username:',
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Text(
                          'LuvleeGabs',
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Name:',
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Text(
                          'gabs',
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

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
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Email:',
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Text(
                          'gabriela.cisneros951@gmail.com',
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Phone:',
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Text(
                          '951-735-3499',
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Gender:',
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: Text(
                          'Female',
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

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
                      MaterialPageRoute(builder: (context) => EditProfile()),
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
}
