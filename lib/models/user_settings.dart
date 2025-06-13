import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 0)
class UserSettings extends HiveObject {
  @HiveField(0)
  String mapTheme;

  @HiveField(1)
  String mapUrlTemplate;

  UserSettings({
    required this.mapTheme,
    required this.mapUrlTemplate,
  });
}
