
import 'dart:typed_data';

import 'package:dnd_app/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

//female will temporarily be the default
  bool _isGenderExpanded = false;
  String _selectedGender = "Female";
  String _savedGender = "Female";


  void _updateProfile() {
    setState(() {
      _savedGender = _selectedGender; // Save the gender
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Profile updated successfully!"),
        duration: Duration(seconds: 2),
      ),
    );

    // Wait for the SnackBar to show, then navigate back
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // This will navigate back to the previous screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                _image != null 
                    ? CircleAvatar(
                        radius: 65,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : // If no image is selected, show a default image
                const CircleAvatar(
                  radius: 65,
                  backgroundImage:
                      AssetImage('assets/profile.png'), // Default image
                ),
                Positioned(
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                  bottom: -10,
                  left: 80,
                ),
              ],
            ),
            //divider + spacing
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
                  Row(
                    children: [
                      Text(
                        'Profile Information',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 9, 0, 0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
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
                      Flexible(
                        flex: 9,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 200), // Set max width
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter Username',
                              contentPadding: EdgeInsets.all(10),
                            ),
                            
                          ),
                        ),),
                    ],
                  ),
                  SizedBox(height: 10),
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
                      Flexible(
                        flex: 9,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 200), // Set max width
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter Name',
                              contentPadding: EdgeInsets.all(10),
                            ),
                            
                          ),
                        ),),
                    ],
                  ),
                  SizedBox(height: 10),
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
                      Flexible(
                        flex: 9,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 200), // Set max width
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter Number',
                              contentPadding: EdgeInsets.all(10),
                            ),
                            
                          ),
                        ),),
                    ],
                  ),
                 
                  SizedBox(height: 10),
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
                      Flexible(
                        flex: 9,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 200), // Set max width
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter Email',
                              contentPadding: EdgeInsets.all(10),
                            ),
                            
                          ),
                        ),),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    endIndent: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          'password:',
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Text(
                          '*******',
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
                        flex: 8,
                        child: Text(
                          _savedGender, // Show saved gender
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isGenderExpanded = !_isGenderExpanded;
                          });
                        },
                        child: Icon(
                          _isGenderExpanded
                              ? Icons.arrow_downward
                              : Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  if (_isGenderExpanded)
                    Padding(
                      padding: EdgeInsets.only(left: 40, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = "Female";
                                _savedGender = "Female"; // Update immediately
                                _isGenderExpanded = false;
                              });
                            },
                            child: Text(
                              "Female",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = "Male";
                                _savedGender = "Male"; // Update immediately
                                _isGenderExpanded = false;
                              });
                            },
                            child: Text(
                              "Male",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedGender = "Other";
                                _savedGender = "Other"; // Update immediately
                                _isGenderExpanded = false;
                              });
                            },
                            child: Text(
                              "Other",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    endIndent: 20,
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: _updateProfile,
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 17,
                          color: const Color.fromARGB(255, 125, 255, 77),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
