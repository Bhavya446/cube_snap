import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/cube_face_editor.dart';
import '../logic/cube_converter.dart';
import '../utils/cube_solver_api.dart';
import '../logic/solve_history.dart';
import '../utils/last_cube_storage.dart';
import 'solution_screen.dart';

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({super.key});

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  int currentFace = 0;

  /// 6 × 9 stickers
  final List<List<int>> cubeFaces =
  List.generate(6, (_) => List.filled(9, 0));

  final random = Random();

  @override
  void initState() {
    super.initState();
    _resetCubeToDefault();
  }

  // ------------------------------------------------------------
  // RESET HELPERS
  // ------------------------------------------------------------

  void _resetCubeToDefault() {
    for (int f = 0; f < 6; f++) {
      final center = kDefaultCenterColorIndices[f];
      for (int i = 0; i < 9; i++) {
        cubeFaces[f][i] = center;
      }
    }
    setState(() {});
  }

  void _resetCurrentFace() {
    final centerColor = cubeFaces[currentFace][4];
    for (int i = 0; i < 9; i++) {
      cubeFaces[currentFace][i] = centerColor;
    }
    setState(() {});
  }

  /// PPT ONLY — does NOT produce a solvable cube
  Future<void> _setRandomDemoColors() async {
    for (int f = 0; f < 6; f++) {
      for (int i = 0; i < 9; i++) {
        cubeFaces[f][i] = random.nextInt(kColorPalette.length);
      }
    }
    setState(() {});
  }

  // ------------------------------------------------------------
  // SOLVE
  // ------------------------------------------------------------

  Future<void> _onSolvePressed() async {
    // VALIDATE
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

    // SAVE LAST INPUT
    await LastCubeStorage.saveCube(cubeFaces);

    final cubeString = CubeConverter.convert(cubeFaces);
    print("CUBE STRING SENT TO API: $cubeString");

    // NICE LOADING SCREEN
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/cube_loading.gif",
                  height: 80, fit: BoxFit.contain),
              const SizedBox(height: 12),
              const Text(
                "Contacting Solver…",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
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

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final faceName = kFaceNames[currentFace];
    final faceCode = kFaceCodes[currentFace];

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
                // HEADER
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Manual Cube Input",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Text(
                  "$faceName ($faceCode)",
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "Face ${currentFace + 1} of 6",
                  style: const TextStyle(color: kSoftTextColor),
                ),

                const SizedBox(height: 20),

                // GRID
                CubeFaceEditor(
                  faceValues: cubeFaces[currentFace],
                  onTileTap: (index) {
                    setState(() {
                      cubeFaces[currentFace][index] =
                          (cubeFaces[currentFace][index] + 1) %
                              kColorPalette.length;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // PREV / NEXT
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: currentFace == 0
                          ? null
                          : () => setState(() => currentFace--),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white10,
                        disabledBackgroundColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(120, 44),
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
                        disabledBackgroundColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(120, 44),
                      ),
                      child: const Text("Next",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // RESET ROW
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

                const SizedBox(height: 10),

                // SAVE + LOAD LAST CUBE
                TextButton.icon(
                  onPressed: () async {
                    final loaded = await LastCubeStorage.loadCube();
                    if (loaded != null) {
                      setState(() {
                        for (int f = 0; f < 6; f++) {
                          cubeFaces[f] = List.from(loaded[f]);
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Last cube restored!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No saved cube found.")),
                      );
                    }
                  },
                  icon: const Icon(Icons.history, color: Colors.white),
                  label: const Text("Load Last Cube",
                      style: TextStyle(color: Colors.white)),
                ),

                const SizedBox(height: 10),

                TextButton.icon(
                  onPressed: _setRandomDemoColors,
                  icon: const Icon(Icons.auto_awesome, color: kAccentColor),
                  label: const Text(
                    "Random Demo Colors (Not Solvable)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16),

                // GUIDE
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.05)),
                  ),
                  child: const Text(
                    "Rubik's Cube Color Rules:\n"
                        "• Each face must use a single center color.\n"
                        "• Each color must appear exactly 9 times.\n"
                        "• Valid set:\n"
                        "     U = White, R = Red, F = Green,\n"
                        "     D = Blue, L = Orange, B = Yellow\n"
                        "• If these rules break → solver returns 'invalid cube'.",
                    style: TextStyle(
                      color: kSoftTextColor,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // SOLVE BUTTON
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
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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
