import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../prelaunch_campaign_screen.dart';

class ExpandableSection extends StatefulWidget {
  final String title;
  final Widget expandedContent;

  const ExpandableSection({
    Key? key,
    required this.title,
    required this.expandedContent,
  }) : super(key: key);

  @override
  _ExpandableSectionState createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // expandable section with animation
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // width: 340,
      //70 for norm & 200 for expanded
      height: isExpanded ? 200 : 70,
      width: isExpanded ? 340 : 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(81, 0, 0, 0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              //if icon is click then expand or collaps
              IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                //icon change based on if expanded or not
                icon: Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          if (isExpanded)
            Expanded(
              child: SingleChildScrollView(
                child: widget.expandedContent,
              ),
            ),
        ],
      ),
    );
  }
}

class Notes extends StatefulWidget {
  const Notes({super.key, required this.campaignId, required this.isDm});
  final bool isDm;
  final String campaignId;
  // Constructor to accept campaignId

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final List<Map<String, dynamic>> _notes = []; // Store notes with timestamps
  final TextEditingController _textController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Load notes from Firestore
  // Improved Path to get from the campaign in question
  void _loadNotes() async {
    // Notes for players
    if (!_viewingDMNotes) { // Player Notees
      final snapshot = await _firestore
          .collection('user_campaigns').doc(widget.campaignId).collection('notes')
          .orderBy('timestamp', descending: false)
          .get();
      setState(() {
        _notes.clear();
        _notes.addAll(snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'note': doc['user_notes'],
            'timestamp': doc['timestamp'],
          };
        }));
      });
    } else { // This displays the notes for DM
      final snapshot = await _firestore
          .collection('user_campaigns').doc(widget.campaignId).collection('DMnotes')
          .orderBy('timestamp', descending: false)
          .get();
      setState(() {
        _notes.clear();
        _notes.addAll(snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'note': doc['user_notes'],
            'timestamp': doc['timestamp'],
          };
        }));
      });
    }
  }

  // Add a new note to Firestore
  Future<void> _addNote() async {
    if (!_viewingDMNotes) { // Player Notees
      if (_textController.text.isNotEmpty) {
        final newNote = _textController.text;
        final docRef = await _firestore.collection('user_campaigns').doc(widget.campaignId).collection('notes').add({
          'user_notes': newNote,
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          _notes.add({
            'id': docRef.id,
            'note': newNote,
            'timestamp': DateTime.now(),
          });
        });
        _textController.clear();
      }
    } else { // DM Notes
      if (_textController.text.isNotEmpty) {
        final newNote = _textController.text;
        final docRef = await _firestore.collection('user_campaigns').doc(widget.campaignId).collection('DMnotes').add({
          'user_notes': newNote,
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          _notes.add({
            'id': docRef.id,
            'note': newNote,
            'timestamp': DateTime.now(),
          });
        });
        _textController.clear();
      }
    }

  }

  // Remove a note from Firestore
  Future<void> _removeNote(int index) async {
    if (!_viewingDMNotes) { // Player Notees
      final noteId = _notes[index]['id'];
      await _firestore.collection('user_campaigns').doc(widget.campaignId).collection('notes').doc(noteId).delete();
      setState(() {
        _notes.removeAt(index);
      });
    } else { // DM Notes
      final noteId = _notes[index]['id'];
      await _firestore.collection('user_campaigns').doc(widget.campaignId).collection('DMnotes').doc(noteId).delete();
      setState(() {
        _notes.removeAt(index);
      });
    }
  }

  // Save an edited note to Firestore
  Future<void> _saveEditedNote(int index, String newValue) async {
    if (!_viewingDMNotes) { // Player Notees
      final noteId = _notes[index]['id'];
      await _firestore.collection('user_campaigns').doc(widget.campaignId).collection('notes').doc(noteId).update({
        'user_notes': newValue,
      });
      setState(() {
        _notes[index]['note'] = newValue;
        _editingIndex = null;
      });
    } else { // DM Notes
      final noteId = _notes[index]['id'];
      await _firestore.collection('user_campaigns').doc(widget.campaignId).collection('DMnotes').doc(noteId).update({
        'user_notes': newValue,
      });
      setState(() {
        _notes[index]['note'] = newValue;
        _editingIndex = null;
      });
    }
  }

  // Variable to hold the viewing of DM notes
  bool _viewingDMNotes = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF464538),
      appBar: AppBar(
        backgroundColor: const Color (0xFF25291C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => PreLaunchCampaignScreen(
                      campaignID: widget.campaignId, isDM: widget.isDm,)));
          },
        ),
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            if(widget.isDm) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Player', style: TextStyle(fontWeight: FontWeight.bold)),
                  Switch(value: _viewingDMNotes, onChanged: (value) {
                    setState(() {
                      _viewingDMNotes = value;
                    });
                    _loadNotes();
                  }),
                  const Text('DM', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              // ElevatedButton.icon(onPressed: (){
              //   setState((){_viewingDMNotes = !_viewingDMNotes;});_loadNotes();
              // },
              //     label: const Text('DM Notes'), icon: FaIcon(FontAwesomeIcons.dragon, size: 20)),
              // const SizedBox(height: 10),
            ],
            const SizedBox(height: 20),
            Text(
              !_viewingDMNotes ? "Player Notes" : "DM Notes",
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: 340,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(81, 0, 0, 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    //making sure notes are shown in order based of time
                    children: _notes.asMap().entries.map((entry) {
                      int index = entry.key;
                      String note = entry.value['note'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //to remove stuff
                            IconButton(
                              icon: const Icon(Icons.remove,
                                  color: Color.fromARGB(255, 241, 187, 87)),
                              onPressed: () => _removeNote(index),
                            ),
                            //enable editing
                            Flexible(
                              child: _editingIndex == index
                                  ? TextField(
                                autofocus: true,
                                controller:
                                TextEditingController(text: note),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                                onSubmitted: (newValue) =>
                                    _saveEditedNote(index, newValue),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Edit note',
                                  hintStyle:
                                  TextStyle(color: Colors.white54),
                                ),
                              )
                                  : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _editingIndex = index;
                                  });
                                },
                                child: Text(
                                  note,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            //player character sheet section
            // Removed 4/8/25 Unneeded
            /**
                const SizedBox(height: 10),
                ExpandableSection(
                title: "View Player Character Sheets",
                expandedContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                children: [
                Icon(
                Icons.person,
                color: Colors.white,
                size: 27,
                ),
                const SizedBox(width: 10),
                Expanded(
                child: Text(
                "Dingus",
                style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                ),
                ),
                ),
                ],
                ),
                const SizedBox(height: 10),
                Row(
                children: [
                Icon(
                Icons.person,
                color: Colors.white,
                size: 27,
                ),
                const SizedBox(width: 10),
                Expanded(
                child: Text(
                "Bee",
                style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                ),
                ),
                ),
                ],
                ),
                const SizedBox(height: 10),
                Row(
                children: [
                Icon(
                Icons.person,
                color: Colors.white,
                size: 27,
                ),
                const SizedBox(width: 10),
                Expanded(
                child: Text(
                "Eldrin",
                style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                ),
                ),
                ),
                ],
                ),
                ],
                ),
                ),
             */

            //save npcs section
            // Removed 4/8/25 Unneeded
            /**
                const SizedBox(height: 10),
                ExpandableSection(
                title: "View Saved NPC's & Characters",
                expandedContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                children: [
                Icon(
                Icons.person,
                color: Colors.white,
                size: 27,
                ),
                const SizedBox(width: 10),
                Expanded(
                child: Text(
                "Dart",
                style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                ),
                ),
                ),
                ],
                ),
                const SizedBox(height: 10),
                Row(
                children: [
                Icon(
                Icons.person,
                color: Colors.white,
                size: 27,
                ),
                //are you reading this 0-0
                // Maybe perhaps
                const SizedBox(width: 10),
                Expanded(
                child: Text(
                "Cart",
                style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                ),
                ),
                ),
                ],
                ),
                ],
                ),
                ),
                const SizedBox(height: 10),
             */
          ],
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color(0xFF464538),
                title: const Text(
                  "Add a New Note",
                  style: TextStyle(color: Colors.white),
                ),
                content: SizedBox(
                  // height for typing
                  height: 150,
                  child: Column(
                    children: [
                      TextField(
                        controller: _textController,
                        style: const TextStyle(color: Colors.white),
                        //multi-line input
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "Enter your note",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    //if press cancel it will close without saving
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addNote();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 241, 187, 87),
                    ),
                    child: const Text("Add", style: TextStyle(color: Colors.black)),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: const Color.fromARGB(255, 241, 187, 87),
        // Changed to pencil icon
        child: const Icon(Icons.edit, color: Colors.black),
      ),
    );
  }
}