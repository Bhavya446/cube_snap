                                   CubeSnap – Intelligent Rubik’s Cube Solver (Flutter + Python + Firebase)
                      A modern, beautiful, AI-powered cube solver with animations, patterns, and real-time backend solving.

Overview

CubeSnap is a full cross-platform Rubik’s Cube solver built using:

Flutter → Frontend UI
Python (Flask) → Kociemba solver backend
Firebase Firestore → Save solve history
Lottie animations → For UI polish
SharedPreferences → Save last cube input
Dark Neon UI → Custom-designed interface
Kociemba 2-phase algorithm → Industry-standard solver

The app allows users to manually input their cube, validate it, send it to the backend, and get a real-time optimal solution.

🧩 Key Features
1️⃣ Manual Cube Input

Tap tiles to change colors
Cycle through your 6 cube colors
Navigation between 6 faces
Reset a face or the entire cube
Load last-saved cube state
Random demo (invalid) cube generator for demos

2️⃣ Real-time Solving (Python API)

Uses Kociemba solver for optimal sequences
Communicates with your backend:
https://cube-solver-backend.onrender.com/solve
Shows a loading animation while solving
Displays full solution sequence

3️⃣ Solve History (Firebase)

Every solve stores:
Cube scramble (Kociemba format)
Solution (move sequence)
Timestamp

4️⃣ Beautiful Animated UI

Neon cyan gradient background
Lottie 3D cube animation on home screen
Smooth navigation transitions
Glass cards + modern fonts
Haptic feedback on all buttons

5️⃣ Rubik's Cube Pattern Library

Includes patterns such as:
Checkerboard
Cube-in-cube
Six dots
Opposite cross
Adjacent cross
And more (extendable)

Each pattern page includes:
Image preview

Description
One-click "Copy Moves" button

6️⃣ Cube Timer (Speedcubing)

Start/stop timer
Saves solves
Displays average, best, worst
Smooth digits + neon glowing UI

7️⃣ Last Cube Memory

Your last manual input is saved automatically.
You can restore it instantly with: Load Last Cube.

8️⃣ Smart Validation System

CubeSnap checks:
Each color must appear exactly 9 times
Opposite centers must match real cube rules
Edge orientation & corner structure logic
Prevents invalid scrambles

9️⃣ 3D Animated Loading Screen

When solving, a rotating 3D Rubik’s Cube GIF appears, matching theme.

🧠 How It Works Internally
⭐ 1. User Inputs Colors

User taps the 3×3 grid for each face.

⭐ 2. App Converts Colors → Kociemba Format

Based on center colors:

U = Yellow  
R = Red  
F = Green  
D = Blue  
L = Orange  
B = Purple

⭐ 3. String Sent to Backend

Example:

"UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB"

⭐ 4. Python Backend (Flask)

Backend receives the cube string → sends to Kociemba → returns solution:

{"solution": "R U R' U' F2 ..."}

⭐ 5. App Shows Moves + Saves to Firebase
📱 How to Use CubeSnap
1️⃣ Open the App

A beautiful neon-cyan cube animation appears.

2️⃣ Go to Manual Input

Tap tiles to match your physical cube.

3️⃣ Press Solve Cube

A 3D cube loading animation appears.

4️⃣ View Solution

See step-by-step moves.
You can copy or save them automatically.

5️⃣ Open History

View all past solves synced with Firebase.

6️⃣ Explore Patterns

Tap any pattern to view the algorithm.

7️⃣ Use the Cube Timer

Practice speedcubing and track results.

🔧 Tech Stack Summary

Frontend
Flutter
Dart
Google Fonts
Lottie
SharedPreferences
Backend
Python
Flask
Kociemba (Rubik’s algorithm)
Gunicorn
Render.com hosting
Database

Firebase Firestore

SDK v2

🛠 Folder Structure
lib/
 ├─ screens/
 │   ├─ home_screen.dart
 │   ├─ manual_input_screen.dart
 │   ├─ solution_screen.dart
 │   ├─ history_screen.dart
 │   ├─ patterns_screen.dart
 │   └─ timer_screen.dart
 │
 ├─ widgets/
 │   └─ cube_face_editor.dart
 │
 ├─ utils/
 │   ├─ constants.dart
 │   ├─ cube_solver_api.dart
 │   ├─ last_cube_storage.dart
 │   └─ etc.
 │
 ├─ logic/
 │   ├─ cube_converter.dart
 │   └─ solve_history.dart
 │
assets/
 ├─ animated_cube.json
 ├─ 3d_cube.gif
 └─ patterns/

💡 Why Kociemba Algorithm?

The Kociemba 2-phase algorithm is used in:

Google’s solver
Cube Explorer
Most professional-speed solvers

It:
Generates near-optimal solutions
Works in under 50ms on backend
Is extremely stable and predictable

That's why it's perfect for CubeSnap.

   Testing Guide
✔ Test Valid Cube
Fill all 6 faces correctly → should solve instantly.

✔ Test Invalid Cube
API returns error → app shows message.

✔ Test History Saving
Check Firebase → new entry appears.

✔ Test Last Cube Restore
Restart app → Load Last Cube should work.

🏁 Final Summary

CubeSnap is a complete Rubik’s Cube solving ecosystem, featuring:

Beautiful UI
Real backend solver
Pattern library
Speedcube timer
Save & restore
Firebase integration
Neon cyan theme
Haptic feedback
True Kociemba solving power
