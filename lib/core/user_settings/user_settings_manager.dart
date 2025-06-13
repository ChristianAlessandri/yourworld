import 'package:yourworld/core/hive/app_hive.dart';
import 'package:yourworld/models/user_settings.dart';

class UserSettingsManager {
  static const String _settingsKey = 'settings';

  static UserSettings get settings {
    final box = AppHive.userSettingsBox;
    return box.get(_settingsKey) ??
        UserSettings(
          mapTheme: 'default',
          mapUrlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        );
  }

  static Future<void> updateSettings(UserSettings newSettings) async {
    await AppHive.userSettingsBox.put(_settingsKey, newSettings);
  }

  static Future<void> setMapTheme(String themeName) async {
    final current = settings;
    await updateSettings(
      UserSettings(
        mapTheme: themeName,
        mapUrlTemplate: current.mapUrlTemplate,
      ),
    );
  }

  static Future<void> setMapUrlTemplate(String urlTemplate) async {
    final current = settings;
    await updateSettings(
      UserSettings(
        mapTheme: current.mapTheme,
        mapUrlTemplate: urlTemplate,
      ),
    );
  }
}
