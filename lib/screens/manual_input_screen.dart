import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/cube_face_editor.dart';
import '../logic/cube_converter.dart';
import '../utils/cube_solver_api.dart';
import '../logic/solve_history.dart';
import 'solution_screen.dart';

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({super.key});

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen>
    with SingleTickerProviderStateMixin {
  int currentFace = 0;

  /// 6 faces × 9 stickers
  final List<List<int>> cubeFaces =
  List.generate(6, (_) => List.filled(9, 0));

  /// Animation controller for rotating cube loader
  late AnimationController _cubeSpin;

  @override
  void initState() {
    super.initState();
    _resetCubeToDefault();

    // rotating cube animation
    _cubeSpin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _cubeSpin.dispose();
    super.dispose();
  }

  // RESET CUBE
  void _resetCubeToDefault() {
    for (int f = 0; f < 6; f++) {
      int index = kDefaultCenterColorIndices[f];
      for (int i = 0; i < 9; i++) {
        cubeFaces[f][i] = index;
      }
    }
    setState(() {});
  }

  // RESET ONE FACE
  void _resetCurrentFace() {
    int index = cubeFaces[currentFace][4];
    for (int i = 0; i < 9; i++) {
      cubeFaces[currentFace][i] = index;
    }
    setState(() {});
  }

  /// Random demo colors – for PPT only
  Future<void> _setRandomDemoColors() async {
    for (int f = 0; f < 6; f++) {
      for (int i = 0; i < 9; i++) {
        cubeFaces[f][i] = (i * f + 3) % kColorPalette.length;
      }
    }
    setState(() {});
  }

  // SOLVE BUTTON
  Future<void> _onSolvePressed() async {
    final validationError = CubeConverter.validate(cubeFaces);
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: kDangerColor,
        ),
      );
      return;
    }

    final cubeString = CubeConverter.convert(cubeFaces);
    print("CUBE STRING SENT TO API: $cubeString");

    // 🔥 3D Cube Loader Dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Center(
        child: AnimatedBuilder(
          animation: _cubeSpin,
          builder: (_, child) {
            return Transform.rotate(
              angle: _cubeSpin.value * 6.28,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: kPrimaryColor.withOpacity(0.4), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Image.asset("assets/rotating_cube.gif"), // you add
              ),
            );
          },
        ),
      ),
    );

    String solution;

    try {
      solution = await CubeSolverAPI.solveCube(cubeString);

      await SolveHistory.saveSolve(
        scramble: cubeString,
        solution: solution,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      solution = "Error contacting solver: $e";
    }

    if (!mounted) return;

    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SolutionScreen(
          moves: solution,
          cubeString: cubeString,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String faceName = kFaceNames[currentFace];
    String faceCode = kFaceCodes[currentFace];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: kMainBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Manual Cube Input",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  "$faceName ($faceCode)",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Face ${currentFace + 1} of 6",
                  style: const TextStyle(
                    color: kSoftTextColor,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 20),

                // Cube Grid
                CubeFaceEditor(
                  faceValues: cubeFaces[currentFace],
                  onTileTap: (i) {
                    setState(() {
                      cubeFaces[currentFace][i] =
                          (cubeFaces[currentFace][i] + 1) %
                              kColorPalette.length;
                    });
                  },
                ),

                const SizedBox(height: 22),

                // Prev / Next
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: currentFace == 0
                          ? null
                          : () => setState(() => currentFace--),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white10,
                        minimumSize: const Size(120, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Prev",
                          style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: currentFace == 5
                          ? null
                          : () => setState(() => currentFace++),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        minimumSize: const Size(120, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Next",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Reset buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: _resetCurrentFace,
                      icon: const Icon(Icons.refresh, color: kSoftTextColor),
                      label: const Text("Reset Face",
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton.icon(
                      onPressed: _resetCubeToDefault,
                      icon: const Icon(Icons.replay, color: kSoftTextColor),
                      label: const Text("Reset Cube",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                TextButton.icon(
                  onPressed: _setRandomDemoColors,
                  icon: const Icon(Icons.auto_awesome, color: kAccentColor),
                  label: const Text(
                    "Random Demo Colors",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16),

                // legend
                const Text(
                  "Tap tiles to cycle colors",
                  style: TextStyle(color: kSoftTextColor, fontSize: 13),
                ),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: List.generate(kColorPalette.length, (i) {
                    return Column(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: kColorPalette[i],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          kColorCodes[i],
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    );
                  }),
                ),

                const SizedBox(height: 24),

                // Help box
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    "Make sure each color appears exactly 9 times.\n"
                        "Kociemba will reject invalid cubes.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kSoftTextColor, fontSize: 13),
                  ),
                ),

                const SizedBox(height: 24),

                // Solve button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSolvePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      "Solve Cube",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
