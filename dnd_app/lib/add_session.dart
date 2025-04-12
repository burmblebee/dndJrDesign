//original

// import 'package:dnd_app/event.dart';
// import 'package:dnd_app/schedule.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AddSession extends StatefulWidget {
//   const AddSession({super.key});

//   @override
//   State<AddSession> createState() => _AddSessionState();
// }

// class _AddSessionState extends State<AddSession> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   Map<DateTime, List<Event>> events = {}; // Stores created events
//   TextEditingController _eventController = TextEditingController();
//   late final ValueNotifier<List<Event>>
//       _selectedEvents; // Notifier for selected events

//   @override
//   void initState() {
//     super.initState();
//     // Initialize selected day to today
//     _selectedDay = _focusedDay;
//     _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
//     _fetchEventsFromFirestore();
//   }

//   void _fetchEventsFromFirestore() async {
//     // Clear the events map to prevent duplication
//     events.clear();

//     CollectionReference sessions = FirebaseFirestore.instance.collection('sessions');
//     QuerySnapshot querySnapshot = await sessions.get();

//     for (var doc in querySnapshot.docs) {
//       String dateString = doc['session_date'];
//       if (dateString.isNotEmpty) {
//         DateTime date = DateFormat('M/d/y').parse(dateString);
//         String title = doc['session_name'];

//         if (events.containsKey(date)) {
//           // Avoid adding duplicate event names
//           if (!events[date]!.any((event) => event.title == title)) {
//             events[date]!.add(Event(title));
//           }
//         } else {
//           events[date] = [Event(title)];
//         }
//       }
//     }

//     setState(() {
//       _selectedEvents.value = _getEventsForDay(_selectedDay!);
//     });
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         // Update the selected day
//         _focusedDay = focusedDay;
//         // Update the event list
//         _selectedEvents.value = _getEventsForDay(selectedDay);
//       });
//     }
//   }

//   List<Event> _getEventsForDay(DateTime day) {
//     DateTime normalizedDate = DateTime(day.year, day.month, day.day);
//     return events[normalizedDate] ?? [];
//   }

// //this is the function that will take you to the schedule page
//   void _goToSchedule() async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => Schedule(events: events), // Passing events
//       ),
//     );
//   }

//   void _saveEventToFirestore(DateTime date, String title) async {
//     CollectionReference sessions = FirebaseFirestore.instance.collection('sessions');
//     await sessions.add({
//       'session_date': DateFormat('M/d/y').format(date),
//       'session_name': title,
//     });
//   }

//   void _deleteEventFromFirestore(DateTime date, String title) async {
//     CollectionReference sessions = FirebaseFirestore.instance.collection('sessions');
//     QuerySnapshot querySnapshot = await sessions
//         .where('session_date', isEqualTo: DateFormat('M/d/y').format(date))
//         .where('session_name', isEqualTo: title)
//         .get();

//     for (var doc in querySnapshot.docs) {
//       await doc.reference.delete();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF464538),
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: _goToSchedule,
//         ),
//         title: Text(
//           "Calendar",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Color(0xFF25291C),
//       ),
//       floatingActionButton: FloatingActionButton(
//         //dark green bg
//         backgroundColor: Color(0xFF25291C),
//         onPressed: () {
//           // Add functionality here
//           showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                     backgroundColor: Color(0xFF464538),
//                     scrollable: true,
//                     title: const Text("Add Session",
//                         style: TextStyle(color: Colors.white, fontSize: 18)),
//                     content: Padding(
//                       padding: EdgeInsets.all(8),
//                       child: TextField(
//                         controller: _eventController,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     actions: [
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           //no bg or shadow
//                           backgroundColor: Colors.transparent,
//                           elevation: 0,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             DateTime normalizedDate = DateTime(
//                               _selectedDay!.year,
//                               _selectedDay!.month,
//                               _selectedDay!.day,
//                             );

//                             if (events.containsKey(normalizedDate)) {
//                           events[normalizedDate]!.add(Event(_eventController.text));
//                         } else {
//                           events[normalizedDate] = [Event(_eventController.text)];
//                         }

//                         // Save the event to Firestore
//                         _saveEventToFirestore(normalizedDate, _eventController.text);
//                       });

//                       _eventController.clear();
//                       Navigator.of(context).pop();
//                       _selectedEvents.value = _getEventsForDay(_selectedDay!);
//                     },
//                     child: Text(
//                       "Save",
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//         //white plus siign
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TableCalendar<Event>(
//                 //language
//                 locale: 'en_US',
//                 rowHeight: 43,
//                 headerStyle: const HeaderStyle(
//                   formatButtonVisible: false,
//                   titleCentered: true,
//                   //this will change the month color
//                   titleTextStyle: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                   ),
//                   //willl make arrows white
//                   leftChevronIcon:
//                       Icon(Icons.chevron_left, color: Colors.white),
//                   rightChevronIcon:
//                       Icon(Icons.chevron_right, color: Colors.white),
//                 ),
//                 calendarStyle: CalendarStyle(
//                   // first two are day and weekend color
//                   defaultTextStyle: TextStyle(color: Colors.white),
//                   weekendTextStyle: TextStyle(color: Colors.white),
//                   // Selected day text color
//                   selectedTextStyle: TextStyle(color: Colors.black),
//                   // Today's text color
//                   todayTextStyle: TextStyle(color: Colors.black),
//                   todayDecoration: BoxDecoration(
//                     // Background color for today
//                     color: const Color.fromARGB(147, 255, 255, 255),
//                     shape: BoxShape.circle,
//                   ),
//                   selectedDecoration: BoxDecoration(
//                     // Background color for selected day
//                     color: const Color.fromARGB(255, 241, 241, 192),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 availableGestures: AvailableGestures.all,
//                 selectedDayPredicate: (day) => isSameDay(day, _focusedDay),
//                 focusedDay: _focusedDay,
//                 firstDay: DateTime.utc(2010, 01, 01),
//                 lastDay: DateTime.utc(2030, 01, 01),
//                 onDaySelected: _onDaySelected,
//                 eventLoader: _getEventsForDay,
//                 onFormatChanged: (format) {
//                   if (_calendarFormat != format) {
//                     setState(() {
//                       _calendarFormat = format;
//                     });
//                   }
//                 },
//                 onPageChanged: (focusedDay) {
//                   _focusedDay = focusedDay;
//                 }),
//             SizedBox(height: 8),
//             Expanded(
//               child: ValueListenableBuilder<List<Event>>(
//                   valueListenable: _selectedEvents,
//                   builder: (context, value, _) {
//                     return ListView.builder(
//                         itemCount: value.length,
//                         itemBuilder: (context, index) {
//                           return Container(
//                             margin: EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 4),
//                             decoration: BoxDecoration(
//                               //this will be the yellowish bg color
//                               color: Color.fromARGB(255, 241, 241, 192),
//                               border: Border.all(),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ListTile(
//                           title: Text('${value[index].title}'),
//                           trailing: IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () {
//                               setState(() {
//                                 DateTime normalizedDate = DateTime(
//                                   _selectedDay!.year,
//                                   _selectedDay!.month,
//                                   _selectedDay!.day,
//                                 );

//                                 String title = value[index].title;
//                                 events[normalizedDate]?.removeAt(index);
//                                 if (events[normalizedDate]!.isEmpty) {
//                                   events.remove(normalizedDate);
//                                 }

//                                 // Delete the event from Firestore
//                                 _deleteEventFromFirestore(normalizedDate, title);
//                               });

//                               _selectedEvents.value = _getEventsForDay(_selectedDay!);
//                                 },
//                               ),
//                             ),
//                           );
//                         });
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//dont delete, most updated
import 'package:dnd_app/screens/event.dart';
import 'package:dnd_app/schedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSession extends StatefulWidget {
  const AddSession({super.key});

  @override
  State<AddSession> createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {}; // Stores created session
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>>
      _selectedEvents; 

  @override
  void initState() {
    super.initState();
    // Initialize selected day to today
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _fetchEventsFromFirestore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch events every time i come back
    _fetchEventsFromFirestore();
  }

  void _fetchEventsFromFirestore() async {
  // Clear the events map to prevent duplication
  events.clear();

  CollectionReference sessions = FirebaseFirestore.instance.collection('sessions');
  QuerySnapshot querySnapshot = await sessions.get();

  for (var doc in querySnapshot.docs) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?; // Safely cast to a Map
    if (data != null) {
      String? dateString = data['session_date'];
      String? timeString = data['session_time'];
      String? title = data['session_name'];

      // Ensure all required fields are non-null and valid
      if (dateString != null && dateString.isNotEmpty && 
          timeString != null && timeString.isNotEmpty && 
          title != null && title.isNotEmpty) {
        try {
          DateTime date = DateFormat('M/d/y').parse(dateString);

          // Normalize the date to only include year, month, and day
          DateTime normalizedDate = DateTime(date.year, date.month, date.day);

          if (events.containsKey(normalizedDate)) {
            if (!events[normalizedDate]!.any((event) => event.title == title)) {
              events[normalizedDate]!.add(Event(title, time: timeString));
            }
          } else {
            events[normalizedDate] = [Event(title, time: timeString)];
          }
        } catch (e) {
          print('Invalid date/time format: $dateString $timeString');
        }
      }
    }
  }

  setState(() {
    _selectedEvents.value = _getEventsForDay(_selectedDay!);
  });
}

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        // Update the selected day
        _focusedDay = focusedDay;
        // Update the event list
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    DateTime normalizedDate = DateTime(day.year, day.month, day.day);
    return events[normalizedDate] ?? [];
  }

  void _saveEventToFirestore(DateTime date, String title, String time) async {
    CollectionReference sessions = FirebaseFirestore.instance.collection('sessions');
    await sessions.add({
      'session_date': DateFormat('M/d/y').format(date),
      'session_time': time, 
      'session_name': title,
    });
  }

  void _deleteEventFromFirestore(DateTime date, String title) async {
    CollectionReference sessions = FirebaseFirestore.instance.collection('sessions');
    QuerySnapshot querySnapshot = await sessions
        .where('session_date', isEqualTo: DateFormat('M/d/y').format(date))
        .where('session_name', isEqualTo: title)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF464538),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Schedule(events: events),
              ),
            );
          },
        ),
        title: Text(
          "Calendar",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF25291C),
      ),
      floatingActionButton: FloatingActionButton(
        //dark green bg
        backgroundColor: Color(0xFF25291C),
        onPressed: () {
          // Add functionality here
          showDialog(
              context: context,
              builder: (context) {
                TextEditingController descriptionController = TextEditingController();
              //default time & min & am/pm
                String selectedHour = "00"; 
                String selectedMinute = "00"; 
                String selectedAmPm = "AM"; 

                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      backgroundColor: Color(0xFF464538),
                      scrollable: true,
                      title: const Text(
                        "Add Session",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    content: Column(
                      children: [
                        // Text field for event description
                        TextField(
                          controller: descriptionController,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter session",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Time selection dropdowns
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Hour dropdown
                            DropdownButton<String>(
                              value: selectedHour,
                              dropdownColor: Color(0xFF464538),
                              style: TextStyle(color: Colors.white),
                              items: List.generate(24, (index) {
                                String hour = index.toString().padLeft(2, '0'); 
                                return DropdownMenuItem(
                                  value: hour,
                                  child: Text(hour),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  selectedHour = value!;
                                });
                              },
                            ),
                            const Text(
                              ":",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            // Minute dropdown
                            DropdownButton<String>(
                              value: selectedMinute,
                              dropdownColor: Color(0xFF464538),
                              style: TextStyle(color: Colors.white),
                              items: List.generate(60, (index) {
                                String minute = index.toString().padLeft(2, '0');
                                return DropdownMenuItem(
                                  value: minute,
                                  child: Text(minute),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  selectedMinute = value!;
                                });
                              },
                            ),
                            // AM/PM dropdown
                            DropdownButton<String>(
                              value: selectedAmPm,
                              dropdownColor: Color(0xFF464538),
                              style: TextStyle(color: Colors.white),
                              items: ["AM", "PM"].map((period) {
                                return DropdownMenuItem(
                                  value: period,
                                  child: Text(period),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedAmPm = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (descriptionController.text.isNotEmpty) {
                            try {
                              // Convert selected time to 24-hour format
                              int hour = int.parse(selectedHour);
                              if (selectedAmPm == "PM" && hour != 12) {
                                hour += 12;
                              } else if (selectedAmPm == "AM" && hour == 12) {
                                hour = 0;
                            }

                        // Combine selected date and time
                        DateTime normalizedDate = DateTime(
                          _selectedDay!.year,
                          _selectedDay!.month,
                          _selectedDay!.day,
                          hour,
                          int.parse(selectedMinute),
                        );

                              setState(() {
                                // Add the event to the map
                                DateTime dayKey = DateTime(
                                  normalizedDate.year,
                                  normalizedDate.month,
                                  normalizedDate.day,
                                );

                                if (events.containsKey(dayKey)) {
                                  events[dayKey]!.add(Event(descriptionController.text));
                                } else {
                                  events[dayKey] = [Event(descriptionController.text)];
                                }

                                // Save the event to Firestore
                                _saveEventToFirestore(
                                  normalizedDate,
                                  descriptionController.text,
                                  "$selectedHour:$selectedMinute $selectedAmPm", // Store time in 12-hour format
                                );
                              });

                              // Clear the input and close the dialog
                              descriptionController.clear();
                              Navigator.of(context).pop();
                              _selectedEvents.value = _getEventsForDay(_selectedDay!);
                            } catch (e) {
                              // Show an error if something goes wrong
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("An error occurred. Please try again."),
                                ),
                              );
                            }
                          } else {
                            // Show an error if description is missing
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please add a session."),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TableCalendar<Event>(
                //language
                locale: 'en_US',
                rowHeight: 43,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  //this will change the month color
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  //willl make arrows white
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: Colors.white),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: Colors.white),
                ),
                calendarStyle: CalendarStyle(
                  // first two are day and weekend color
                  defaultTextStyle: TextStyle(color: Colors.white),
                  weekendTextStyle: TextStyle(color: Colors.white),
                  // Selected day text color
                  selectedTextStyle: TextStyle(color: Colors.black),
                  // Today's text color
                  todayTextStyle: TextStyle(color: Colors.black),
                  todayDecoration: BoxDecoration(
                    // Background color for today
                    color: const Color.fromARGB(147, 255, 255, 255),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    // Background color for selected day
                    color: const Color.fromARGB(255, 241, 241, 192),
                    shape: BoxShape.circle,
                  ),
                ),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, _focusedDay),
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2010, 01, 01),
                lastDay: DateTime.utc(2030, 01, 01),
                onDaySelected: _onDaySelected,
                eventLoader: _getEventsForDay,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                //SURPRISE HELLO IF READING :D
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                }),
            SizedBox(height: 8),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              //this will be the yellowish bg color
                              color: Color.fromARGB(255, 241, 241, 192),
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                '${value[index].title} ${value[index].time != null ? "at ${value[index].time}" : ""}',
                                style: TextStyle(color: Colors.black),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  DateTime normalizedDate = DateTime(
                                    _selectedDay!.year,
                                    _selectedDay!.month,
                                    _selectedDay!.day,
                                  );

                                  String title = value[index].title;
                                  events[normalizedDate]?.removeAt(index);
                                  if (events[normalizedDate]!.isEmpty) {
                                    events.remove(normalizedDate);
                                  }

                                  _deleteEventFromFirestore(normalizedDate, title);
                                });

                                 _selectedEvents.value = _getEventsForDay(_selectedDay!);
                              },
                              ),
                            ),
                          );
                        },
                    );
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}