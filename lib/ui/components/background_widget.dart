import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../resources/assets_class.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      Assets.backgroundAnimation,
      repeat: true,
      fit: BoxFit.cover,
      height: MediaQuery.of(context).size.height,
    );
  }
}
