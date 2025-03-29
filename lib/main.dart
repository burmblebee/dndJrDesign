import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:warlocks_of_the_beach/login_screen.dart';
import 'package:warlocks_of_the_beach/screens/campaign_screen.dart';
import 'package:warlocks_of_the_beach/screens/character_sheet/character_list.dart';
import 'package:warlocks_of_the_beach/screens/dnd_forms/character_name.dart';
import 'firebase_options.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Warlocks of the Beach',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF464538), // Dark olive green
          scaffoldBackgroundColor: const Color(0xFF464538), // Deep earthy green
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF25291C),
            titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          listTileTheme: const ListTileThemeData(
            textColor: Colors.white,
            tileColor: Color.fromARGB(255, 28, 28, 34),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          segmentedButtonTheme: SegmentedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 28, 28, 34)),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF25291C),
            selectedItemColor: Color.fromARGB(255, 243, 241, 230), // Warm white
            unselectedItemColor: Color.fromARGB(255, 159, 158, 154), // Muted gray
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Color(0xFF25291C),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Color.fromARGB(255, 243, 241, 230),
            ), // Soft warm white
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                const Color(0xFF25291C), // The darker gray color
              ),
            ),
          ),
          cardColor: const Color(0xFF464538), // Match primary color for consistency
          iconTheme: const IconThemeData(
            color: Color(0xFFD4C097), // Matching accent color for icons
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(), 
          '/character_creator': (context) => const CharacterName(),
          '/campaign_screen': (context) => const CampaignScreen(),
          '/login_screen': (context) => const LoginScreen(),
          '/character_sheets' :(context) => CharacterList(),
        },
      ),
    );
  }
}
