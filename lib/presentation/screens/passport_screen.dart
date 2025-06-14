import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:yourworld/core/constants/app_colors.dart';
import 'package:yourworld/core/hive/app_hive.dart';
import 'package:yourworld/models/country.dart';
import 'package:yourworld/models/country_status.dart';
import 'package:yourworld/presentation/screens/settings_screen.dart';

class PassportScreen extends StatefulWidget {
  const PassportScreen({super.key});

  @override
  State<PassportScreen> createState() => _PassportScreenState();
}

class _PassportScreenState extends State<PassportScreen> {
  int countriesCount = 0;
  int continentsCount = 0;
  int subregionsCount = 0;
  double percentageOfWorld = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCountryCounts();
  }

  void _loadCountryCounts() {
    final countriesBox = AppHive.countriesBox;
    final countries = countriesBox.values.cast<Country>().toList();

    // Filter countries based on their status
    final selectedCountries = countries
        .where((c) =>
            c.status == CountryStatus.visited ||
            c.status == CountryStatus.lived)
        .toList();

    // Obtain the unique continents
    final uniqueContinents = selectedCountries
        .map((c) => c.continent)
        .where((continent) => continent.isNotEmpty)
        .toSet();

    // Obtain the unique subregions
    final uniqueSubregions = selectedCountries
        .map((c) => c.subregion)
        .where((subregion) => subregion.isNotEmpty)
        .toSet();

    // Calculate counts and percentage
    final totalCountriesCount = countries.length;
    final visitedLivedCount = selectedCountries.length;
    final percent = totalCountriesCount > 0
        ? (visitedLivedCount / totalCountriesCount) * 100
        : 0.0;

    setState(() {
      countriesCount = visitedLivedCount;
      continentsCount = uniqueContinents.length;
      subregionsCount = uniqueSubregions.length;
      percentageOfWorld = percent;
    });
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 120,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 36, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passport', style: Theme.of(context).textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(FluentIcons.navigation_20_filled,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            CircularPercentIndicator(
              radius: 120,
              lineWidth: 14,
              percent: (percentageOfWorld / 100).clamp(0.0, 1.0),
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('World Explored',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    "${percentageOfWorld.toStringAsFixed(1)}%",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              progressColor: Theme.of(context).colorScheme.primary,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withAlpha(77),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildStatCard(
                  icon: FluentIcons.flag_20_filled,
                  label: 'Countries',
                  value: countriesCount.toString(),
                  context: context,
                ),
                _buildStatCard(
                  icon: FluentIcons.globe_20_filled,
                  label: 'Continents',
                  value: continentsCount.toString(),
                  context: context,
                ),
                _buildStatCard(
                  icon: FluentIcons.location_20_filled,
                  label: 'Subregions',
                  value: subregionsCount.toString(),
                  context: context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
