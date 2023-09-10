import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_screen.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = "splash-screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final store = GetStorage();

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {

      FirebaseAuth.instance.authStateChanges().listen((User user){
        if(user == null){
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        } else {
           Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });
      // bool? boarding = store.read("onBoarding");
      // boarding == null
          // ? Navigator.pushReplacementNamed(context, WelcomeScreen.id)
          // : boarding == true
              // ? Navigator.pushReplacementNamed(context, MainScreen.id)
              // : Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      // Navigator.pushNamed(context, WelcomeScreen.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo here
            Image.asset(
              "assets/images/kiranja-logo.png",
              height: 350,
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
