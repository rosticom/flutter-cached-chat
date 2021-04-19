
import 'package:hive/hive.dart';

@HiveType()

class UserHive extends HiveObject {
  @HiveField(0)
  String name;

  UserHive(this.name);

  // @override
  // String toString() => name; // Just for print()
}