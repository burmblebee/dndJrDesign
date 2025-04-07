import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SpellTile extends StatefulWidget {
  final String spellName;
  final bool isCantrip;
  final String summary;
  final VoidCallback onTap;
  final VoidCallback onInfoTap;
  final bool isSelected;

  const SpellTile({
    Key? key,
    required this.spellName,
    required this.isCantrip,
    required this.summary,
    required this.onTap,
    required this.onInfoTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  _SpellTileState createState() => _SpellTileState();
}

class _SpellTileState extends State<SpellTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.grey[850],
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.wandMagic,
            color: Theme.of(context).iconTheme.color),
        title: Text(
          widget.spellName,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          widget.summary,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.info_outline,
                  color: Theme.of(context).iconTheme.color),
              onPressed: widget.onInfoTap,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: widget.isSelected
                  ? const Icon(
                      Icons.check_circle,
                      key: ValueKey('selected'),
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.add_circle_outline,
                      key: const ValueKey('unselected'),
                      color: Theme.of(context).iconTheme.color,
                    ),
            ),
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
