import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BagOfHolding extends StatefulWidget {
  const BagOfHolding({super.key});

  @override
  State<BagOfHolding> createState() => _BagOfHoldingState();
}

class _BagOfHoldingState extends State<BagOfHolding> {
  final List<String> _items = [];
  final TextEditingController _textController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Firestore collection ref
  final String collectionPath = "/bag_of_holding/HW65FS7mJ4WQD2arSplf/items";
  // Track the index of the item being edited
  int? _editingIndex; 

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // Load the Firestore items
  void _loadItems() async {
    final snapshot =
        await _firestore.collection(collectionPath).orderBy('timestamp').get();
    setState(() {
      // Clear the existing items
      _items.clear();
      _items.addAll(snapshot.docs.map((doc) => doc['item'] as String));
    });
  }

  // Add an item to Firestore
  Future<void> _addItem() async {
    if (_textController.text.isNotEmpty) {
      final newItem = _textController.text;
      await _firestore.collection(collectionPath).add({
        'item': newItem,
        // Add a timestamp
        'timestamp': FieldValue.serverTimestamp(), 
      });
      setState(() {
        // Add the new item to the list
        _items.add(newItem);
      });
      // Clear the text field
      _textController.clear();
    }
  }

  // Remove an item from Firestore
  void _removeItem(int index) async {
    final itemToRemove = _items[index];
    final snapshot = await _firestore
        .collection(collectionPath)
        .where('item', isEqualTo: itemToRemove)
        .get();

    for (var doc in snapshot.docs) {
      // Delete the document from Firestore
      await doc.reference.delete();
    }
    setState(() {
      // Remove the item at the specified index
      _items.removeAt(index);
    });
  }

  //to save the edited item back to firestor
  Future<void> _saveEditedItem(int index, String newValue) async{
    final oldItem = _items[index];
    final snapshot = await _firestore
        .collection(collectionPath)
        .where('item', isEqualTo: oldItem)
        .get();

    for (var doc in snapshot.docs) {
      // Update the document with the new item
      await doc.reference.update({ 'item': newValue,});
    }
    setState(() {
      // Update the item in the list
      _items[index] = newValue;
      // Reset editing index after saving
      _editingIndex = null; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF464538),
      appBar: AppBar(
        backgroundColor: const Color(0xFF25291C),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(81, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: _items.asMap().entries.map((entry) {
                    int index = entry.key;
                    String item = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove,
                                color: Color.fromARGB(255, 241, 187, 87)),
                            onPressed: () => _removeItem(index),
                          ),
                          Flexible(
                            child: _editingIndex == index
                                ? TextField(
                                  autofocus: true,
                                  // Pre-fill with current text
                                  controller: TextEditingController(
                                    text: item), 
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                  onSubmitted: (newValue) =>
                                    _saveEditedItem(index, newValue),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Edit item',
                                    hintStyle:
                                      TextStyle(color: Colors.white54),
                                    ),
                                  )
                                : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // Enter editing mode
                                      _editingIndex = index; 
                                    });
                                  },
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Add a new item',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color.fromARGB(81, 255, 255, 255),
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
                    backgroundColor: const Color.fromARGB(255, 241, 187, 87),
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

