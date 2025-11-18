import '../utils/constants.dart';

class CubeConverter {
  /// Check each color index appears exactly 9 times.
  static String? validate(List<List<int>> faces) {
    final counts = List<int>.filled(kColorPalette.length, 0);

    for (final face in faces) {
      if (face.length != 9) {
        return "Each face must have exactly 9 stickers.";
      }
      for (final idx in face) {
        if (idx < 0 || idx >= kColorPalette.length) {
          return "Invalid color index $idx detected.";
        }
        counts[idx]++;
      }
    }

    for (int i = 0; i < counts.length; i++) {
      if (counts[i] != 9) {
        return "Each color must appear exactly 9 times.\n"
            "Color ${kColorCodes[i]} appears ${counts[i]} times.";
      }
    }

    return null; // ok
  }

  /// Convert 6×9 color indices into a Kociemba cube string (URFDLB).
  static String convert(List<List<int>> faces) {
    // Build colorIndex -> faceChar mapping based on centers
    final colorToChar = <int, String>{};
    for (int face = 0; face < 6; face++) {
      final centerColorIndex = faces[face][4];
      colorToChar[centerColorIndex] = kFaceCodes[face];
    }

    final buffer = StringBuffer();

    // Faces in Kociemba order: U, R, F, D, L, B (0..5 already)
    for (int face = 0; face < 6; face++) {
      for (int i = 0; i < 9; i++) {
        final colorIndex = faces[face][i];
        final ch = colorToChar[colorIndex] ?? "?";
        buffer.write(ch);
      }
    }

    return buffer.toString();
  }
}
