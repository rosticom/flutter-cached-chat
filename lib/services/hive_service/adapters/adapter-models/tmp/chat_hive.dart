
import 'package:hive/hive.dart';

 @HiveType(typeId: 2)
  class ChatHive {

    @HiveField(0)
    bool sender; // sender is user if senderId = true

    @HiveField(1)
    String senderName;

    @HiveField(2)
    String textMessage;

    @HiveField(3)
    String avatar;

    @HiveField(4)
    DateTime dateTime;

    ChatHive(this.sender, this.senderName, this.textMessage, this.avatar, this.dateTime);
}