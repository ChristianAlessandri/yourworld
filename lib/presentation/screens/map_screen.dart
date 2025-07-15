import 'dart:ui';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:yourworld/core/constants/app_colors.dart';
import 'package:yourworld/core/constants/app_constants.dart';
import 'package:yourworld/core/constants/app_dropdown.dart';
import 'package:yourworld/core/constants/map_palettes.dart';
import 'package:yourworld/core/hive/app_hive.dart';
import 'package:yourworld/core/services/country_service.dart';
import 'package:yourworld/core/user_settings/user_settings_manager.dart';
import 'package:yourworld/core/utils/utils.dart';
import 'package:yourworld/models/country.dart';
import 'package:yourworld/models/country_status.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late final CountryService countryService;

  final Map<CountryStatus, List<Polygon>> polygonsByStatus = {
    CountryStatus.visited: [],
    CountryStatus.lived: [],
    CountryStatus.want: [],
  };

  List<Country> visitedCountries = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    countryService = CountryService(countriesBox: AppHive.countriesBox);
    _init();
  }

  Future<void> _init() async {
    await countryService.loadCountriesFromGeoJson();

    visitedCountries =
        countryService.countriesBox.values.cast<Country>().toList();

    _selectCountries();

    setState(() {
      isLoaded = true;
    });
  }

  void _loadUserCountriesData() {
    visitedCountries =
        countryService.countriesBox.values.cast<Country>().toList();
  }

  void _saveUserCountriesData(Map<String, CountryStatus> isoStatusMap) {
    final box = countryService.countriesBox;

    // Reset all statuses
    for (var country in box.values) {
      country.status = CountryStatus.none;
      country.save();
    }

    // Update statuses from isoStatusMap
    for (var entry in isoStatusMap.entries) {
      final iso = entry.key;
      final status = entry.value;

      final existing = box.values.cast<Country?>().firstWhere(
            (c) => c?.isoA2 == iso,
            orElse: () => null,
          );

      if (existing != null) {
        existing.status = status;
        existing.save();
      } else {
        final countryInfo = countryService.countriesByIso[iso];

        if (countryInfo != null) {
          box.add(Country(
            isoA2: iso,
            name: countryInfo.name,
            continent: countryInfo.continent,
            subregion: countryInfo.subregion,
            status: status,
          ));
        }
      }
    }

    _loadUserCountriesData();
    _selectCountries();
  }

  void _selectCountries() {
    polygonsByStatus.updateAll((_, __) => []);

    for (var country in visitedCountries) {
      final polygons = countryService.countryPolygons[country.isoA2];
      if (polygons != null) {
        final color = _getColorForStatus(country.status);

        final coloredPolygons = polygons
            .map((p) => Polygon(
                  points: p.points,
                  color: color,
                  borderColor: AppColors.darkBackground,
                  borderStrokeWidth: 1.0,
                ))
            .toList();

        polygonsByStatus[country.status]?.addAll(coloredPolygons);
      }
    }

    setState(() {});
  }

  Color _getColorForStatus(CountryStatus status) {
    final paletteKey = UserSettingsManager.settings.mapTheme;
    final palette = MapPalettes.getPalette(paletteKey);

    switch (status) {
      case CountryStatus.visited:
        return palette.visited;
      case CountryStatus.lived:
        return palette.lived;
      case CountryStatus.want:
        return palette.want;
      default:
        return Colors.transparent;
    }
  }

  void _showCountrySelector() {
    final allCountries = countryService.countriesByIso.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    Map<String, CountryStatus> tempMap = {
      for (var c in visitedCountries) c.isoA2: c.status
    };

    CountryStatus selectedStatus = CountryStatus.visited;

    showModalBottomSheet(
      context: scaffoldKey.currentContext!,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSurface
          : AppColors.lightSurface,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    "Countries",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: AppDropdown.themedDropdown<CountryStatus>(
                    context: context,
                    value: selectedStatus,
                    items: CountryStatus.values
                        .where((status) => status != CountryStatus.none)
                        .map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(Utils.capitalize(status.name),
                            style: Theme.of(context).textTheme.bodyMedium),
                      );
                    }).toList(),
                    onChanged: (newStatus) {
                      setModalState(() {
                        if (newStatus != null) selectedStatus = newStatus;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: allCountries.map((country) {
                      final iso = country.isoA2;
                      final currentStatus = tempMap[iso];
                      final isSelected = currentStatus == selectedStatus;

                      return CheckboxListTile(
                        title: Text(country.name,
                            style: Theme.of(context).textTheme.bodyMedium),
                        value: isSelected,
                        onChanged: (bool? checked) {
                          setModalState(() {
                            if (checked == true) {
                              tempMap[iso] = selectedStatus;
                            } else if (currentStatus == selectedStatus) {
                              tempMap.remove(iso);
                            }
                          });
                        },
                        secondary: Image.asset(
                          'icons/flags/png100px/${iso.toLowerCase()}.png',
                          package: 'country_icons',
                          width: 32,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _saveUserCountriesData(tempMap);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleMapTap(TapPosition tapPosition, LatLng latlng) {
    for (var entry in countryService.countryPolygons.entries) {
      final iso = entry.key;
      final polygons = entry.value;

      for (var polygon in polygons) {
        if (_pointInPolygon(latlng, polygon.points)) {
          final country = countryService.countriesByIso[iso];
          if (country != null) {
            _showCountryStatusPicker(country);
            return;
          }
        }
      }
    }
  }

  bool _pointInPolygon(LatLng point, List<LatLng> polygon) {
    int i, j = polygon.length - 1;
    bool oddNodes = false;

    for (i = 0; i < polygon.length; i++) {
      if ((polygon[i].latitude < point.latitude &&
                  polygon[j].latitude >= point.latitude ||
              polygon[j].latitude < point.latitude &&
                  polygon[i].latitude >= point.latitude) &&
          (polygon[i].longitude <= point.longitude ||
              polygon[j].longitude <= point.longitude)) {
        if (polygon[i].longitude +
                (point.latitude - polygon[i].latitude) /
                    (polygon[j].latitude - polygon[i].latitude) *
                    (polygon[j].longitude - polygon[i].longitude) <
            point.longitude) {
          oddNodes = !oddNodes;
        }
      }
      j = i;
    }

    return oddNodes;
  }

  void _showCountryStatusPicker(Country country) async {
    final details = await countryService.fetchCountryDetails(country.isoA2);
    int selectedTab = 0; // 0 = status, 1 = info

    showModalBottomSheet(
      context: scaffoldKey.currentContext!,
      backgroundColor:
          Theme.of(scaffoldKey.currentContext!).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        final flagUrl = details?['flags']?['png'];
        final capital = (details?['capital'] as List?)?.join(', ') ?? 'N/A';
        final population = details?['population']?.toString() ?? 'N/A';
        final region = details?['region'] ?? 'N/A';
        final subregion = details?['subregion'] ?? 'N/A';
        final currencies = details?['currencies'] as Map<String, dynamic>?;
        String currencyInfo = 'N/A';
        if (currencies != null && currencies.isNotEmpty) {
          final currency = currencies.values.first;
          currencyInfo = '${currency['name']} (${currency['symbol'] ?? 'N/A'})';
        }
        final languages = details?['languages'] as Map<String, dynamic>?;
        String languagesInfo = 'N/A';
        if (languages != null && languages.isNotEmpty) {
          languagesInfo = languages.values.join(', ');
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (flagUrl != null)
                        Image.network(flagUrl, width: 48, height: 36),
                      const SizedBox(width: 8),
                      Text(
                        country.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: selectedTab == 0
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.2)
                                : Colors.transparent,
                          ),
                          onPressed: () => setState(() => selectedTab = 0),
                          child: const Text('Status'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: selectedTab == 1
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.2)
                                : Colors.transparent,
                          ),
                          onPressed: () => setState(() => selectedTab = 1),
                          child: const Text('Info'),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: selectedTab == 0
                      ? _buildStatusOptions(context, country)
                      : _buildCountryInfo(
                          context,
                          capital,
                          population,
                          region,
                          subregion,
                          currencyInfo,
                          languagesInfo,
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatusOptions(BuildContext context, Country country) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(FluentIcons.checkbox_checked_20_filled),
          title: const Text('Visited'),
          onTap: () {
            _setCountryStatus(country, CountryStatus.visited);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(FluentIcons.home_20_filled),
          title: const Text('Lived'),
          onTap: () {
            _setCountryStatus(country, CountryStatus.lived);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(FluentIcons.heart_20_filled),
          title: const Text('Want'),
          onTap: () {
            _setCountryStatus(country, CountryStatus.want);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(FluentIcons.border_none_20_regular),
          title: const Text('None'),
          onTap: () {
            _setCountryStatus(country, CountryStatus.none);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildCountryInfo(
    BuildContext context,
    String capital,
    String population,
    String region,
    String subregion,
    String currency,
    String languages,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: const Text("Capital"),
          subtitle: Text(capital),
        ),
        ListTile(
          title: const Text("Population"),
          subtitle: Text(population),
        ),
        ListTile(
          title: const Text("Region"),
          subtitle: Text('$region • $subregion'),
        ),
        ListTile(
          title: const Text("Currency"),
          subtitle: Text(currency),
        ),
        ListTile(
          title: const Text("Official Languages"),
          subtitle: Text(languages),
        ),
      ],
    );
  }

  void _setCountryStatus(Country country, CountryStatus status) {
    final existing = countryService.countriesBox.values
        .cast<Country?>()
        .firstWhere((c) => c?.isoA2 == country.isoA2, orElse: () => null);

    if (existing != null) {
      existing.status = status;
      existing.save();
    } else {
      countryService.countriesBox.add(Country(
        isoA2: country.isoA2,
        name: country.name,
        continent: country.continent,
        subregion: country.subregion,
        status: status,
      ));
    }

    _loadUserCountriesData();
    _selectCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: isLoaded
          ? FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(20.0, 0.0),
                initialZoom: 3,
                minZoom: 1,
                maxZoom: 10,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
                cameraConstraint: CameraConstraint.contain(
                  bounds: LatLngBounds(
                    LatLng(-90.0, -180.0),
                    LatLng(90.0, 180.0),
                  ),
                ),
                crs: Epsg3857(),
                onTap: _handleMapTap,
              ),
              children: [
                TileLayer(
                  urlTemplate: UserSettingsManager.settings.mapUrlTemplate,
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: AppConstants.userAgentPackageName,
                  additionalOptions: {'scale': ''},
                  tileProvider: NetworkTileProvider(),
                ),
                ...polygonsByStatus.entries.map(
                  (entry) => PolygonLayer(polygons: entry.value),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        onPressed: isLoaded ? _showCountrySelector : null,
        child: Icon(
          FluentIcons.add_20_filled,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
    );
  }
}
