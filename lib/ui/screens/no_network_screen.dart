import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../resources/assets_class.dart';
import '../../resources/constants.dart';
import '../../resources/fonts_class.dart';
import '../../resources/helpers/network_listener.dart';
import '../../resources/theme_class.dart';
import '../components/background_widget.dart';


class NoNetworkScreen extends StatefulWidget {
  const NoNetworkScreen({Key? key}) : super(key: key);

  @override
  State<NoNetworkScreen> createState() => _NoNetworkScreenState();
}

class _NoNetworkScreenState extends State<NoNetworkScreen> {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Lottie.asset(
                    Assets.noConnection,
                    repeat: true,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Text('No Internet Connection', style: TextStyle(
                        color: ThemeClass.white,
                      ),),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeClass.white,
                ),
                onPressed: () {
                  NetworkListener().listenToInternetConnection().then((value) {
                    if (value == true) {
                      Navigator.pop(context);
                    }
                  });
                },
                child: const Text(
                  TextConstants.retry,
                  style: TextStyle(
                      fontFamily: FontsClass.poppinsFont, color: ThemeClass.black),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
