import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 0)
class UserSettings extends HiveObject {
  @HiveField(0)
  String mapTheme;

  @HiveField(1)
  String mapUrlTemplate;

  @HiveField(2)
  final List<String> usedVehicles;

  UserSettings({
    required this.mapTheme,
    required this.mapUrlTemplate,
    List<String>? usedVehicles,
  }) : usedVehicles = usedVehicles ?? [];

  UserSettings copyWith({
    String? mapTheme,
    String? mapUrlTemplate,
    List<String>? usedVehicles,
  }) {
    return UserSettings(
      mapTheme: mapTheme ?? this.mapTheme,
      mapUrlTemplate: mapUrlTemplate ?? this.mapUrlTemplate,
      usedVehicles: usedVehicles ?? this.usedVehicles,
    );
  }
}
