import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LastCubeStorage {
  static const _key = "last_cube_faces";

  static Future<void> saveCube(List<List<int>> faces) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(faces);
    await prefs.setString(_key, encoded);
  }

  static Future<List<List<int>>?> loadCube() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map<List<int>>(
          (face) => (face as List<dynamic>).map((e) => e as int).toList(),
    )
        .toList();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
