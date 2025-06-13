import 'package:hive/hive.dart';
import 'package:yourworld/models/country_status.dart';

part 'country.g.dart';

@HiveType(typeId: 1)
class Country extends HiveObject {
  @HiveField(0)
  String isoA2;

  @HiveField(1)
  CountryStatus status;

  Country({
    required this.isoA2,
    this.status = CountryStatus.none,
  });
}
