import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:find_falcone/ui/components/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../resources/assets_class.dart';
import '../../resources/constants.dart';
import '../../resources/fonts_class.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    takeToHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const BackgroundWidget(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(Assets.splashAnimation,
                  repeat: true,
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height * 0.9),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    TextConstants.title,
                    speed: const Duration(milliseconds: 200),
                    textStyle: const TextStyle(
                        fontSize: 30,
                        fontFamily: FontsClass.poppinsFont,
                        color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takeToHomePage() async {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return const HomeScreen();
      }));
    });
  }
}
