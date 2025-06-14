import 'package:yourworld/core/constants/app_constants.dart';
import 'package:yourworld/core/hive/app_hive.dart';
import 'package:yourworld/models/user_settings.dart';

class UserSettingsManager {
  static const String _settingsKey = 'settings';

  static UserSettings get settings {
    final box = AppHive.userSettingsBox;
    return box.get(_settingsKey) ??
        UserSettings(
          mapTheme: AppConstants.defaultMapTheme,
          mapUrlTemplate: AppConstants.defaultMapUrlTemplate,
          usedVehicles: [],
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

  static Future<void> addUsedVehicle(String vehicle) async {
    final currentSettings = settings;
    final updatedVehicles = currentSettings.usedVehicles.toSet()..add(vehicle);
    final newSettings = UserSettings(
      mapTheme: currentSettings.mapTheme,
      mapUrlTemplate: currentSettings.mapUrlTemplate,
      usedVehicles: updatedVehicles.toList(),
    );
    await updateSettings(newSettings);
  }

  static Future<void> setUsedVehicles(List<String> vehicles) async {
    final box = AppHive.userSettingsBox;
    final currentSettings = box.get(_settingsKey);

    final newSettings = currentSettings?.copyWith(usedVehicles: vehicles) ??
        UserSettings(
          mapTheme: AppConstants.defaultMapTheme,
          mapUrlTemplate: AppConstants.defaultMapUrlTemplate,
          usedVehicles: vehicles,
        );

    await box.put(_settingsKey, newSettings);
  }

  static Set<String> getUsedVehicles() {
    return settings.usedVehicles.toSet();
  }
}
