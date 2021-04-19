
import 'package:hive/hive.dart';
import 'adapter-models/messages_list_hive.dart';

class MessageHiveAdapter extends TypeAdapter<MessagesListHive> {
  @override
  final typeId = 6;

  MessagesListHive read(BinaryReader reader) {
    return MessagesListHive(reader.read(), reader.read());
  }

  @override
  void write(BinaryWriter writer, MessagesListHive obj) {
    writer.write(obj.senderId);
    writer.write(obj);
  }
}