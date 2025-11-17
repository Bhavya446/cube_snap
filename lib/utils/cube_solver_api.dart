import 'dart:convert';
import 'package:http/http.dart' as http;

class CubeSolverAPI {
  static const String baseUrl =
      "https://cube-solver-backend.onrender.com"; // your Python backend

  static Future<String> solveCube(String cubeString) async {
    final url = Uri.parse("$baseUrl/solve");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"cube": cubeString}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data["solution"] ?? "No solution returned";
    } else {
      throw "Error ${res.statusCode}: ${res.body}";
    }
  }
}
