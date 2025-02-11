import 'package:dnd_jr_design/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_navbar.dart';

final ThemeData warlocksTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF464538), // Dark olive green
  scaffoldBackgroundColor: Color(0xFF464538), // Deep earthy green
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF464538),
    titleTextStyle: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF25291C),
    selectedItemColor: Color.fromARGB(255, 238, 228, 207), // Warm beige highlight
    unselectedItemColor: Color.fromARGB(255, 159, 158, 154), // Muted grayish tone
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Color(0xFF25291C),
    
  ),
  textTheme: TextTheme(
    bodyMedium:
        TextStyle(color: Color(0xFFBFBBA5)), // Soft, readable beige text
  ),
  cardColor: Color(0xFF464538), // Match primary color for consistency
  iconTheme: IconThemeData(
      color: Color(0xFFD4C097)), // Matching accent color for icons
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: warlocksTheme, // Apply the custom theme
      home: HomeScreen(),
    );
  }
}
