
import 'package:dartchat/services/hive_service/adapters/adapter-models/tmp/last_hive.dart';
import 'package:hive/hive.dart';


class LastHiveAdapter extends TypeAdapter<LastHive> {
  @override
  final typeId = 1;

  @override
  LastHive read(BinaryReader reader) {
    return LastHive(reader.read())..friends = reader.read();
  }

  @override
  void write(BinaryWriter writer, LastHive obj) {
    writer.write(obj.name);
    writer.write(obj.friends);
  }
}