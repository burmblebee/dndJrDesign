import 'package:flutter/material.dart';

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
      width: 340,
      //70 for norm & 200 for expanded
      height: isExpanded ? 200 : 70,
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
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF464538),
      //tempy appbar
      appBar: AppBar(
        title: const Text(
          "Notes",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF25291C),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Your Notes:",
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
                height: 100,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(81, 0, 0, 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(),
                ),
              ),
            ),

            //player character sheet section
            const SizedBox(height: 10),
            ExpandableSection(
              title: "View Player Character Sheets",
              expandedContent: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                const SizedBox(width: 10), 
                Expanded(
                  child: Text(
                    "Twmpyy",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // save npcs section
            const SizedBox(height: 10),
            ExpandableSection(
              title: "View Saved NPC's & Characters",
              expandedContent: Row(
                children: [
                  Icon(
                    Icons.group,
                    color: Colors.white,
                    size: 24,
                  ),
            const SizedBox(width: 10), 
            Expanded(
              child: Text(
                "Tempy",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  ),
                ),
              ),
              ],
            ),
          ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      //temp bot nav
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF25291C),
        onTap: null,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'temp',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, color: Colors.white),
            label: "tempyy",
          ),
        ],
      ),
    );
  }
}