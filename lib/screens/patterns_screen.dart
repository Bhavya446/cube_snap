import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constants.dart';

class PatternsScreen extends StatelessWidget {
  const PatternsScreen({super.key});

  void _haptic() => HapticFeedback.lightImpact();

  @override
  Widget build(BuildContext context) {
    final patterns = _patternsData;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kMainBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white70),
                      onPressed: () {
                        _haptic();
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Cube Patterns",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: patterns.length,
                  itemBuilder: (context, index) {
                    final p = patterns[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _PatternCard(
                        title: p.title,
                        subtitle: p.subtitle,
                        moves: p.moves,
                        assetPath: p.assetPath,
                        onTap: _haptic,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pattern {
  final String title;
  final String subtitle;
  final String moves;
  final String assetPath;

  _Pattern({
    required this.title,
    required this.subtitle,
    required this.moves,
    required this.assetPath,
  });
}

final List<_Pattern> _patternsData = [
  _Pattern(
    title: "Checkerboard",
    subtitle: "Classic alternating pattern on all faces",
    moves: "M2 E2 S2  (or)  (R2 L2 U2 D2 F2 B2)",
    assetPath: "assets/patterns/checkerboard.png",
  ),
  _Pattern(
    title: "Cube in a Cube",
    subtitle: "Small cube pattern inside the big cube",
    moves: "F L F U' R U F2 L2 U' L' B D' B' L2 U",
    assetPath: "assets/patterns/cube_in_cube.png",
  ),
  _Pattern(
    title: "Cube in a Cube in a Cube",
    subtitle: "Triple nested cube illusion",
    moves:
    "U B2 R F R' B R F' R' U' L' B2 R' F R F' U B2 L U'",
    assetPath: "assets/patterns/cube_in_cube_in_cube.png",
  ),
  _Pattern(
    title: "Six Dots",
    subtitle: "Centers only, rest swapped",
    moves: "F2 B2 U2 D2 R2 L2",
    assetPath: "assets/patterns/six_dots.png",
  ),
  _Pattern(
    title: "Opposite Cross",
    subtitle: "Cross on two opposite faces",
    moves: "F2 B2 U D' R2 L2",
    assetPath: "assets/patterns/opposite_cross.png",
  ),
  _Pattern(
    title: "Adjacent Cross",
    subtitle: "Cross on two adjacent faces",
    moves: "F2 U2 R2 D L2",
    assetPath: "assets/patterns/adjacent_cross.png",
  ),
];

class _PatternCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String moves;
  final String assetPath;
  final VoidCallback onTap;

  const _PatternCard({
    required this.title,
    required this.subtitle,
    required this.moves,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Image.asset(
                assetPath,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90,
                  height: 90,
                  color: Colors.black26,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.white38),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: kSoftTextColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Moves: $moves",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
