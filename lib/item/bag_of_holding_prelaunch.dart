import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/widgets/navigation/combat_nav_bar.dart';

import 'fixed_item.dart';
import 'item sub-widgets/armor_details.dart';
import 'item sub-widgets/misc_details.dart';
import 'item sub-widgets/weapon_details.dart';
import 'item sub-widgets/wondrous_details.dart';

import '../prelaunch_campaign_screen.dart';

class BagOfHolding extends ConsumerStatefulWidget {
  BagOfHolding({super.key, required this.campaignId, required this.isDM});
  String campaignId;
  bool isDM;

  @override
  ConsumerState<BagOfHolding> createState() => _BagOfHoldingState();
}

class _BagOfHoldingState extends ConsumerState<BagOfHolding> {
  final List<String> _items = [];
  final TextEditingController _textController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Track the index of the item being edited
  int? _editingIndex;
  final List<Item> _premadeItems = [];
  final List<Item> _selectedPremadeItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
    pullPremadeItems();
  }

  Future<void> pullPremadeItems() async {
    final uuid = FirebaseAuth.instance.currentUser?.uid;
    final snapshot = await _firestore
        .collection('app_user_profiles')
        .doc(uuid)
        .collection('items')
        .get();

    setState(() {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final id = data['id'];
        final type = data['itemType'];
        debugPrint(type);
        switch (type) {
          case 'Weapon':
            _premadeItems.add(CombatItem.fromMap(id, data));
            break;
          case 'Armor':
            _premadeItems.add(ArmorItem.fromMap(id, data));
            break;
          case 'Wondrous':
            _premadeItems.add(WondrousItem.fromMap(id, data));
            break;
          default:
            _premadeItems.add(Item.fromMap(id, data));
        }
      }
    });
  }

  Future<void> _addPremadeItem(Item newItem) async {
    await _firestore
        .collection('user_campaigns')
        .doc(widget.campaignId)
        .collection('bag_of_holding_premade')
        .add(
          newItem.toMap(),
        );
    setState(() {
      _selectedPremadeItems.add(newItem);
    });
  }

  void pickItem() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose an item'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300, // Set a fixed height
            child: _premadeItems.isEmpty
                ? const Center(child: Text("No items available."))
                : ListView.builder(
                    shrinkWrap: true, // Prevents layout issues
                    itemCount: _premadeItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(_premadeItems[index].name),
                        onTap: () {
                          _addPremadeItem(_premadeItems[index]);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  // Load the Firestore items
  void _loadItems() async {
    final snapshot1 = await _firestore
        .collection('user_campaigns')
        .doc(widget.campaignId)
        .collection('bag_of_holding_basic')
        .orderBy('timestamp')
        .get();
    final snapshot2 = await _firestore
        .collection('user_campaigns')
        .doc(widget.campaignId)
        .collection('bag_of_holding_premade')
        .get();
    setState(() {
      _items.clear();
      _items.addAll(snapshot1.docs.map((doc) => doc['item'] as String));
      for (var doc in snapshot2.docs) {
        final data = doc.data();
        final id = doc.id;
        final type = data['itemType'];

        switch (type) {
          case 'Weapon':
            _selectedPremadeItems.add(CombatItem.fromMap(id, data));
            break;
          case 'Armor':
            _selectedPremadeItems.add(ArmorItem.fromMap(id, data));
            break;
          case 'Wondrous':
            _selectedPremadeItems.add(WondrousItem.fromMap(id, data));
            break;
          default:
            _selectedPremadeItems.add(Item.fromMap(id, data));
        }
      }

    });
  }

  // Add an item to Firestore
  Future<void> _addItem() async {
    if (_textController.text.isNotEmpty) {
      final newItem = _textController.text;
      await _firestore
          .collection('user_campaigns')
          .doc(widget.campaignId)
          .collection('bag_of_holding_basic')
          .add({
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
        .collection('user_campaigns')
        .doc(widget.campaignId)
        .collection('bag_of_holding_basic')
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
  Future<void> _saveEditedItem(int index, String newValue) async {
    final oldItem = _items[index];
    final snapshot = await _firestore
        .collection('user_campaigns')
        .doc(widget.campaignId)
        .collection('bag_of_holding_basic')
        .where('item', isEqualTo: oldItem)
        .get();

    for (var doc in snapshot.docs) {
      // Update the document with the new item
      await doc.reference.update({
        'item': newValue,
      });
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
        backgroundColor: const Color (0xFF25291C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, 
            MaterialPageRoute(
              builder: (context) => PreLaunchCampaignScreen(
                campaignID: widget.campaignId, isDM: widget.isDM,)));
          },
        ), 
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 20),
                const Text(
                  'Your Items:',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const Spacer(),
                IconButton(onPressed: (){pickItem();}, icon: Icon(Icons.add, color: const Color.fromARGB(255, 241, 187, 87))),
              ],
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
                    children: [
                      // Basic text items
                      ..._items.asMap().entries.map((entry) {
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
                                        controller:
                                            TextEditingController(text: item),
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
                                            _editingIndex = index;
                                          });
                                        },
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 10),

                      // Premade items
                      ..._selectedPremadeItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove,
                                      color: Color.fromARGB(255, 241, 187, 87)),
                                  onPressed: () => _removePremadeItem(item),
                                ),
                                Text(item.name,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white)),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye,
                                      color: Color.fromARGB(255, 241, 187, 87)),
                                  onPressed: () {
                                    if (item.itemType == ItemType.Weapon) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WeaponDetailsScreen(
                                            weapon: item as CombatItem,
                                          ),
                                        ),
                                      );
                                    } else if (item.itemType == ItemType.Armor) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ArmorDetailsScreen(
                                            armor: item as ArmorItem,
                                          ),
                                        ),
                                      );
                                    } else if (item.itemType == ItemType.Wondrous) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WondrousDetailsScreen(
                                            item: item as WondrousItem,
                                          ),
                                        ),
                                      );
                                    } else if (item.itemType ==
                                        ItemType.Miscellaneous) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MiscDetailsScreen(item: item),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Selected item is not available')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),

                        );
                      }).toList(),
                    ],
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
    );
  }

  void _removePremadeItem(Item item) {
    setState(() {
      _selectedPremadeItems.remove(item);
    });
    //remove from firestore
    _firestore
        .collection('user_campaigns')
        .doc(widget.campaignId)
        .collection('bag_of_holding_premade')
        .doc(item.id)
        .delete();
  }
}
