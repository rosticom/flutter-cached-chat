

// import 'package:dartchat/services/hive_service/adapters/adapter-models/tmp/message_hive.dart';
// import 'package:hive/hive.dart';

// class MessageHiveAdapter extends TypeAdapter<MessageHive> {
//   @override
//   final typeId = 5;

//   MessageHive read(BinaryReader reader) {
//     return MessageHive(reader.read(), reader.read(), reader.read());
//   }

//   @override
//   void write(BinaryWriter writer, MessageHive obj) {
//     writer.write(obj.message);
//     writer.write(obj.senderId);
//     writer.write(obj.time);
//   }
// }