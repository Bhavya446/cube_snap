import '../utils/constants.dart';

class CubeConverter {
  /// Validate cube color counts: each center color appears exactly 9 times.
  static String? validate(List<List<int>> faces) {
    if (faces.length != 6 || faces.any((f) => f.length != 9)) {
      return "Cube must have 6 faces, 9 stickers each.";
    }

    final counts = List<int>.filled(kColorPalette.length, 0);

    for (final face in faces) {
      for (final colorIndex in face) {
        if (colorIndex < 0 || colorIndex >= kColorPalette.length) {
          return "Invalid color index found.";
        }
        counts[colorIndex]++;
      }
    }

    for (int i = 0; i < kColorPalette.length; i++) {
      if (counts[i] != 9) {
        return "Each color must appear exactly 9 times.\n"
            "Color ${kColorCodes[i]} appears ${counts[i]} times.";
      }
    }

    return null; // OK
  }

  /// Convert faces into a 54-char string in URFDLB order.
  ///
  /// We map colors by their *center*:
  /// center color 0 -> 'U', 1 -> 'R', 2 -> 'F', 3 -> 'D', 4 -> 'L', 5 -> 'B'
  static String convert(List<List<int>> faces) {
    const faceLetters = ['U', 'R', 'F', 'D', 'L', 'B'];

    // Map colorIndex -> letter based on which face center uses that color.
    final colorToLetter = <int, String>{};
    for (int face = 0; face < 6; face++) {
      final centerColor = kDefaultCenterColorIndices[face];
      colorToLetter[centerColor] = faceLetters[face];
    }

    final buffer = StringBuffer();

    for (int face = 0; face < 6; face++) {
      for (int i = 0; i < 9; i++) {
        final colorIndex = faces[face][i];
        final letter = colorToLetter[colorIndex] ?? '?';
        buffer.write(letter);
      }
    }

    return buffer.toString();
  }
}
