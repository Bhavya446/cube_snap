import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PatternsScreen extends StatelessWidget {
  const PatternsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patterns = [
      {
        "name": "Checkerboard",
        "moves": "M2 E2 S2 (or) 2R 2L 2F 2B 2U 2D",
      },
      {
        "name": "Cube in a Cube",
        "moves": "F L F U' R U F2 L2 U' L' B D' B' L2 U",
      },
      {
        "name": "Cross",
        "moves": "F R U R' U' F'",
      },
    ];

    return Container(
      decoration: const BoxDecoration(gradient: kMainBackgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Cube Patterns"),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: patterns.length,
          itemBuilder: (context, index) {
            final p = patterns[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p['name']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p['moves']!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
