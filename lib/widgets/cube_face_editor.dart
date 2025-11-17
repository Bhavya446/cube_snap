import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'color_tile.dart';

class CubeFaceEditor extends StatelessWidget {
  /// Each int is an index into kColorPalette.
  final List<int> faceValues;

  /// Called with index when a tile is tapped.
  final ValueChanged<int> onTileTap;

  const CubeFaceEditor({
    super.key,
    required this.faceValues,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 210,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          final color = kColorPalette[faceValues[index]];
          return ColorTile(
            color: color,
            onTap: () => onTileTap(index),
          );
        },
      ),
    );
  }
}
