
import 'package:hive/hive.dart';

 @HiveType(typeId: 4)
  class UserPresentationHive {

    @HiveField(0)
    String lastMessage; 

    @HiveField(1)
    String lastMessageSenderId;

    @HiveField(2)
    String lastMessageTime;

    @HiveField(3)
    bool lastMessageSeen;

    @HiveField(4)
    String name;

    @HiveField(5)
    String email;

    @HiveField(6)
    String imgUrl;

    @HiveField(7)
    String imageType;

    @HiveField(8)
    String userId;

    @HiveField(9)
    String currentUserId;

    UserPresentationHive(this.lastMessage, this.lastMessageSenderId, this.lastMessageTime, this.lastMessageSeen, this.name,
      this.email, this.imgUrl, this.imageType, this.userId, this.currentUserId);
}