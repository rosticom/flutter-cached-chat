
import 'package:hive/hive.dart';
import 'adapter-models/user_presentation_hive.dart';

class UserPresentationAdapter extends TypeAdapter<UserPresentationHive> {
  @override
  final typeId = 4;

  UserPresentationHive read(BinaryReader reader) {
    return UserPresentationHive(reader.read(), reader.read(), reader.read(), reader.read(), reader.read(),
      reader.read(), reader.read(), reader.read(), reader.read(), reader.read());
  }

  @override
  void write(BinaryWriter writer, UserPresentationHive obj) {
    writer.write(obj.lastMessage);
    writer.write(obj.lastMessageSenderId);
    writer.write(obj.lastMessageTime);
    writer.write(obj.lastMessageSeen);
    
    writer.write(obj.name);
    writer.write(obj.email);
    writer.write(obj.imgUrl);
    writer.write(obj.imageType);
    writer.write(obj.userId);
    writer.write(obj.currentUserId);
  }
}