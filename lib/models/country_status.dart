import 'package:hive/hive.dart';

part 'country_status.g.dart';

@HiveType(typeId: 2)
enum CountryStatus {
  @HiveField(0)
  none,

  @HiveField(1)
  visited,

  @HiveField(2)
  want,

  @HiveField(3)
  lived,
}
