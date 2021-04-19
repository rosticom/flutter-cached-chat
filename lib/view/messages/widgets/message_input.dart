import 'package:dartchat/view/utils/constants.dart';
import 'package:dartchat/view/utils/device_config.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({
    Key key,
    @required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final deviceData = DeviceData.init(context);
        return TextField(
          textCapitalization: TextCapitalization.sentences,
          controller: controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          textInputAction: TextInputAction.newline,
          cursorColor: kBackgroundButtonColor,
          style: TextStyle(
            // fontSize: deviceData.screenHeight * 0.018,
            fontSize: 18,
            color: darkestColor
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Message",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        );
  }
}
