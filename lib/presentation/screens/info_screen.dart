import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yourworld/core/constants/app_colors.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  void _launchURL() async {
    final url = Uri.parse('https://christianalessandri.yourvibes.it');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Information', style: Theme.of(context).textTheme.titleLarge),
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
        child: ListView(
          children: [
            Text(
              'About the App',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'This app allows users to mark the countries they have visited, lived in, or want to visit. The data is stored locally on your device and is not shared with any third parties.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Map and Country Boundaries',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'The map boundaries used in this app are based on a GeoJSON file from geojson-maps.kyd.au, an open-source project.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Important Note:',
              style:
                  textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Displayed borders may not accurately reflect official or internationally recognized boundaries. The data is intended for illustrative and personal use only, and does not imply any political stance.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Disclaimer',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'This app is provided "as is", without warranties of any kind. The developer is not responsible for any inaccuracies, misuse of the data, or any consequences arising from the use of the app.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Developer',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Created by Christian Alessandri.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _launchURL,
              child: Text(
                'https://christianalessandri.yourvibes.it',
                style: textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
