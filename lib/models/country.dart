import 'package:hive/hive.dart';
import 'package:yourworld/models/country_status.dart';

part 'country.g.dart';

@HiveType(typeId: 1)
class Country extends HiveObject {
  @HiveField(0)
  String isoA2;

  @HiveField(1)
  String name;

  @HiveField(2)
  String continent;

  @HiveField(3)
  String subregion;

  @HiveField(4)
  CountryStatus status;

  Country({
    required this.isoA2,
    required this.name,
    required this.continent,
    required this.subregion,
    this.status = CountryStatus.none,
  });
}
