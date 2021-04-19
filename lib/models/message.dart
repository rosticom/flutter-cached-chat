
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Message extends Equatable {
  final String message;
  final String senderId;
  final String time;
  final String imgUrl;
  final String thumbUrl;
  final int thumbHeight;
  const Message({
      @required this.time, 
      @required this.senderId, 
      @required this.message, 
      @required this.imgUrl,
      @required this.thumbUrl,
      @required this.thumbHeight,
  })
      : assert(message != null, "Message must not be equall null"),
        assert(senderId != null, "senderID must not be equall null");

  @override
  List<Object> get props => [message, senderId, time, imgUrl, thumbUrl, thumbHeight];

  Map<String, dynamic> toMap() {
    return {
      'message': message, 
      'senderId': senderId, 
      'time': time, 
      'imgUrl': imgUrl, 
      'thumbUrl': thumbUrl, 
      'thumbHeight': thumbHeight
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Message(
        message: 
          map['message'], 
          senderId: map['senderId'], 
          time: map['time'], 
          imgUrl: map['imgUrl'], 
          thumbUrl: map['thumbUrl'], 
          thumbHeight: map['thumbHeight']
    );}

  set message(String newMessage) {
    message = newMessage;
  } 
  set time(String newTime) {
    time = newTime;
  } 
  set senderId(String newSenderId) {
    senderId = newSenderId;
  }
  set imgUrl(String newimgUrl) {
    imgUrl = newimgUrl;
  }
  set thumbUrl(String newthumbUrl) {
    thumbUrl = newthumbUrl;
  }
  set thumbHeight(int newthumbHeight) {
    thumbHeight = newthumbHeight;
  }
}
