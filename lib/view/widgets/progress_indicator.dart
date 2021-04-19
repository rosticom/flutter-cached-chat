import 'package:dartchat/view/utils/constants.dart';
import 'package:dartchat/view/utils/device_config.dart';
import 'package:flutter/material.dart';

class CircleProgress extends StatelessWidget {
  final double radius;
  const CircleProgress({
    Key key,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);

    return Container(
      width: radius == null ? deviceData.screenHeight * 0.06 : deviceData.screenHeight * radius ,
      height: radius == null ? deviceData.screenHeight * 0.06 : deviceData.screenHeight * radius ,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        backgroundColor: sendButtonColor
      ),
    );
  }
}
