import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../utils/constants.dart';
import 'manual_input_screen.dart';
import 'patterns_screen.dart';
import 'history_screen.dart';
import 'timer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _haptic() {
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: kMainBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Title
              Text(
                "CubeSnap",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Solve, practice & explore Rubik's Cube",
                style: TextStyle(color: kSoftTextColor, fontSize: 13),
              ),
              const SizedBox(height: 10),

              // Animated cube
              Lottie.asset(
                'assets/animated_cube.json',
                height: 200,
                repeat: true,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 8),

              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    children: [
                      _HomeCard(
                        title: "Manual Input",
                        subtitle: "Enter cube & get solution",
                        icon: Icons.grid_on,
                        color: kPrimaryColor,
                        onTap: () {
                          _haptic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ManualInputScreen(),
                            ),
                          );
                        },
                      ),
                      _HomeCard(
                        title: "Patterns",
                        subtitle: "Cool visual patterns",
                        icon: Icons.auto_awesome_mosaic,
                        color: const Color(0xFF7C4DFF),
                        onTap: () {
                          _haptic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PatternsScreen(),
                            ),
                          );
                        },
                      ),
                      _HomeCard(
                        title: "Solve History",
                        subtitle: "All past solutions",
                        icon: Icons.history,
                        color: const Color(0xFFFFB74D),
                        onTap: () {
                          _haptic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HistoryScreen(),
                            ),
                          );
                        },
                      ),
                      _HomeCard(
                        title: "Cube Timer",
                        subtitle: "Speedcubing mode",
                        icon: Icons.timer,
                        color: const Color(0xFF26C6DA),
                        onTap: () {
                          _haptic();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TimerScreen(),
                            ),
                          );
                        },
                      ),
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

class _HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [kCardColor, kCardColor.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: kSoftTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
