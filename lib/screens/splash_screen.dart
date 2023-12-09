import 'dart:async';

import 'package:fadduapp/provider/sign_in_provider.dart';
import 'package:fadduapp/screens/home_screen.dart';
import 'package:fadduapp/screens/login_screen.dart';
import 'package:fadduapp/utils/config.dart';
import 'package:fadduapp/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // init state

  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();

    Timer(const Duration(seconds: 1, milliseconds: 900), () {
      sp.isSignedIn == false
          ? nextScreen(context, const LoginScreen())
          : nextScreen(context, const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 31, 26, 47),
        body: SafeArea(
            child: Center(
          //     child: Image(
          //   image: AssetImage(Config.app_icon),
          //   height: 80,
          //   width: 80,
          // ),
          //   child: Lottie.network(
          //       'https://lottie.host/embed/34734850-9681-4acd-a39d-bb5bdd969364/zS01g1Uwye.json'),
          // ),
          child: Lottie.asset('animations/Animation - 1701697845860.json'),
        )));
  }
}
