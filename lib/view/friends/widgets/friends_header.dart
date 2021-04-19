import 'package:dartchat/view/friends/widgets/avatar_button.dart';
import 'package:dartchat/view/friends/widgets/back_icon.dart';
import 'package:dartchat/view/widgets/popup_menu.dart';
import 'package:dartchat/view/friends/widgets/search_widget.dart';
import 'package:dartchat/view/utils/constants.dart';
import 'package:dartchat/view/utils/device_config.dart';
import 'package:flutter/material.dart';

class FriendsHeader extends StatelessWidget {
  const FriendsHeader({
    Key key,
    @required this.editForm,
    @required this.onBackPressed,
    @required this.onAvatarPressed,
  }) : super(key: key);

  final bool editForm;
  final Function onBackPressed;
  final Function onAvatarPressed;

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);
    return Padding(
      padding: EdgeInsets.only(
        top: deviceData.screenHeight * 0.07,
        left: deviceData.screenWidth * 0.08,
        right: deviceData.screenWidth * 0.08,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Let's Chat \n with friends",
                style: kTitleTextStyle.copyWith(
                  fontSize: deviceData.screenHeight * 0.028,
                ),
              ),
              PopUpMenu(colorWidget: 'dark'),
            ],
          ),
          SizedBox(height: deviceData.screenHeight * 0.02),
          Container(
            height: deviceData.screenHeight * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: editForm
                    ? BackIcon(
                        onPressed: () =>
                            onBackPressed != null ? onBackPressed() : null)
                    : SearchWidget(),
                ),
                AvatarButton(
                  onPressed: () =>
                      onAvatarPressed != null ? onAvatarPressed() : null,
                ),
              ],
            ),
          ),
          SizedBox(height: deviceData.screenHeight * 0.015),
        ],
      ),
    );
  }
}
