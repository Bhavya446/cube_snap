import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  final List<List<int>> cubeFaces =
  List.generate(6, (_) => List.filled(9, 0));

  final _rand = Random();

  @override
  void initState() {
    super.initState();
    _resetCubeToDefault();
  }

  void _haptic() {
    HapticFeedback.lightImpact();
  }

  void _resetCubeToDefault() {
    for (int f = 0; f < 6; f++) {
      final colorIndex = kDefaultCenterColorIndices[f];
      for (int i = 0; i < 9; i++) {
        cubeFaces[f][i] = colorIndex;
      }
    }
    setState(() {});
  }

  void _resetCurrentFace() {
    final colorIndex = cubeFaces[currentFace][4];
    for (int i = 0; i < 9; i++) {
      cubeFaces[currentFace][i] = colorIndex;
    }
    setState(() {});
  }

  /// Demo only: guarantees *exactly 9* of each color, but in random positions.
  Future<void> _setRandomDemoColors() async {
    final pool = <int>[];
    for (int color = 0; color < 6; color++) {
      for (int i = 0; i < 9; i++) {
        pool.add(color);
      }
    }
    pool.shuffle(_rand);

    int index = 0;
    for (int f = 0; f < 6; f++) {
      for (int i = 0; i < 9; i++) {
        cubeFaces[f][i] = pool[index++];
      }
    }
    setState(() {});
  }

  Future<void> _loadLastCube() async {
    _haptic();
    final loaded = await LastCubeStorage.loadCube();
    if (loaded == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No saved cube found.")),
      );
      return;
    }
    setState(() {
      for (int f = 0; f < 6; f++) {
        cubeFaces[f] = List<int>.from(loaded[f]);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Last cube restored!")),
    );
  }

  Future<void> _onSolvePressed() async {
    _haptic();

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

    // Save last cube locally
    await LastCubeStorage.saveCube(cubeFaces);

    // Beautiful loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: kPrimaryColor),
              SizedBox(height: 12),
              Text(
                "Contacting solver…",
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
    Navigator.pop(context); // close loader

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
    final faceName = kFaceNames[currentFace];
    final faceCode = kFaceCodes[currentFace];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kMainBackgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white70),
                      onPressed: () {
                        _haptic();
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 4),
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

                const SizedBox(height: 16),

                Text(
                  "$faceName ($faceCode)",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Face ${currentFace + 1} of 6",
                  style:
                  const TextStyle(color: kSoftTextColor, fontSize: 14),
                ),

                const SizedBox(height: 18),

                CubeFaceEditor(
                  faceValues: cubeFaces[currentFace],
                  onTileTap: (index) {
                    _haptic();
                    setState(() {
                      final currentValue = cubeFaces[currentFace][index];
                      cubeFaces[currentFace][index] =
                          (currentValue + 1) % kColorPalette.length;
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
                          : () {
                        _haptic();
                        setState(() => currentFace--);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white10,
                        disabledBackgroundColor: Colors.black26,
                        minimumSize: const Size(120, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Prev",
                          style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: currentFace == 5
                          ? null
                          : () {
                        _haptic();
                        setState(() => currentFace++);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        disabledBackgroundColor: Colors.black26,
                        minimumSize: const Size(120, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Next",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Reset / Load
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        _haptic();
                        _resetCurrentFace();
                      },
                      icon: const Icon(Icons.refresh, color: kSoftTextColor),
                      label: const Text("Reset Face",
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _haptic();
                        _resetCubeToDefault();
                      },
                      icon: const Icon(Icons.replay, color: kSoftTextColor),
                      label: const Text("Reset Cube",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),

                TextButton.icon(
                  onPressed: _loadLastCube,
                  icon: const Icon(Icons.history, color: Colors.white70),
                  label: const Text(
                    "Load Last Cube",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton.icon(
                  onPressed: () {
                    _haptic();
                    _setRandomDemoColors();
                  },
                  icon: const Icon(Icons.auto_awesome, color: kAccentColor),
                  label: const Text(
                    "Random Demo Colors (valid counts)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Tap tiles to cycle through colors:",
                  style: TextStyle(color: kSoftTextColor),
                ),
                const SizedBox(height: 8),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 18,
                  runSpacing: 8,
                  children: List.generate(kColorPalette.length, (i) {
                    return Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: kColorPalette[i],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          kColorCodes[i],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Text(
                    "Tip: Centers define which color is U, R, F, D, L, B.\n"
                        "Make sure each color appears exactly 9 times.\n"
                        "The solver uses Kociemba notation.",
                    style: TextStyle(
                      color: kSoftTextColor,
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

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
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
