
import 'package:hive/hive.dart';

 @HiveType(typeId: 5)
  class MessageHive {

    @HiveField(0)
    String message; 

    @HiveField(1)
    String senderId;

    @HiveField(2)
    String time;

  MessageHive(this.message, this.senderId, this.time);
}