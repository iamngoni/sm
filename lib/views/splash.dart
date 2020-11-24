import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:school_management/statics/values.dart';
import 'package:school_management/views/auth/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: height(context),
        width: width(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.1),
            child: Text(
              "School Management",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
