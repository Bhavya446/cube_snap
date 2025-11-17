import 'package:flutter/material.dart';

class SolutionScreen extends StatelessWidget {
  final String moves;

  const SolutionScreen({
    super.key,
    required this.moves,
  });

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = moves.contains("SOLVER_NOT_INTEGRATED");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Solution"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SelectableText(
            moves,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      bottomNavigationBar: isPlaceholder
          ? const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          "Note: This is a placeholder solver.\n"
              "Integrate a real Kociemba algorithm for actual solutions.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13),
        ),
      )
          : null,
    );
  }
}
