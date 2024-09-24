import 'package:flutter/material.dart';
import 'package:netflix_clone/pages/home_page.dart';

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 1600), () {});
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, _, __) => const HomePage(),
          transitionDuration: const Duration(milliseconds: 480),
          transitionsBuilder: (context, a, _, c) => FadeTransition(
            opacity: a,
            child: c,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Image(
          image: AssetImage('assets/logo.png'),
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}
