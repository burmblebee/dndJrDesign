import 'package:dnd_jr_design/diceRoller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'DMcombatScreen.dart';

Future<void> main() async {
  runApp(
    ProviderScope( // Wrap with ProviderScope
      child: MaterialApp(
        home: DMCombatScreen(campaignId: '15'),
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF464538), // Dark olive green
          scaffoldBackgroundColor: const Color(0xFF464538), // Deep earthy green
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF25291C),
            titleTextStyle: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF25291C),
            selectedItemColor: Color.fromARGB(255, 243, 241, 230), // Warm white highlight
            unselectedItemColor: Color.fromARGB(255, 159, 158, 154), // Muted grayish tone
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Color(0xFF25291C),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
                color: Color.fromARGB(255, 243, 241, 230)), // Soft warm white
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                  const Color(0xFF25291C)), // The darker gray color
            ),
          ),
          cardColor: const Color(0xFF464538), // Match primary color for consistency
          iconTheme: const IconThemeData(
              color: Color(0xFFD4C097)), // Matching accent color for icons
        ),
      ),
    ),
  );
}
