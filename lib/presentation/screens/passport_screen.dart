import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:yourworld/core/constants/app_colors.dart';
import 'package:yourworld/core/hive/app_hive.dart';
import 'package:yourworld/core/user_settings/user_settings_manager.dart';
import 'package:yourworld/models/country.dart';
import 'package:yourworld/models/country_status.dart';
import 'package:yourworld/models/vehicle_type.dart';
import 'package:yourworld/presentation/screens/detail_list_screen.dart';
import 'package:yourworld/presentation/screens/settings_screen.dart';
import 'package:yourworld/presentation/widgets/stat_card.dart';
import 'package:yourworld/presentation/widgets/transport_badge.dart';

class PassportScreen extends StatefulWidget {
  const PassportScreen({super.key});

  @override
  State<PassportScreen> createState() => _PassportScreenState();
}

class _PassportScreenState extends State<PassportScreen> {
  Set<String> userUsedVehicles = {};
  int countriesCount = 0;
  int continentsCount = 0;
  int subregionsCount = 0;
  double percentageOfWorld = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCountryCounts();
    _loadUsedVehicles();
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

  void _loadUsedVehicles() {
    setState(() {
      userUsedVehicles = UserSettingsManager.getUsedVehicles();
    });
  }

  void _openDetailScreen(String type) {
    final allCountries = AppHive.countriesBox.values.cast<Country>().toList();
    final visitedCountries = allCountries
        .where(
          (c) =>
              c.status == CountryStatus.visited ||
              c.status == CountryStatus.lived,
        )
        .toList();

    late List<String> allKeys;
    late Set<String> visitedKeys;
    late Map<String, List<Country>> grouped;

    switch (type) {
      case 'countries':
        allKeys = allCountries.map((c) => c.name).toList()..sort();
        visitedKeys = visitedCountries.map((c) => c.name).toSet();
        grouped = {
          for (var c in allCountries) c.name: [c]
        };
        break;

      case 'continents':
        allKeys = allCountries
            .map((c) => c.continent)
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
        visitedKeys = visitedCountries
            .map((c) => c.continent)
            .where((e) => e.isNotEmpty)
            .toSet();
        grouped = {
          for (var key in allKeys)
            key: allCountries.where((c) => c.continent == key).toList()
        };
        break;

      case 'subregions':
        allKeys = allCountries
            .map((c) => c.subregion)
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
        visitedKeys = visitedCountries
            .map((c) => c.subregion)
            .where((e) => e.isNotEmpty)
            .toSet();
        grouped = {
          for (var key in allKeys)
            key: allCountries.where((c) => c.subregion == key).toList()
        };
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailListScreen(
          title: type[0].toUpperCase() + type.substring(1),
          allItems: allKeys,
          visitedItems: visitedKeys,
          groupedCountries: grouped,
        ),
      ),
    );
  }

  void _showVehiclePicker(List<String> allVehicles, String categoryLabel) {
    final tempSelection = Set<String>.from(userUsedVehicles);

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSurface
          : AppColors.lightSurface,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      '$categoryLabel Vehicles',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: (allVehicles.toList()..sort()).map((vehicle) {
                        final isSelected = tempSelection.contains(vehicle);
                        return CheckboxListTile(
                          title: Text(vehicle,
                              style: Theme.of(context).textTheme.bodyMedium),
                          value: isSelected,
                          onChanged: (checked) {
                            setModalState(() {
                              if (checked == true) {
                                tempSelection.add(vehicle);
                              } else {
                                tempSelection.remove(vehicle);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final newUsedVehicles =
                            Set<String>.from(userUsedVehicles);
                        newUsedVehicles
                            .removeWhere((v) => allVehicles.contains(v));
                        newUsedVehicles.addAll(tempSelection
                            .where((v) => allVehicles.contains(v)));

                        await UserSettingsManager.setUsedVehicles(
                            newUsedVehicles.toList());

                        if (!mounted) return;

                        setState(() {
                          userUsedVehicles = newUsedVehicles;
                        });

                        navigator.pop();
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
              alignment: WrapAlignment.spaceEvenly,
              spacing: 12,
              runSpacing: 12,
              children: [
                StatCard(
                  icon: FluentIcons.flag_20_filled,
                  label: 'Countries',
                  value: countriesCount.toString(),
                  onTap: () => _openDetailScreen('countries'),
                ),
                StatCard(
                  icon: FluentIcons.globe_20_filled,
                  label: 'Continents',
                  value: continentsCount.toString(),
                  onTap: () => _openDetailScreen('continents'),
                ),
                StatCard(
                  icon: FluentIcons.location_20_filled,
                  label: 'Subregions',
                  value: subregionsCount.toString(),
                  onTap: () => _openDetailScreen('subregions'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 12,
              runSpacing: 12,
              children: [
                TransportBadge(
                  label: 'Land',
                  icon: FluentIcons.vehicle_car_20_filled,
                  usedVehicles: userUsedVehicles,
                  allVehicles: landVehicles,
                  onTap: () => _showVehiclePicker(landVehicles, 'Land'),
                ),
                TransportBadge(
                  label: 'Sea',
                  icon: FluentIcons.vehicle_ship_20_filled,
                  usedVehicles: userUsedVehicles,
                  allVehicles: seaVehicles,
                  onTap: () => _showVehiclePicker(seaVehicles, 'Sea'),
                ),
                TransportBadge(
                  label: 'Air',
                  icon: FluentIcons.airplane_20_filled,
                  usedVehicles: userUsedVehicles,
                  allVehicles: airVehicles,
                  onTap: () => _showVehiclePicker(airVehicles, 'Air'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
