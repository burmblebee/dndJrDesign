// import 'package:dnd_character_creator/screens/specifics_selection.dart';
import 'specifics_screen.dart';
import 'package:flutter/material.dart';
import '../../data/background_data.dart';
import '../../widgets/loaders/background_data_loader.dart';
import '../../widgets/buttons/navigation_button.dart';
import '../../widgets/main_drawer.dart';


class BackgroundScreen extends StatefulWidget {
  const BackgroundScreen({super.key, required this.characterName, required this.className, required this.raceName});
  final String characterName;
  final String className;
  final String raceName;

  @override
  State<StatefulWidget> createState() {
    return _BackgroundScreenState();
  }
}

class _BackgroundScreenState extends State<BackgroundScreen> {
  final backgrounds = BackgroundData;
  final Color customColor = const Color.fromARGB(255, 138, 28, 20);

  String _selectedBackground = 'Acolyte';

  // void _saveSelections() async {
  //   final url = Uri.https(
  //       'dndmobilecharactercreator-default-rtdb.firebaseio.com',
  //       '${widget.characterName}.json');
  //   final response = await http.get(url);
  //   if (response.body != 'null') {
  //     await http.delete(url);
  //   }
  //   await http.post(url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode({
  //         'background': _selectedBackground,
  //       }));
  // }
  void _saveSelections() async {

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Background"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: Row(
        children: [
          NavigationButton(
            onPressed: () {
              Navigator.pop(context);
            },
            textContent: 'Back',
          ),
          const SizedBox(width: 30),
          NavigationButton(
            textContent: "Next",
            onPressed: () {
              _saveSelections();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  SpecificsScreen(characterName: widget.characterName, className: widget.className, raceName: widget.raceName, backgroundName: _selectedBackground,)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Pick your background',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 350,
                child: Center(
                  child: DropdownButton<String>(
                    value: _selectedBackground,
                    items: backgrounds.keys
                        .map(
                          (background) => DropdownMenuItem(
                        value: background,
                        child: Text(background),
                      ),
                    )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBackground = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: 500,
                  width: 350,
                  child: SingleChildScrollView(
                    child: BackgroundDataLoader(
                      backgroundName: _selectedBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}