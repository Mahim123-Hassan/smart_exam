import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: const HomeScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [

              Color(0xff6A11CB),
              Color(0xff2575FC),

            ],

          ),

        ),

        child: FadeTransition(

          opacity: _animation,

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Container(

                height: 130,
                width: 130,

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius: BorderRadius.circular(35),

                  boxShadow: const [

                    BoxShadow(

                      color: Colors.black26,
                      blurRadius: 20,
                      offset: Offset(0,10),

                    )

                  ],

                ),

                child: const Center(

                  child: Text(

                    "📚",

                    style: TextStyle(
                      fontSize: 65,
                    ),

                  ),

                ),

              ),

              const SizedBox(height: 30),

              const Text(

                "SMART EXAM",

                style: TextStyle(

                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,

                ),

              ),

              const SizedBox(height: 10),

              const Text(

                "Learn • Practice • Succeed",

                style: TextStyle(

                  color: Colors.white70,
                  fontSize: 17,

                ),

              ),

              const SizedBox(height: 60),

              const CircularProgressIndicator(
                color: Colors.white,
              ),

            ],

          ),

        ),

      ),

    );
  }
}