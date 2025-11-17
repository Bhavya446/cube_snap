import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/cube_face_editor.dart';
import '../logic/cube_converter.dart';
import '../logic/kociemba_solver.dart';
import '../logic/solve_history.dart';   // <-- ADDED
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

  @override
  void initState() {
    super.initState();
    _resetCubeToDefault();
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

  Future<void> _onSolvePressed() async {
    final validationError = CubeConverter.validate(cubeFaces);
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }

    final cubeString = CubeConverter.convert(cubeFaces);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    String solution;
    try {
      solution = await KociembaSolver.solve(cubeString);

      // 🌟 SAVE SOLVE HISTORY HERE
      await SolveHistoryService.saveSolve(
        cubeString: cubeString,
        solution: solution,
      );

    } catch (e) {
      solution = "Error while solving cube: $e";
    }

    if (mounted) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SolutionScreen(moves: solution),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final faceLabel = kFaceNames[currentFace];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manual Cube Input"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                faceLabel,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text("Face ${currentFace + 1} of 6"),
              const SizedBox(height: 16),

              CubeFaceEditor(
                faceValues: cubeFaces[currentFace],
                onTileTap: (index) {
                  setState(() {
                    final currentValue = cubeFaces[currentFace][index];
                    cubeFaces[currentFace][index] =
                        (currentValue + 1) % kColorPalette.length;
                  });
                },
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed:
                    currentFace == 0 ? null : () => setState(() => currentFace--),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Prev"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed:
                    currentFace == 5 ? null : () => setState(() => currentFace++),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Next"),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: _resetCurrentFace,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset Face"),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _resetCubeToDefault,
                    icon: const Icon(Icons.replay),
                    label: const Text("Reset Cube"),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text("Tap tiles to cycle through colors:"),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: List.generate(kColorPalette.length, (i) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: kColorPalette[i],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(kColorCodes[i]),
                    ],
                  );
                }),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSolvePressed,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(
                      "Solve Cube",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
