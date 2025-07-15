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

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 24),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _paragraph(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Information',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            FluentIcons.chevron_left_20_filled,
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _sectionTitle(context, 'About the App'),
            _paragraph(
              context,
              'This app allows users to mark the countries they have visited, lived in, or want to visit. The data is stored locally on your device and is not shared with any third parties.',
            ),
            _sectionTitle(context, 'Map and Country Boundaries'),
            _paragraph(
              context,
              'The map boundaries used in this app are based on a GeoJSON file from geojson-maps.kyd.au, an open-source project.',
            ),
            _sectionTitle(context, 'Important Note'),
            _paragraph(
              context,
              'Displayed borders may not accurately reflect official or internationally recognized boundaries. The data is intended for illustrative and personal use only, and does not imply any political stance.',
            ),
            _sectionTitle(context, 'Country Data'),
            _paragraph(
              context,
              'The country data displayed in this app may not be accurate or up to date. All information is sourced from restcountries.com and is provided “as is” without warranties of any kind. Please verify details independently if needed.',
            ),
            _sectionTitle(context, 'Disclaimer'),
            _paragraph(
              context,
              'This app is provided "as is", without warranties of any kind. The developer is not responsible for any inaccuracies, misuse of the data, or any consequences arising from the use of the app.',
            ),
            _sectionTitle(context, 'Developer'),
            _paragraph(context, 'Created by Christian Alessandri.'),
            GestureDetector(
              onTap: _launchURL,
              child: Text(
                'https://christianalessandri.yourvibes.it',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
