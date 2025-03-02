import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ClassService {
  static Future<Map<String, dynamic>> loadClasses() async {
    String jsonString =
        await rootBundle.loadString('lib/data/SRD Data/classes.json');
    return json.decode(jsonString);
  }

  // Returns the class data for a given class name (for example, "Bard").
  static Future<Map<String, dynamic>> getClassData(String className) async {
    final classes = await loadClasses();
    return classes[className];
  }
}
