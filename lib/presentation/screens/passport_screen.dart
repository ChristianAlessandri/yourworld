import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:yourworld/core/constants/app_colors.dart';
import 'package:yourworld/core/hive/app_hive.dart';
import 'package:yourworld/models/country.dart';
import 'package:yourworld/models/country_status.dart';
import 'package:yourworld/presentation/screens/settings_screen.dart';
import 'package:yourworld/presentation/widgets/vanity_metrics.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Passport',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(FluentIcons.navigation_20_filled,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("World Explored: ",
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text("${percentageOfWorld.toStringAsFixed(1)}%",
                      style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  VanityMetrics(
                      text: "Countries", number: countriesCount.toString()),
                  VanityMetrics(
                      text: "Continents", number: continentsCount.toString()),
                  VanityMetrics(
                      text: "Subregions", number: subregionsCount.toString())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
