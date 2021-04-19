
import 'package:hive/hive.dart';


@HiveType()
class LastHive extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  HiveList friends;

  LastHive(this.name);

  String toString() => name; // For print()
}