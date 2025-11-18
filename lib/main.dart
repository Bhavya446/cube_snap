import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CubeSnapApp());
}

class CubeSnapApp extends StatelessWidget {
  const CubeSnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.dark();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CubeSnap',
      theme: base.copyWith(
        scaffoldBackgroundColor: kBackgroundDark,
        textTheme: GoogleFonts.poppinsTextTheme(
          base.textTheme.apply(bodyColor: Colors.white),
        ),
        colorScheme: base.colorScheme.copyWith(
          primary: kPrimaryColor,
          secondary: kAccentColor,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
// End