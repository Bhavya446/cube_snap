import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CubeFaceEditor extends StatelessWidget {
  final List<int> faceValues; // 9 ints
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kCardColor, Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemBuilder: (context, index) {
            final colorIndex = faceValues[index];
            final color = kColorPalette[colorIndex];

            return GestureDetector(
              onTap: () => onTileTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.45),
                    width: 1.4,
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
