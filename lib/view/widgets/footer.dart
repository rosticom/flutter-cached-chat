import 'package:dartchat/view/utils/device_config.dart';
import 'package:flutter/material.dart';
import 'package:dartchat/view/utils/constants.dart';

class WhiteFooter extends StatelessWidget {
  const WhiteFooter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceData deviceData = DeviceData.init(context);
    return Container(
      width: deviceData.screenWidth,
      decoration: BoxDecoration(
        color: lightColor,
        // borderRadius: BorderRadius.only(
          // topLeft: Radius.circular(deviceData.screenWidth * 0.1),
          // topRight: Radius.circular(deviceData.screenWidth * 0.1),
        // ),
      ),
    );
  }
}
