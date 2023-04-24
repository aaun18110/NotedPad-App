// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_database/Screen/homescreen.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    showScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.note_add_rounded,
            size: 60,
            color: Colors.blue.shade400,
          ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              decoration: const BoxDecoration(),
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  // color: Colors.blue,
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.blue.shade700,
                  highlightColor: Colors.blue.shade200,
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      FlickerAnimatedText(
                        'Notes',
                      ),
                    ],
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void showScreen() {
    print("splash");
    Timer(const Duration(seconds: 6), () {
      Hive.openBox("diary");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }
}
