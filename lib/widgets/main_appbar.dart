import 'package:flutter/material.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context).appBarTheme;

    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text('Warlocks of the Beach', style: TextStyle(color: Colors.white),),
      //backgroundColor: theme.backgroundColor,
       backgroundColor: Color(0xFF25291C),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}