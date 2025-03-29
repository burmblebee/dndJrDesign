import 'package:flutter/material.dart';

class BagOfHolding extends StatefulWidget {
  const BagOfHolding({super.key});

  @override
  State<BagOfHolding> createState() => _BagOfHoldingState();
}

class _BagOfHoldingState extends State<BagOfHolding> {
  final List<String> _items = [];
  final TextEditingController _textController = TextEditingController();

  void _addItem() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        // Add the new item to the list
        _items.add(_textController.text);
      });
      // Clear the text field
      _textController.clear();
    }
  }

  void _removeItem(int index) {
    setState(() {
      // Removes item @ specified index
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF464538),
      appBar: AppBar(
        backgroundColor: Color(0xFF25291C),
        title: const Text('Bag of Holding'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Your Items:',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 10),

          // Display the list of items
          Expanded(
            child: Container(
              width: 340,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color.fromARGB(81, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: _items
                      .asMap()
                      .entries
                      .map((entry) {
                        int index = entry.key;
                        String item = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            // Aligns icon and text in the middle
                            crossAxisAlignment: CrossAxisAlignment.center, 
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: Color.fromARGB(255, 241, 187, 87)),
                                onPressed: () => _removeItem(index),
                              ),
                              Flexible(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                  //add soft wrap so there wont be a right overflow
                                  softWrap: true, 
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                      .toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // The text field and button to add new items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Add a new item',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color.fromARGB(81, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 241, 187, 87),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF25291C),
        onTap: null,
        items: const [
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
        ],
      ),
    );
  }
}