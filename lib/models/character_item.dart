import 'package:warlocks_of_the_beach/screens/dnd_forms/character_loader_screen.dart';

import 'package:flutter/material.dart';
import 'character.dart';

class CharacterItem extends StatelessWidget {
  CharacterItem({
    super.key,
    required this.character,
    required this.characterName,
    required this.background,
    required this.race,
    required this.characterClass,
    required this.abilityScores,
  });

  final Character character;
  final characterName;
  final background;
  final race;
  final characterClass;
  final abilityScores;
  final Color customColor = const Color.fromARGB(255, 138, 28, 20);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterLoaderScreen(
                characterName: characterName,
                characterBackground: background,
                characterClass: characterClass,
                characterRace: race,
                abilityScores: abilityScores,
              ),
              //TODO: Send to that character's screen. Gonna need to make it accept a character name or something so we can access the correct character
            ));
      },
      child: Card(
        color: customColor,
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Row(
              children: [
                // CachedNetworkImage(
                //   imageUrl: character.picture,
                //   width: 50,
                //   height: 50,
                //   fit: BoxFit.cover,
                //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                //       CircularProgressIndicator(
                //           value: downloadProgress.progress),
                //   errorWidget: (context, url, error) => const Icon(Icons.error),
                // ),
                Image(
                    image: NetworkImage(character.picture),
                    width: 75,
                    height: 75),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: 175,
                  child: Text(
                    character.name,
                    style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      character.race,
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Text(
                      character.characterClass,
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            )),
      ),
    );
  }
}
