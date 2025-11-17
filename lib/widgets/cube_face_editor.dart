import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CubeFaceEditor extends StatelessWidget {
  final List<int> faceValues; // exactly 9 ints [0..5]
  final void Function(int index) onTileTap;

  const CubeFaceEditor({
    super.key,
    required this.faceValues,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final colorIndex = faceValues[index];
            final color = kColorPalette[colorIndex];

            return GestureDetector(
              onTap: () => onTileTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: color, // 🟦 flat color, no gradient
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF0F1823),
                    width: 2,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
