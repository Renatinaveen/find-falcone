import 'package:find_falcone/resources/constants.dart';
import 'package:find_falcone/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FindFalconeApp());
}

class FindFalconeApp extends StatelessWidget {
  const FindFalconeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TextConstants.title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
