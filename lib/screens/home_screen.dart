import 'dart:ui';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'manual_input_screen.dart';
import 'history_screen.dart';
import 'patterns_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _glassButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
            color: Colors.white.withOpacity(0.06),
          ),
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: kMainBackgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(
                  "Rubik's Cube Solver",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // Cube image
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const RadialGradient(
                              colors: [
                                Color(0xFF30344A),
                                Colors.transparent,
                              ],
                              radius: 0.8,
                            ),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Image.asset(
                            'assets/app_icon.png',
                            width: 140,
                            height: 140,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Welcome!",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Solve a 3×3 Rubik's Cube with a\nsmart algorithm, or explore patterns.",
                          textAlign: TextAlign.center,
                          style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Buttons
                _glassButton(
                  context: context,
                  label: "Manual Cube Input & Solve",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ManualInputScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                _glassButton(
                  context: context,
                  label: "View Cube Patterns",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PatternsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                _glassButton(
                  context: context,
                  label: "View Solve History",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HistoryScreen(),
                      ),
                    );
                  },
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
