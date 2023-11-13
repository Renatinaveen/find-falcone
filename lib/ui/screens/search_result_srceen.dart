import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../../resources/fonts_class.dart';
import '../../resources/theme_class.dart';
import '../components/background_widget.dart';
import 'home_screen.dart';

class SearchResult extends StatelessWidget {
  final String? planetName, status, error;
  const SearchResult({Key? key, this.planetName, this.status, this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const BackgroundWidget(),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  FadeAnimatedText(
                    status == 'success' ? 'Search Success!' : 'Search Failure!',
                    textAlign: TextAlign.center,
                    textStyle: const TextStyle(
                        fontSize: FontsClass.fontSize32,
                        fontFamily: FontsClass.poppinsFont,
                        color: ThemeClass.white),
                  ),
                  TypewriterAnimatedText(
                    status == 'success'
                        ? 'Congratulations on Finding Falcone on $planetName. King Shan is mighty pleased.'
                        : 'Failed to find Falcone, King Shan is mighty upset.',
                    speed: const Duration(milliseconds: 200),
                    textAlign: TextAlign.center,
                    textStyle: const TextStyle(
                        fontSize: FontsClass.fontSize20,
                        fontFamily: FontsClass.poppinsFont,
                        color: ThemeClass.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return const HomeScreen();
                  }));
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
