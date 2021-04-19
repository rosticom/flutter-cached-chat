
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:dartchat/models/user_chat.dart';
import 'package:dartchat/view/messages/bloc/messages_bloc.dart';
import 'package:dartchat/view/messages/widgets/media/video_player.dart';
import 'package:dartchat/view/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key key,
    this.showFriendImage,
    @required this.friend,
    @required this.senderId,
    @required this.message,
    @required this.imgUrl,
    @required this.imgKey,
    @required this.thumbUrl,
    @required this.thumbHeight,
  }) : super(key: key);
  final bool showFriendImage;
  final UserChat friend;
  final String message;
  final String senderId;
  final String imgUrl;
  final String imgKey;
  final String thumbUrl;
  final int thumbHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: senderId == friend.userId
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: <Widget>[
         
          senderId == friend.userId
              // ? showFriendImage == true
              //     ? AvatarIcon(
              //         user: friend,
              //         radius: 0.045,
              //         errorWidgetColor: kBackgroundColor,
              //         placeholderColor: kBackgroundColor,
              //       )
              //     : 
                //  ? SizedBox(width: deviceData.screenHeight * 0.045)
                 ? SizedBox(width: 10)
              : SizedBox(width: 60),
              SizedBox(width: 0),
          Flexible(
            child: Container(
              child: imgUrl != null
              ? 
              Column(crossAxisAlignment: 
                senderId == friend.userId
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
                children: [
                  thumbHeight != 00000011111
                  ?  
                  Container(
                    padding: senderId == friend.userId ? 
                      EdgeInsets.only(
                        left: 40
                      ): EdgeInsets.only(
                        right: 0
                      ),
                    margin: const EdgeInsets.only(bottom: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: imgUrl == '' ? null : imgUrl,
                        cacheKey: imgUrl == '' ? null : imgKey,
                        fadeInCurve: Curves.ease,
                        fadeInDuration: 
                          BlocProvider.of<MessagesBloc>(context).keyTempImg == null
                          ? const Duration(milliseconds: 100) : const Duration(milliseconds: 20),
                        placeholderFadeInDuration: const Duration(milliseconds: 300),
                        width: 250.0,
                        height: thumbHeight != null ? thumbHeight.toDouble() : 0,
                      placeholder: (context, url) =>
                        imgUrl == ''
                        ? 
                        Stack(
                          children: [
                           Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10))
                              ),
                              width: 95, 
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(thumbUrl == 'video' ? 20 : 25)
                                ),
                                child: BlocProvider.of<MessagesBloc>(context).keyTempThumbnail != null ? 
                                  Image.memory(
                                    BlocProvider.of<MessagesBloc>(context).keyTempThumbnail,
                                    fit: BoxFit.contain,
                                  ): SizedBox(height: 200),
                              )
                          ))),
                          Positioned.fill(
                            child:  Align(
                              alignment: Alignment.center,
                              child: CircularPercentIndicator(
                                radius: thumbUrl != 'video' ? 230.0 : 170,
                                lineWidth: 17.0,
                                animation: true,
                                percent: BlocProvider.of<MessagesBloc>(context).progressUpload,
                                animationDuration: 1200,
                                animateFromLastPercent: true,
                                circularStrokeCap: CircularStrokeCap.square,
                                progressColor: greyColor,
                                // onAnimationEnd: () => setState(() => state = 'End Animation at 50%'),
                              ),
                            )
                          ),  
                        ],
                      )
                      :
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        width: 250, 
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                            thumbUrl != null ? thumbUrl : '', 
                            filterQuality: FilterQuality.low,
                            fit: BoxFit.contain,
                          )
                        )
                       )
                      ),
                    ),
                  ):
                  GestureDetector(
                    onTap: () => { 
                    },
                    child: Container(
                      padding: senderId == friend.userId ? 
                        EdgeInsets.only(
                          left: 40
                        ): EdgeInsets.only(
                          right: 0
                        ),
                      margin: const EdgeInsets.only(bottom: 5.0),
                      width: 250,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12)
                        ),
                        child: CachedVideo(
                          title: imgUrl,
                        ),
                      )
                    )
                  ),
                  message.isEmpty == false && thumbHeight != 00000011111
                  ?
                  Container(
                    margin: const EdgeInsets.only(bottom: 5.0),
                    decoration: BoxDecoration(
                      color: senderId == friend.userId ? lightestColor : chatUserColor,
                      borderRadius: BorderRadius.all(Radius.circular(11))
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 11
                    ),  
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 16,
                        color: darkestColor
                      ),
                    )): SizedBox(),
                  ])
                  :
                  Container(
                    margin: const EdgeInsets.only(bottom: 5.0),
                    decoration: BoxDecoration(
                      color: senderId == friend.userId ? lightestColor : chatUserColor,
                      borderRadius: BorderRadius.all(Radius.circular(11))
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 10
                    ),  
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 16,
                        color: darkestColor
                      ),
                    ),
                  )
            ),
          ),
          senderId == friend.userId
              ? SizedBox(width: 45)
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}