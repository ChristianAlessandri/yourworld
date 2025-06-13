import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 0)
class UserSettings extends HiveObject {
  @HiveField(0)
  bool isDarkTheme;

  @HiveField(1)
  String mapTheme;

  @HiveField(2)
  String mapUrlTemplate;

  UserSettings({
    required this.isDarkTheme,
    required this.mapTheme,
    required this.mapUrlTemplate,
  });
}
