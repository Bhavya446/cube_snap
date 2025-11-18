import 'package:cloud_firestore/cloud_firestore.dart';

class LastCubeStorage {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Save the 6 faces (each 9 colors)
  static Future<void> saveCube(List<List<int>> faces) async {
    await _db.collection("user_cube").doc("last").set({
      "faces": faces,
      "timestamp": DateTime.now().toIso8601String(),
    });
  }

  /// Load last cube — returns List<List<int>> or null
  static Future<List<List<int>>?> loadCube() async {
    final doc = await _db.collection("user_cube").doc("last").get();
    if (!doc.exists) return null;

    final raw = doc.data()?["faces"];
    if (raw == null) return null;

    return (raw as List)
        .map((f) => (f as List).map((x) => x as int).toList())
        .toList();
  }
}
