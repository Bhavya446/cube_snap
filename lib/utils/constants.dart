import 'package:flutter/material.dart';

/// Palette order is important. We use these indices everywhere.
const List<Color> kColorPalette = [
  Colors.white,  // 0 -> W
  Colors.yellow, // 1 -> Y
  Colors.red,    // 2 -> R
  Colors.orange, // 3 -> O
  Colors.blue,   // 4 -> B
  Colors.green,  // 5 -> G
];

const List<String> kColorCodes = ["W", "Y", "R", "O", "B", "G"];

/// Face letters in Kociemba order: U, R, F, D, L, B
const List<String> kFaceLetters = ["U", "R", "F", "D", "L", "B"];

/// Nice names to show in UI in the same order.
const List<String> kFaceNames = [
  "Up (U)",
  "Right (R)",
  "Front (F)",
  "Down (D)",
  "Left (L)",
  "Back (B)",
];

/// Default center colors (indices in kColorPalette) for faces U,R,F,D,L,B
/// U = White, R = Red, F = Green, D = Yellow, L = Orange, B = Blue
const List<int> kDefaultCenterColorIndices = [0, 2, 5, 1, 3, 4];
