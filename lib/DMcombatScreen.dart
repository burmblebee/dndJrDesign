import 'package:flutter/material.dart';
import 'character.dart';
import 'diceRoller.dart';

class DMCombatScreen extends StatefulWidget {
  const DMCombatScreen({super.key, required this.campaignId});
  final String campaignId;

  @override
  State<StatefulWidget> createState() => _DMCombatScreenState();
}


class _DMCombatScreenState extends State<DMCombatScreen> {
  late Color oddItemColor;
  late Color evenItemColor;
  List<Character> characters = [
    Character(
        name: 'Character 1111111111111111111111111111111111111111111111',
        health: 100,
        maxHealth: 100,
        armorClass: 10),
    Character(name: 'Character 2', health: 80, maxHealth: 80, armorClass: 12),
    Character(name: 'Character 3', health: 120, maxHealth: 120, armorClass: 15),
    Character(name: 'Character 4', health: 90, maxHealth: 90, armorClass: 14),
    Character(name: 'Character 5', health: 110, maxHealth: 110, armorClass: 13),
    Character(name: 'Character 6', health: 70, maxHealth: 70, armorClass: 11),
    Character(name: 'Character 7', health: 130, maxHealth: 130, armorClass: 16),
    Character(name: 'Character 8', health: 60, maxHealth: 60, armorClass: 9),
    Character(name: 'Character 9', health: 140, maxHealth: 140, armorClass: 17),
    Character(name: 'Character 10', health: 50, maxHealth: 50, armorClass: 8),
    Character(
        name: 'Character 11', health: 150, maxHealth: 150, armorClass: 18),
    Character(name: 'Character 12', health: 40, maxHealth: 40, armorClass: 7),
    Character(
        name: 'Character 13', health: 160, maxHealth: 160, armorClass: 19),
    Character(name: 'Character 14', health: 30, maxHealth: 30, armorClass: 6),
  ];

  //TODO: Figure out how to have a little pop up anytime someone rolls within the campaign
  //TODO: New combat button
  //TODO: New character button
  //TODO: Attack/Heal button
  //TODO: Edit health button
  //TODO: Figure out providers and ChangeNotifier to update across devices


  Widget currentTurnOrder() {
    return SizedBox(
      height: 450, // Ensures it has a defined height
      child: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: [
          for (int index = 0; index < characters.length; index++)
            Container(
              key: ValueKey(characters[index]), // Ensure unique key
              decoration: BoxDecoration(
                color: index.isEven ? evenItemColor : oddItemColor, // Apply background color
                borderRadius: BorderRadius.circular(8), // Optional: Add border radius for rounded corners
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero, // Remove padding for more control
                title: Row(
                  children: [
                    // Use Expanded for better flexibility
                    Expanded(
                      child: Text(
                        characters[index].name,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          overflow: TextOverflow.ellipsis, // Handle overflow
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 5),
                    // Character Health
                    Text(
                      '${characters[index].health}/${characters[index].maxHealth}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Character Armor Class
                    Text(
                      '${characters[index].armorClass}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                trailing: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle), // Drag handle icon
                ),
              ),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final Character character = characters.removeAt(oldIndex);
            characters.insert(newIndex, character);
          });
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Initialize colors based on theme
    oddItemColor = Theme.of(context).canvasColor;
    evenItemColor = Theme.of(context).hoverColor;
    return Scaffold(
      appBar: AppBar(title: const Text('Combat Screen')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to DiceRoller and pass the campaignId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DiceRollScreen(campaignId: widget.campaignId),
            ),
          );
        },
        child: const Icon(Icons.casino),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add new character logic
                    setState(() {
                      characters.add(Character(name: 'New Character'));
                    });
                  },
                  child: const Text('Add New Character'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text('Attack/Heal Character'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {

                  },
                  child: const Text('Edit Health'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {

                  },
                  child: const Text('Start New Combat'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).canvasColor,
              child: Text('Current Turn Order',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 40), // For alignment
                Text('Character Name',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const Spacer(),
                Text('HP',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(width: 30), // For alignment
                Text('AC',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(width: 100),
              ],
            ),
            currentTurnOrder(),
            const Spacer(),


          ],
        ),
      ),
    );
  }
}
