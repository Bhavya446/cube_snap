import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SolutionScreen extends StatefulWidget {
  final String moves;
  final String cubeString;

  const SolutionScreen({
    super.key,
    required this.moves,
    required this.cubeString,
  });

  @override
  State<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen> {
  late final bool _isError;
  late final List<String> _steps;

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _isError = widget.moves.startsWith("Error");

    if (_isError) {
      _steps = widget.moves.split(" ");
    } else {
      _steps = widget.moves
          .split(RegExp(r'\s+'))
          .where((m) => m.trim().isNotEmpty)
          .toList();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goToStep(int index) {
    if (_isError) return;
    setState(() {
      _currentStepIndex = index.clamp(0, _steps.length - 1);
    });
  }

  void _nextStep() {
    if (_isError) return;
    if (_currentStepIndex < _steps.length - 1) {
      _goToStep(_currentStepIndex + 1);
    } else {
      _stopAutoPlay();
    }
  }

  void _prevStep() {
    if (_isError) return;
    if (_currentStepIndex > 0) {
      _goToStep(_currentStepIndex - 1);
    }
  }

  void _startAutoPlay() {
    if (_isError || _steps.isEmpty) return;
    _timer?.cancel();
    _isPlaying = true;
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (!mounted) return;
      if (_currentStepIndex >= _steps.length - 1) {
        _stopAutoPlay();
      } else {
        _nextStep();
      }
    });
    setState(() {});
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _isPlaying = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final totalSteps = _steps.length;
    final currentStepText =
    (_isError || totalSteps == 0) ? "0" : (_currentStepIndex + 1).toString();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kMainBackgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header ---
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Cube Solution",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                const Text(
                  "Solution Moves:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // --- Glass card for moves/error text ---
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  decoration: BoxDecoration(
                    color: kCardColor.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.06),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 10),
                        blurRadius: 18,
                      )
                    ],
                  ),
                  child: _isError
                      ? Text(
                    widget.moves,
                    style: const TextStyle(
                      color: kDangerColor,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  )
                      : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _steps
                        .map(
                          (m) => Chip(
                        backgroundColor: Colors.white10,
                        label: Text(
                          m,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),

                const SizedBox(height: 16),

                if (!_isError) ...[
                  Text(
                    "Step $currentStepText of $totalSteps",
                    style: const TextStyle(
                      color: kSoftTextColor,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // --- Player Controls ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                        onPressed: _prevStep,
                        icon: const Icon(Icons.skip_previous),
                        color: Colors.white,
                        tooltip: "Previous move",
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _isPlaying ? _stopAutoPlay : _startAutoPlay,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [kPrimaryColor, kAccentColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 16,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filledTonal(
                        onPressed: _nextStep,
                        icon: const Icon(Icons.skip_next),
                        color: Colors.white,
                        tooltip: "Next move",
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // --- Current move big display ---
                  if (totalSteps > 0)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        child: Text(
                          _steps[_currentStepIndex],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                ],

                // --- Explanation panel ---
                const Text(
                  "Explanation:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "• Each letter represents a face.\n"
                      "• A letter alone = clockwise turn.\n"
                      "• Letter + `'` (prime) = counter-clockwise turn.\n"
                      "• Letter + `2` = 180° (double) turn.\n",
                  style: TextStyle(
                    color: kSoftTextColor,
                    fontSize: 14.5,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 4),
                const Text(
                  "Faces:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "• U = Up (top)\n"
                      "• D = Down (bottom)\n"
                      "• L = Left\n"
                      "• R = Right\n"
                      "• F = Front (facing you)\n"
                      "• B = Back\n",
                  style: TextStyle(
                    color: kSoftTextColor,
                    fontSize: 14.5,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 12),
                const Text(
                  "Example:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "R U R' U' means:\n"
                      "• R  = turn Right face clockwise\n"
                      "• U  = turn Up face clockwise\n"
                      "• R' = turn Right face counter-clockwise\n"
                      "• U' = turn Up face counter-clockwise\n",
                  style: TextStyle(
                    color: kSoftTextColor,
                    fontSize: 14.5,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
