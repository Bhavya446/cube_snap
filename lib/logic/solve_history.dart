import 'package:cloud_firestore/cloud_firestore.dart';

class SolveHistoryService {
  static Future<void> saveSolve({
    required String cubeString,
    required String solution,
  }) async {
    final moveCount = solution.split(' ').length;

    await FirebaseFirestore.instance.collection('solutions').add({
      'cubeString': cubeString,
      'solution': solution,
      'moveCount': moveCount,
      'timestamp': DateTime.now(),
    });
  }

  static Stream<QuerySnapshot> getSolveHistory() {
    return FirebaseFirestore.instance
        .collection('solutions')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
