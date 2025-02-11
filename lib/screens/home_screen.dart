//create a basic blank homescreen for test
import 'package:dnd_jr_design/widgets/bottom_navbar.dart';
import 'package:dnd_jr_design/widgets/main_appbar.dart';
import 'package:dnd_jr_design/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

// import '../widgets/bottom_navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context).primaryColor;
    
    return Scaffold(
     // add a custom drawer here
      appBar: MainAppbar(),
      drawer: MainDrawer(),
      backgroundColor: theme,
      //backgroundColor: Color(0xFF464538),
      //use the color from the color scheme here!
      
      body:  Center(
        child: Text('This is the home screen'),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
