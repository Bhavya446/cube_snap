import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/constants.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late String _scramble;
  bool _running = false;
  late Stopwatch _stopwatch;
  Timer? _timer;
  String _display = "00.00";

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _scramble = _generateScramble();
  }

  void _haptic() => HapticFeedback.lightImpact();

  String _generateScramble({int length = 20}) {
    final rand = Random();
    const faces = ["R", "L", "U", "D", "F", "B"];
    const suffixes = ["", "'", "2"];

    String last = "";
    final moves = <String>[];

    while (moves.length < length) {
      final face = faces[rand.nextInt(faces.length)];
      if (face == last) continue;
      last = face;
      final suf = suffixes[rand.nextInt(suffixes.length)];
      moves.add("$face$suf");
    }
    return moves.join(" ");
  }

  void _startStop() {
    _haptic();
    if (_running) {
      _running = false;
      _stopwatch.stop();
      _timer?.cancel();
      setState(() {
        _display =
            (_stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(2);
      });
      _saveTime();
    } else {
      _running = true;
      _stopwatch
        ..reset()
        ..start();
      _timer = Timer.periodic(const Duration(milliseconds: 30), (_) {
        setState(() {
          _display =
              (_stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(2);
        });
      });
    }
  }

  Future<void> _saveTime() async {
    final db = FirebaseFirestore.instance;
    await db.collection("timer_sessions").add({
      "scramble": _scramble,
      "timeSeconds": _stopwatch.elapsedMilliseconds / 1000.0,
      "timestamp": DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Time saved to history.")),
    );

    setState(() {
      _scramble = _generateScramble();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _startStop,
        child: Container(
          decoration: const BoxDecoration(gradient: kMainBackgroundGradient),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: Row(
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
                        "Cube Timer",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Scramble:",
                  style: TextStyle(
                    color: kSoftTextColor,
                    fontSize: 13,
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    _scramble,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Center(
                    child: Text(
                      _display,
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 68,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 24, left: 16, right: 16),
                  child: Column(
                    children: const [
                      Text(
                        "Tap anywhere to start/stop.\n"
                            "Every finished solve is stored in Firebase (timer_sessions).",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kSoftTextColor,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
