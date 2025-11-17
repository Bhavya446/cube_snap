import 'package:flutter/material.dart';
import '../logic/patterns.dart';

class PatternsScreen extends StatelessWidget {
  const PatternsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cube Patterns"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: patterns.entries.map((entry) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(entry.key),
              subtitle: Text(entry.value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
