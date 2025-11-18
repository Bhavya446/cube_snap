import 'package:flutter/material.dart';
import '../models/cube_pattern.dart';
import '../utils/constants.dart';
import 'package:flutter/services.dart';

class PatternDetailScreen extends StatelessWidget {
  final CubePattern pattern;

  const PatternDetailScreen({super.key, required this.pattern});

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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Pattern Details",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // IMAGE
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  pattern.image,
                  height: 200,
                ),
              ),

              Text(
                pattern.name,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                "Category: ${pattern.category}",
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 20),

              // Algorithm Card
              Container(
                padding: const EdgeInsets.all(16),
                margin:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Algorithm",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      pattern.algorithm,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: pattern.algorithm),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Algorithm copied!"),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text("Copy Algorithm"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
