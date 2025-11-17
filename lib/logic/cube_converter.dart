import '../utils/constants.dart';

/// Handles converting the 6 faces (each 3×3, stored as color indices)
/// into a 54-character Kociemba-style string.
class CubeConverter {
  /// Validate basic cube rules:
  /// - exactly 9 stickers of each color
  /// - all 6 centers are different colors
  /// Returns null if OK, or an error message string.
  static String? validate(List<List<int>> faces) {
    if (faces.length != 6 ||
        faces.any((f) => f.length != 9)) {
      return "Internal error: faces not in 6 × 9 format.";
    }

    final counts = List<int>.filled(kColorPalette.length, 0);
    for (final face in faces) {
      for (final c in face) {
        if (c < 0 || c >= kColorPalette.length) {
          return "Invalid color index found.";
        }
        counts[c]++;
      }
    }

    for (int i = 0; i < kColorPalette.length; i++) {
      if (counts[i] != 9) {
        return "Each color (${kColorCodes[i]}) must appear exactly 9 times.\n"
            "Currently appears ${counts[i]}.";
      }
    }

    // Centers: one per face at index 4
    final centerSet = <int>{};
    for (int f = 0; f < 6; f++) {
      centerSet.add(faces[f][4]);
    }
    if (centerSet.length != 6) {
      return "All 6 face centers must be different colors.\n"
          "Please adjust the center tiles.";
    }

    // NOTE: We are not checking permutation parity or corner orientation here.
    return null;
  }

  /// Convert to Kociemba-style string.
  /// Faces must be in order: [U, R, F, D, L, B].
  static String convert(List<List<int>> faces) {
    // Determine the center color of each face.
    final centers = List<int>.generate(6, (f) => faces[f][4]);

    // Map color index -> face letter (U/R/F/D/L/B).
    final Map<int, String> colorToFaceLetter = {};
    for (int f = 0; f < 6; f++) {
      colorToFaceLetter[centers[f]] = kFaceLetters[f];
    }

    final buffer = StringBuffer();

    // Order: U, R, F, D, L, B  (faces[0]..faces[5])
    for (int f = 0; f < 6; f++) {
      for (int i = 0; i < 9; i++) {
        final colorIdx = faces[f][i];
        final letter = colorToFaceLetter[colorIdx];
        if (letter == null) {
          // Shouldn't happen if validation passed.
          throw Exception(
              "Color index $colorIdx not mapped to a face letter.");
        }
        buffer.write(letter);
      }
    }

    return buffer.toString();
  }
}
