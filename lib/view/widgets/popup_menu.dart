import 'package:dartchat/view/register/bloc/account_bloc.dart';
import 'package:dartchat/view/utils/constants.dart';
import 'package:dartchat/view/utils/device_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopUpMenu extends StatelessWidget {
  PopUpMenu({this.colorWidget});
  final String colorWidget;

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);

    return Container(
      width: deviceData.screenHeight * 0.05,
      height: deviceData.screenHeight * 0.05,
      // decoration: ShapeDecoration(
      //   shape: CircleBorder(),
      //   // color: Color(0xFF20a0bf),
      // ),
      child: PopupMenuButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        icon: Icon(
          Icons.more_vert,
          color: colorWidget=='dark' ? kInputTitleColor : lightestColor,
          size: deviceData.screenWidth * 0.058,
        ),
        color: kBackgroundButtonColor,
        onSelected: (value) {
          if (value == "logout") {
            BlocProvider.of<AccountBloc>(context).add(LogOutEvent());
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              value: "logout",
              child: Center(
                child: Text(
                  "Log out",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ];
        },
      ),
    );
  }
}
