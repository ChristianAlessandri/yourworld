import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:yourworld/core/constants/app_colors.dart';
import 'package:yourworld/core/hive/app_hive.dart';
import 'package:yourworld/core/user_settings/user_settings_manager.dart';
import 'package:yourworld/models/badge_utils.dart';
import 'package:yourworld/models/country.dart';
import 'package:yourworld/models/country_status.dart';
import 'package:yourworld/models/vehicle_type.dart';
import 'package:yourworld/presentation/screens/detail_list_screen.dart';
import 'package:yourworld/presentation/screens/settings_screen.dart';

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

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
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
      ),
    );
  }

  Widget buildTransportBadge({
    required String label,
    required IconData icon,
    required Set<String> usedVehicles,
    required List<String> allVehicles,
    required VoidCallback onTap,
  }) {
    final usedCount = usedVehicles.where((v) => allVehicles.contains(v)).length;
    final percent = usedCount / allVehicles.length;
    final level = getBadgeLevelByPercentage(percent);
    final color = getBadgeColor(level);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  color.withAlpha(255),
                  color.withAlpha(178),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: color.withAlpha(204), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
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
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildStatCard(
                  icon: FluentIcons.flag_20_filled,
                  label: 'Countries',
                  value: countriesCount.toString(),
                  context: context,
                  onTap: () => _openDetailScreen('countries'),
                ),
                _buildStatCard(
                  icon: FluentIcons.globe_20_filled,
                  label: 'Continents',
                  value: continentsCount.toString(),
                  context: context,
                  onTap: () => _openDetailScreen('continents'),
                ),
                _buildStatCard(
                  icon: FluentIcons.location_20_filled,
                  label: 'Subregions',
                  value: subregionsCount.toString(),
                  context: context,
                  onTap: () => _openDetailScreen('subregions'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTransportBadge(
                  label: 'Land',
                  icon: FluentIcons.vehicle_car_20_filled,
                  usedVehicles: userUsedVehicles,
                  allVehicles: landVehicles,
                  onTap: () => _showVehiclePicker(landVehicles, 'Land'),
                ),
                buildTransportBadge(
                  label: 'Sea',
                  icon: FluentIcons.vehicle_ship_20_filled,
                  usedVehicles: userUsedVehicles,
                  allVehicles: seaVehicles,
                  onTap: () => _showVehiclePicker(seaVehicles, 'Sea'),
                ),
                buildTransportBadge(
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
