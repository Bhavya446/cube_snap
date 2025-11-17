import 'package:flutter/material.dart';

/// ==== GLOBAL THEME COLORS ====

const kBackgroundColor = Color(0xFF050812);     // main background
const kCardColor       = Color(0xFF161B22);     // cards, panels
const kPrimaryColor    = Color(0xFF4C8CFF);     // primary accent blue
const kAccentColor     = Color(0xFF7AFDD6);     // mint highlight
const kDangerColor     = Color(0xFFFF6F91);     // error/warning
const kSoftTextColor   = Color(0xFF9BA4B5);     // secondary text

/// Soft vertical gradient (can reuse)
const LinearGradient kBackgroundGradient = LinearGradient(
  colors: [
    Color(0xFF050813),
    Color(0xFF0D1117),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

/// Global App Background Gradient
const LinearGradient kMainBackgroundGradient = LinearGradient(
  colors: [
    Color(0xFF090E1A), // deep midnight blue
    Color(0xFF131B2E), // dark indigo
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

/// ==== CUBE META ====
/// Order: U, R, F, D, L, B
const List<String> kFaceNames = [
  "Up",
  "Right",
  "Front",
  "Down",
  "Left",
  "Back",
];

/// Face codes used in legend / titles
const List<String> kFaceCodes = [
  "U",
  "R",
  "F",
  "D",
  "L",
  "B",
];

/// 6 sticker colors (nice contrast, dark-mode friendly)
const List<Color> kColorPalette = [
  Color(0xFFFFD76A), // U - warm yellow
  Color(0xFFFF6F6F), // R - coral red
  Color(0xFF29D699), // F - teal green
  Color(0xFF4DA8FF), // D - sky blue
  Color(0xFFFFA64D), // L - orange
  Color(0xFFB583FF), // B - lavender
];

/// Codes (for legend & validation messages)
const List<String> kColorCodes = [
  "U",
  "R",
  "F",
  "D",
  "L",
  "B",
];

/// Center indices for each face (0..5)
const List<int> kDefaultCenterColorIndices = [0, 1, 2, 3, 4, 5];
