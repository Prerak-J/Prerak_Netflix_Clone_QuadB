import 'package:flutter/material.dart';
import 'package:netflix_clone/screens/flash_screen.dart';
import 'package:netflix_clone/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlack,
        ),
        useMaterial3: true,
      ),
      home: const FlashScreen(),
    );
  }
}
