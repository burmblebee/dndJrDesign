// -----------------------------------------------------------------------
// Filename: screen_home.dart
// Original Author: Dan Grissom
// Creation Date: 10/31/2024
// Copyright: (c) 2024 CSC322
// Description: This file contains the screen for a dummy home screen
//               history screen.

//////////////////////////////////////////////////////////////////////////
// Imports
//////////////////////////////////////////////////////////////////////////

// Flutter imports
import 'dart:async';

// Flutter external package imports
import '../../screens/dnd_forms/character_name.dart';
import '../../screens/dnd_forms/race_selection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// App relative file imports


//////////////////////////////////////////////////////////////////////////
// StateFUL widget which manages state. Simply initializes the state object.
//////////////////////////////////////////////////////////////////////////
class ScreenHome extends ConsumerStatefulWidget {
  static const routeName = '/home';

  @override
  ConsumerState<ScreenHome> createState() => _ScreenHomeState();
}

//////////////////////////////////////////////////////////////////////////
// The actual STATE which is managed by the above widget.
//////////////////////////////////////////////////////////////////////////
class _ScreenHomeState extends ConsumerState<ScreenHome> {
  // The "instance variables" managed in this state
  bool _isInit = true;

  ////////////////////////////////////////////////////////////////
  // Runs the following code once upon initialization
  ////////////////////////////////////////////////////////////////
  @override
  void didChangeDependencies() {
    // If first time running this code, update provider settings
    if (_isInit) {
      _init();
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  ////////////////////////////////////////////////////////////////
  // Initializes state variables and resources
  ////////////////////////////////////////////////////////////////
  Future<void> _init() async {}

  //////////////////////////////////////////////////////////////////////////
  // Primary Flutter method overridden which describes the layout and bindings for this widget.
  //////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {

    var uuid = Uuid();
    var characterID = uuid.v4();
    // Return the scaffold
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: ShapeBorder.lerp(CircleBorder(), StadiumBorder(), 0.5),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CharacterName(),
            ),
          );
        },
        splashColor: Theme.of(context).primaryColor,
        child: Icon(FontAwesomeIcons.plus),
      ),
      body: Text('Home'),
    );
  }
}
