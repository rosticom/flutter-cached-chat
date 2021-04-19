import 'package:dartchat/utils/functions.dart';
import 'package:dartchat/view/widgets/popup_menu.dart';
import 'package:dartchat/view/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:dartchat/models/user_chat.dart';
import 'package:dartchat/view/messages/widgets/back_icon.dart';
import 'package:dartchat/view/utils/device_config.dart';
import 'package:dartchat/view/widgets/avatar_icon.dart';

class MessagesHeader extends StatelessWidget {
  final UserChat friend;
  const MessagesHeader({Key key, @required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);

    return Padding(
      padding: EdgeInsets.only(
        top: deviceData.screenHeight * 0.035,
        bottom: deviceData.screenHeight * 0.000,
        left: deviceData.screenWidth * 0.00,
        right: deviceData.screenWidth * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BackIcon(),
              AvatarIcon(
                user: friend,
                radius: 0.05,
              ),
              SizedBox(width: deviceData.screenWidth * 0.03),
              Text(
                Functions.getFirstName(friend.name),
                style: kArialFontStyle.copyWith(
                  fontSize: deviceData.screenHeight * 0.022,
                  color: lightestColor,
                ),
              ),
            ],
          ),
          PopUpMenu(colorWidget: 'light'),
        ],
      ),
    );
  }
}
