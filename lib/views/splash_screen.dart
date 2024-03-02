import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pgc/constants/text_const.dart';
import 'package:pgc/views/home_screen.dart';
import 'package:pgc/views/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    timer();
  }

  Future timer() {
    final time = Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/logo.svg'),
              SizedBox(height: 40),
              Text(
                "Pulse well",
                style: kMainTitleBoldTextStyle.copyWith(color: Colors.black),
              ),
              SizedBox(height: 20),
              Text(
                "\"Healing Hearts, Guiding Hands\"",
                style: kMainTitleBoldTextStyle.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
