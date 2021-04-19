import 'package:dartchat/models/message.dart';
import 'package:dartchat/models/user_chat.dart';
import 'package:dartchat/service_locator.dart';
import 'package:dartchat/utils/failure.dart';
import 'package:dartchat/view/messages/bloc/messages_bloc.dart';
import 'package:dartchat/view/messages/widgets/messages_header.dart';
import 'package:dartchat/view/utils/constants.dart';
import 'package:dartchat/view/utils/device_config.dart';
import 'package:dartchat/view/widgets/footer.dart';
import 'package:dartchat/view/messages/widgets/messages_list.dart';
import 'package:dartchat/view/widgets/progress_indicator.dart';
import 'package:dartchat/view/widgets/try_again_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final UserChat friend;
  MessagesScreen({@required this.friend});
  static String routeID = "MESSAGE_SCREEN";

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessagesScreen> {
  Future<List<Message>> messagesFuture;
  TextEditingController controller;
  DeviceData deviceData;
  bool showMessages = false;
  MessagesBloc messagesBloc;
  @override
  void initState() {
    messagesBloc = serviceLocator<MessagesBloc>();
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messagesBloc.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceData = DeviceData.init(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: lightColor,
        body: Container(
          color: headerChatColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MessagesHeader(friend: widget.friend),
              Expanded(
                child: BlocProvider<MessagesBloc>(
                  create: (context) =>
                      messagesBloc..add(MessagesStartFetching(widget.friend)),
                  child: Stack(
                    children: <Widget>[
                      const WhiteFooter(),
                      MessagesList(friend: widget.friend),
                      BlocBuilder<MessagesBloc, MessagesState>(
                        builder: (context, state) {
                          return state is MessagesLoading
                              ? const Center(child: CircleProgress())
                              : state is MessagesLoadFailed &&
                                      state.failure is NetworkException
                                  ? TryAgain(
                                      doAction: () => 
                                       BlocProvider.of<MessagesBloc>(context)
                                        .add(MessagesStartFetching(widget.friend))
                                  )
                                  : SizedBox.shrink();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
