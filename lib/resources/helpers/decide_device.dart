import 'package:flutter/cupertino.dart';

class DecideDevice {
  returnDeviceType(BuildContext context) {
    final data = MediaQuery.of(context);
    return data.size.width > 800 ? 0 : 1; // 0 for Tablet or Desktop and 1 for Mobile
  }
}
