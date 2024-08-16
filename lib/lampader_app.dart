import 'package:flutter/material.dart';
import './screens/home_screen.dart';
class LampaderApp extends StatelessWidget {
  const LampaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
