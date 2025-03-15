import 'package:dnd_app/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Dateandtimepicker extends StatefulWidget {
  const Dateandtimepicker({super.key});

  @override
  State<Dateandtimepicker> createState() => _DateandTimePickerState();
}

class _DateandTimePickerState extends State<Dateandtimepicker> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {}; // Stores created events
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>>
      _selectedEvents; // Notifier for selected events

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay; // Initialize selected day to today
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay; // Update the selected day
        _selectedEvents.value = _getEventsForDay(selectedDay); // Update the event list
      });
    }
  }

 List<Event> _getEventsForDay(DateTime day) {
  DateTime normalizedDate = DateTime(day.year, day.month, day.day);
  return events[normalizedDate] ?? [];
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calendar")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality here
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                    scrollable: true,
                    title: const Text("Add Event"),
                    content: Padding(
                      padding: EdgeInsets.all(8),
                      child: TextField(
                        controller: _eventController,
                      ),
                    ),
                    actions: [
                      ElevatedButton(
          onPressed: () {
            setState(() {
              DateTime normalizedDate = DateTime(
                _selectedDay!.year,
                _selectedDay!.month,
                _selectedDay!.day,
              );

          if (events.containsKey(normalizedDate)) {
            events[normalizedDate]!.add(Event(_eventController.text));
        } else {
           events[normalizedDate] = [Event(_eventController.text)];
        }
      });

      _eventController.clear();
      Navigator.of(context).pop();
      _selectedEvents.value = _getEventsForDay(_selectedDay!); // Update the event list
    },
      child: Text("Save"),
  ),

    ]);
    });
    },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TableCalendar<Event>(
                locale: 'en_US', // Correct locale format
                rowHeight: 43,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
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
                onPageChanged:(focusedDay){
                  _focusedDay = focusedDay; 
                }
                ),
            SizedBox(height: 8),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () => print(""),
                          title: Text('${value[index].title}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                DateTime normalizedDate = DateTime(
                                  _selectedDay!.year,
                                  _selectedDay!.month,
                                  _selectedDay!.day,
                                );

                              events[normalizedDate]?.removeAt(index); // Remove event from list
                              if (events[normalizedDate]!.isEmpty) {
                                events.remove(normalizedDate); // Remove key if no events remain
                              }
                            });

                             _selectedEvents.value = _getEventsForDay(_selectedDay!); // Update UI
                          },
                        ),
                      ),
                      );
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
