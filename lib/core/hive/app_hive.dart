import 'package:hive_flutter/hive_flutter.dart';
import 'package:yourworld/models/country.dart';
import 'package:yourworld/models/country_status.dart';
import 'package:yourworld/models/user_settings.dart';

class AppHive {
  AppHive._();

  // ========================
  // BOX NAMES
  // ========================
  static const String userSettingsBoxName = 'userSettingsBox';
  static const String countriesBoxName = 'countriesBox';

  // ========================
  // INIT METHOD
  // ========================
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserSettingsAdapter());
    Hive.registerAdapter(CountryAdapter());
    Hive.registerAdapter(CountryStatusAdapter());

    await Hive.openBox<UserSettings>(userSettingsBoxName);
    await Hive.openBox<Country>(countriesBoxName);

    final userSettingsBox = Hive.box<UserSettings>(userSettingsBoxName);
    if (userSettingsBox.isEmpty) {
      userSettingsBox.put(
        'settings',
        UserSettings(
          mapTheme: 'default',
          mapUrlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
      );
    }
  }

  // ========================
  // GETTERS BOX
  // ========================
  static Box<UserSettings> get userSettingsBox =>
      Hive.box<UserSettings>(userSettingsBoxName);
  static Box<Country> get countriesBox => Hive.box<Country>(countriesBoxName);
}
