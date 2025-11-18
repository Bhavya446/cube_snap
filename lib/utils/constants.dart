import 'package:flutter/material.dart';

/// ========= THEME =========

const kBackgroundDark = Color(0xFF020817);
const kBackgroundDark2 = Color(0xFF071423);

/// Neon cyan primary instead of purple
const kPrimaryColor = Color(0xFF00E5FF); // neon cyan
const kAccentColor = Color(0xFFFFB74D);  // warm accent
const kDangerColor = Color(0xFFFF6F91);  // error / warning
const kCardColor = Color(0xFF111827);    // glassy panels
const kSoftTextColor = Color(0xFF9BA4B5);

/// Global gradient (G2 style)
const LinearGradient kMainBackgroundGradient = LinearGradient(
  colors: [
    Color(0xFF020817),
    Color(0xFF071423),
    Color(0xFF041725),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// ========= CUBE META =========
/// Faces in Kociemba order
const List<String> kFaceNames = [
  "Up",
  "Right",
  "Front",
  "Down",
  "Left",
  "Back",
];

const List<String> kFaceCodes = [
  "U",
  "R",
  "F",
  "D",
  "L",
  "B",
];

/// Neon cube colors (C2)
const List<Color> kColorPalette = [
  Color(0xFFFFF176), // U - neon yellow
  Color(0xFFFF5252), // R - neon red
  Color(0xFF00E676), // F - neon green
  Color(0xFF40C4FF), // D - neon cyan/blue
  Color(0xFFFFB74D), // L - neon orange
  Color(0xFFB388FF), // B - neon purple
];

/// Legend codes (for instruction row)
const List<String> kColorCodes = [
  "U", // yellow-ish
  "R",
  "F",
  "D",
  "L",
  "B",
];

/// Each face's default center color index
const List<int> kDefaultCenterColorIndices = [0, 1, 2, 3, 4, 5];
