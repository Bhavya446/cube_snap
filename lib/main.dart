import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CubeSolverApp());
}

class CubeSolverApp extends StatelessWidget {
  const CubeSolverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rubik's Cube Solver",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const HomeScreen(),
    );
  }
}
