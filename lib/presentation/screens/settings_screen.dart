import 'package:flutter/material.dart';
import 'package:yourworld/core/user_settings/map_url_templates.dart';
import 'package:yourworld/core/user_settings/user_settings_manager.dart';
import 'package:yourworld/core/constants/app_dropdown.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String selectedUrl;

  @override
  void initState() {
    super.initState();
    selectedUrl = UserSettingsManager.settings.mapUrlTemplate;
  }

  void _onMapUrlChanged(String? newUrl) {
    if (newUrl == null) return;
    setState(() {
      selectedUrl = newUrl;
    });
    UserSettingsManager.setMapUrlTemplate(newUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Map Tile Provider',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    child: Text(name),
                  );
                },
              ),
              onChanged: _onMapUrlChanged,
            ),
            const SizedBox(height: 8),
            Text(
              selectedUrl,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
