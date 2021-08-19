import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_resonator/main.dart';

import 'package:project_resonator/pages/transcribe.dart';

import 'dart:async';

import 'package:project_resonator/pages/speak.dart';



class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, () {

      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => MyHomePage(title: 'Resonator',)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffed9e),
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          width: 200.0,
          height: 100.0,
        ),
      ),
    );
  }
}