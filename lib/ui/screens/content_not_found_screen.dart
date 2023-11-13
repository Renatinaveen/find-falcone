import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../resources/assets_class.dart';
import '../../resources/constants.dart';
import '../../resources/fonts_class.dart';
import '../../resources/theme_class.dart';
import '../components/background_widget.dart';


class ContentNotFoundScreen extends StatefulWidget {
  const ContentNotFoundScreen({Key? key})
      : super(key: key);

  @override
  State<ContentNotFoundScreen> createState() => _ContentNotFoundScreenState();
}

class _ContentNotFoundScreenState extends State<ContentNotFoundScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            const BackgroundWidget(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Lottie.asset(
                  Assets.error,
                  repeat: true,
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeClass.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context, 'retry');
                  },
                  child: const Text(TextConstants.retry,
                      style: TextStyle(
                          fontFamily: FontsClass.poppinsFont,
                          color: ThemeClass.black)),
                ),
              ],
            ),
          ],
        )
      );
  }
}
