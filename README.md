CubeSnap – Intelligent Rubik’s Cube Solver
(Flutter + Python + Firebase)

A modern, beautiful, AI-powered Rubik’s Cube solver with animations, patterns, and real-time backend solving powered by the Kociemba algorithm.

📌 Overview

CubeSnap is a cross-platform Rubik’s Cube solving application built using:

Flutter — Frontend UI

Python (Flask) — Backend solver (Kociemba algorithm)

Firebase Firestore — Solve history storage

SharedPreferences — Save last cube input

Lottie Animations — Interactive UI

Dark Neon UI — Modern, aesthetic design

The user manually inputs cube colors, the app validates the cube, sends the configuration to a Python API, and receives the optimal solution.

🧩 Key Features
1️⃣ Manual Cube Input

Tap tiles to change sticker colors

Cycle through your 6 cube colors

Navigate across 6 faces

Reset individual face or entire cube

Restore last saved cube

“Random Demo” generator for presentation use

2️⃣ Real-Time Solving (Python API)

Backend uses Kociemba 2-phase algorithm

POST request to your API endpoint:

https://cube-solver-backend.onrender.com/solve


Returns optimal solution (20-ish moves)

Beautiful 3D cube loading animation

Move sequence displayed cleanly

3️⃣ Solve History (Firebase Firestore)

Each solve includes:

Cube scramble (Kociemba string)

Full solution sequence

Timestamp

Automatically stored and displayed in the History screen.

4️⃣ Stunning Animated UI

Neon cyan gradient

Animated 3D cube (Lottie) on home screen

Smooth transitions

Glass-like cards

Google Fonts

Haptic feedback on all buttons

5️⃣ Cube Pattern Library

Includes common & beautiful Rubik’s Cube patterns:

Checkerboard

Cube-in-cube

Six dots

Adjacent cross

Opposite cross

More can be added

Each pattern includes:

Visual preview

Pattern description

One-tap “Copy Moves” button

6️⃣ Cube Timer (Speedcubing)

Start/stop timer

Saves times

Displays:

Best time

Worst time

Average time

Neon glowing UI

7️⃣ Last Cube Memory

Your full cube input is saved locally.

You can restore it instantly with Load Last Cube.

8️⃣ Smart Validation System

The app validates:

Each color appears exactly 9 times

Correct center orientation

Logical corner and edge counts

Prevents invalid configurations

If invalid, user sees error details like:

Color U appears 10 times (must be 9)

9️⃣ 3D Animated Loading Screen

While solving, a rotating 3D Rubik’s Cube GIF or animated Lottie plays.

🧠 How CubeSnap Works Internally
1. User Inputs Colors

User taps tiles on the 3×3 sticker grid for each face.

2. Colors Converted to Kociemba Format

Based on the center sticker, faces map to:

Letter	Face	Color (Your App)
U	Up	Yellow
R	Right	Red
F	Front	Green
D	Down	Blue
L	Left	Orange
B	Back	Purple
3. Example Cube String Sent to Backend
UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB

4. Python Backend (Flask + Kociemba)

The backend receives JSON:

{"cube": "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB"}


Runs it through the Kociemba solver, returning e.g.:

R U R' U' F2 U' R U R' D2 ...

5. App Displays Moves & Saves to Firebase

User can now view, save, copy, or practice the movements.

📱 How to Use CubeSnap

Open the app — animated cube welcome screen loads

Choose Manual Input

Fill in the cube colors

Tap Solve Cube

View solution steps

Check Solve History

Use Patterns and Cube Timer features

🔧 Tech Stack Summary
Frontend

Flutter

Dart

Google Fonts

SharedPreferences

Lottie Animations

Backend

Python

Flask

Kociemba

Gunicorn

Hosted on Render.com

Database

Firebase Firestore

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
 │   └─ haptics.dart
 │
 ├─ logic/
 │   ├─ cube_converter.dart
 │   └─ solve_history.dart
 │
assets/
 ├─ animated_cube.json
 ├─ 3d_cube.gif
 └─ patterns/

💡 Why Use the Kociemba Algorithm?

The Kociemba 2-phase algorithm is used in:

Google’s Rubik’s Cube solver

Cube Explorer

Most professional solving engines

Benefits:

Generates near-optimal solutions

Fast (< 100ms on server)

Accurate and stable

Widely trusted in cubing community

🧪 Testing Guide
✔ Valid Cube Test

Input a realistic cube → should solve instantly.

✔ Invalid Cube Test

Mismatch colors → app shows clear error.

✔ History Test

Solve → check Firebase for new document.

✔ Last Cube Test

Restart app → Load Last Cube must restore previous input.

✔ Timer Test

Start & stop timer → times saved & displayed.

🏁 Final Summary

CubeSnap is a complete Rubik’s Cube ecosystem, featuring:

A solver powered by Kociemba

A modern neon animated UI

Cube patterns

Speedcubing timer

Firebase solve history

Local cube storage

3D loading animations

Smooth transitions & haptics

It is one of the most polished Rubik’s Cube apps possible using Flutter + Python.
