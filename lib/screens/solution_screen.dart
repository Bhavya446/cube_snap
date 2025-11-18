import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late final List<String> _tokens;
  int _currentIndex = 0;
  bool _autoPlay = false;

  @override
  void initState() {
    super.initState();
    _tokens = _parseMoves(widget.moves);
  }

  void _haptic() => HapticFeedback.lightImpact();

  List<String> _parseMoves(String raw) {
    // If it's an error from backend, just split by space
    if (raw.toLowerCase().contains("error")) {
      return raw.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    }

    final parts =
    raw.replaceAll('\n', ' ').trim().split(RegExp(r'\s+')).toList();
    return parts.isEmpty ? ["(no moves)"] : parts;
  }

  bool get _isError => widget.moves.toLowerCase().contains("error");

  void _next() {
    if (_currentIndex < _tokens.length - 1) {
      setState(() => _currentIndex++);
      _haptic();
    }
  }

  void _prev() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _haptic();
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepText =
        "${_tokens.isEmpty ? 0 : _currentIndex + 1} of ${_tokens.length}";

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: kMainBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar style
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
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
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Solution Moves:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Glass card with chips
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: kCardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 18,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _tokens
                              .map(
                                (m) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: _tokens.indexOf(m) == _currentIndex
                                    ? kPrimaryColor.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.04),
                                border: Border.all(
                                  color: _tokens.indexOf(m) ==
                                      _currentIndex
                                      ? kPrimaryColor
                                      : Colors.white12,
                                ),
                              ),
                              child: Text(
                                m,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                              .toList(),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Step control
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Step $_currentIndex of ${_tokens.length}",
                            style: const TextStyle(
                                color: kSoftTextColor, fontSize: 13),
                          ),
                          Text(
                            stepText,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous,
                                color: Colors.white),
                            onPressed: _prev,
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              _haptic();
                              setState(() => _autoPlay = !_autoPlay);
                              // autoplay animation logic can be added later
                            },
                            child: AnimatedContainer(
                              duration:
                              const Duration(milliseconds: 160),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 12),
                              decoration: BoxDecoration(
                                color:
                                _autoPlay ? kPrimaryColor : kCardColor,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Text(
                                _autoPlay ? "Pause (demo)" : "Play (demo)",
                                style: TextStyle(
                                  color: _autoPlay
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(Icons.skip_next,
                                color: Colors.white),
                            onPressed: _next,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Explanation
                      const Text(
                        "Explanation:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "• Each letter represents a face.\n"
                            "• A letter alone = clockwise 90° turn.\n"
                            "• Letter + `'` = counter-clockwise 90° turn.\n"
                            "• Letter + `2` = 180° rotation.\n\n"
                            "Faces:\n"
                            "• U = Up (top)\n"
                            "• D = Down (bottom)\n"
                            "• L = Left\n"
                            "• R = Right\n"
                            "• F = Front\n"
                            "• B = Back",
                        style: TextStyle(
                          color: kSoftTextColor,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Cube string debug
                      const Text(
                        "Internal cube string (URFDLB):",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Text(
                          widget.cubeString,
                          style: const TextStyle(
                            color: kSoftTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      if (_isError) ...[
                        const SizedBox(height: 18),
                        const Text(
                          "Why did this fail?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "The solver said the cubestring is invalid. "
                              "Check that:\n"
                              "• Each face has exactly 9 stickers.\n"
                              "• Each color is used exactly 9 times.\n"
                              "• Centers match the real cube's center colors.",
                          style: TextStyle(
                            color: kSoftTextColor,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],

                      const SizedBox(height: 28),
                    ],
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
