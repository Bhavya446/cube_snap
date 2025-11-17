import 'package:flutter/material.dart';

class ColorTile extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const ColorTile({
    super.key,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black26, width: 1),
        ),
      ),
    );
  }
}
