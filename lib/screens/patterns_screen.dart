import 'package:flutter/material.dart';
import '../models/cube_pattern.dart';
import '../utils/constants.dart';
import 'pattern_detail_screen.dart';

class PatternsScreen extends StatelessWidget {
  PatternsScreen({super.key});

  final List<CubePattern> patterns = [
    CubePattern(
      name: "Checkerboard",
      image: "assets/patterns/checkerboard.png",
      algorithm: "M2 E2 S2",
      category: "Checkers",
    ),
    CubePattern(
      name: "Cube in a Cube",
      image: "assets/patterns/cube_in_cube.png",
      algorithm: "F L F U' R U F2 L2 U' L' B D' B'",
      category: "Cube-in-Cube",
    ),
    CubePattern(
      name: "Cube in Cube in Cube",
      image: "assets/patterns/cube_in_cube_in_cube.png",
      algorithm: "U L F' R U' L F R' F U R' U'",
      category: "Cube-in-Cube",
    ),
    CubePattern(
      name: "Six Dots",
      image: "assets/patterns/six_dots.png",
      algorithm: "M E S",
      category: "Dots",
    ),
    CubePattern(
      name: "Opposite Cross",
      image: "assets/patterns/opposite_cross.png",
      algorithm: "F2 B2 U D' R2 L2",
      category: "Cross",
    ),
    CubePattern(
      name: "Adjacent Cross",
      image: "assets/patterns/adjacent_cross.png",
      algorithm: "R2 L2 U2 D2 B2 F2 R2 L2",
      category: "Cross",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: kMainBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Cube Patterns",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: patterns.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final p = patterns[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PatternDetailScreen(pattern: p),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(p.image),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                p.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
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
