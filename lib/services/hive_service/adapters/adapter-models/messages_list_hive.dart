
import 'package:hive/hive.dart';

@HiveType(typeId: 6)
  class MessagesListHive {
    @HiveField(0)
    String senderId;

    @HiveField(0)
    HiveList messageList;

    MessagesListHive(this.senderId, this.messageList);
  }