import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:yourworld/core/constants/app_colors.dart';
import 'package:yourworld/core/constants/map_palettes.dart';
import 'package:yourworld/models/map_url_templates.dart';
import 'package:yourworld/core/user_settings/user_settings_manager.dart';
import 'package:yourworld/core/constants/app_dropdown.dart';
import 'package:yourworld/core/utils/utils.dart';
import 'package:yourworld/presentation/screens/info_screen.dart';
import 'package:yourworld/presentation/widgets/color_preview_box.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String selectedUrl;
  late String selectedTheme;

  @override
  void initState() {
    super.initState();
    selectedUrl = UserSettingsManager.settings.mapUrlTemplate;
    selectedTheme = UserSettingsManager.settings.mapTheme;
  }

  void _onMapUrlChanged(String? newUrl) {
    if (newUrl == null) return;
    setState(() {
      selectedUrl = newUrl;
    });
    UserSettingsManager.setMapUrlTemplate(newUrl);
  }

  void _onMapThemeChanged(String? newTheme) {
    if (newTheme == null) return;
    setState(() {
      selectedTheme = newTheme;
    });
    UserSettingsManager.setMapTheme(newTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(FluentIcons.chevron_left_20_filled,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Map Tile Provider Dropdown
                  Text(
                    'Map Tile Provider',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  AppDropdown.themedDropdown<String>(
                    context: context,
                    value: selectedUrl,
                    items: List.generate(
                      MapUrlTemplates.all.length,
                      (index) {
                        final url = MapUrlTemplates.all[index];
                        final name = MapUrlTemplates.names[index];
                        return DropdownMenuItem(
                          value: url,
                          child: Text(name,
                              style: Theme.of(context).textTheme.bodyMedium),
                        );
                      },
                    ),
                    onChanged: _onMapUrlChanged,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Theme',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  AppDropdown.themedDropdown<String>(
                    context: context,
                    value: selectedTheme,
                    items: MapPalettes.paletteKeys.map((themeKey) {
                      return DropdownMenuItem(
                        value: themeKey,
                        child: Text(
                            Utils.capitalize(themeKey.replaceAll('_', ' ')),
                            style: Theme.of(context).textTheme.bodyMedium),
                      );
                    }).toList(),
                    onChanged: _onMapThemeChanged,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ColorPreviewBox(
                          color: MapPalettes.getPalette(selectedTheme).visited,
                          isFirst: true,
                        ),
                      ),
                      Expanded(
                        child: ColorPreviewBox(
                          color: MapPalettes.getPalette(selectedTheme).lived,
                        ),
                      ),
                      Expanded(
                        child: ColorPreviewBox(
                          color: MapPalettes.getPalette(selectedTheme).want,
                          isLast: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: Icon(FluentIcons.info_20_filled),
                label: Text(
                  'More information',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const InfoScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
