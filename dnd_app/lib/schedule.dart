import 'package:dnd_app/add_session.dart';
import 'package:flutter/material.dart';
import 'package:dnd_app/event.dart';
import 'package:intl/intl.dart';


class Schedule extends StatefulWidget {
  final Map<DateTime, List<Event>> events; // Receiving events from AddSession

  const Schedule({super.key, required this.events});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  
  //this is the function that will take you to the add session page
  void _goToAddSession() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSession(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    // Get all scheduled dates and sort them
  List<DateTime> scheduledDates = widget.events.keys.toList();
  scheduledDates.sort();

  // Find the next scheduled session
  DateTime? nextSession;
  for (DateTime date in scheduledDates) {
    if (date.isAfter(DateTime.now()) || date.isAtSameMomentAs(DateTime.now())) {
      nextSession = date;
      break;
    }
  }

  // Format the next scheduled session date
  String nextSessionText = nextSession != null
       ? '${nextSession.month}/${nextSession.day}/${nextSession.year}'
       : 'No upcoming session';

    return Scaffold(
      backgroundColor: Color(0xFF464538),
      //this is a placeholder appbar
      appBar: AppBar(
        backgroundColor: Color(0xFF25291C),
        title: const Text(
          'this is appbar',
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
            ),
          ),
          //this is the image
          Container(
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/witch.jpg'),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
          ),
          SizedBox(height: 10),
          //this is the next scheduled session text + date
          Text(
            'Next Session: $nextSessionText',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 6),
          //this is the return to campain button 
          TextButton(
            onPressed: _goToAddSession, 
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 13),
              decoration: BoxDecoration(
                //the bg should probs be grey and white text
                color: Color.fromARGB(255, 241, 187, 87),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Text(
                'Return to Campaign',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ),
            //this is the schedules session text + sessions + button
          SizedBox(height: 10),
          // Scheduled sessions container with centered content
          Container(
            height: 295,
            width: 328,
            decoration: BoxDecoration(
              //should be grey bg with white text
               color: Color.fromARGB(81, 0, 0, 0),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Scheduled Sessions text
                Text(
  "Upcoming Sessions:",
  textAlign: TextAlign.center,
  style: TextStyle(
    fontSize: 20,
    color: Colors.white,
  ),
),
SizedBox(height: 20),
// If no events, show this message
widget.events.isEmpty
    ? Center(
        child: Text(
          'No scheduled sessions yet!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      )
    : Expanded(
        child: ListView.builder(
          itemCount: widget.events.length,
          itemBuilder: (context, index) {
            DateTime eventDate = widget.events.keys.elementAt(index);
            List<Event> eventsForDate = widget.events[eventDate]!;

            return Center(  // Centers the event item
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(8), // Half the height of the container
                width: 164, // Keep the width same as the parent container
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 241, 241, 192),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,  // Ensures the date and events are centered
                  children: [
                    Text(
                      DateFormat('M/d/y').format(eventDate), // Format the date
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    ...eventsForDate.map((event) {
                      return Text(
                        event.title,
                        style: TextStyle(color: Colors.black),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
                      SizedBox(height: 10),
          //will add session button
          ElevatedButton(
            onPressed: _goToAddSession, 
            style: ElevatedButton.styleFrom(
              // But background color
              backgroundColor: Color.fromARGB(255, 241, 187, 87), 
              // Text Color 
              foregroundColor: Colors.black, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
            ),
            child: Text('Add Session'),
            ),
          ],
        ),
        ),
          SizedBox(height: 14),

        ],
      ),
      //a place holder navbar
      bottomNavigationBar:
          BottomNavigationBar(backgroundColor: Color(0xFF25291C), items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          label: 'Temp',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: "Tempy",
        ),
      ]),
    );
  }
}
