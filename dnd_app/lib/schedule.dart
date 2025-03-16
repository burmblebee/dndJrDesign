import 'package:flutter/material.dart';


class Schedule extends StatefulWidget {
  const Schedule({super.key});

  

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF464538),
      appBar: AppBar(
        backgroundColor: Color(0xFF25291C),
        title: const Text('this is appbar',),
      ),
      body: Center(
        child: Text(
              'This is nothing',
            ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:Color(0xFF25291C),
        items:const[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white,),
            label: 'Temp',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Tempy",
          ),
        ]
        ),
    );
  }
}
