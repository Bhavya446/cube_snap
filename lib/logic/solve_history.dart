import 'package:cloud_firestore/cloud_firestore.dart';

class SolveHistory {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> saveSolve({
    required String scramble,
    required String solution,
    required DateTime timestamp,
  }) async {
    await _db.collection("solve_history").add({
      "scramble": scramble,
      "solution": solution,
      "timestamp": timestamp,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> historyStream() {
    return _db
        .collection("solve_history")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
