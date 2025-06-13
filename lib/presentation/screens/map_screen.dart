import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:yourworld/core/constants/app_buttons.dart';
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
        box.add(Country(isoA2: iso, status: status));
      }
    }

    _loadUserCountriesData();
    _selectCountries();
  }

  void _selectCountries() {
    polygonsByStatus.updateAll((_, __) => []);

    for (var country in visitedCountries) {
      final name = countryService.isoToNameMap[country.isoA2];
      if (name != null && countryService.countryPolygons.containsKey(name)) {
        final color = _getColorForStatus(country.status);
        final basePolygons = countryService.countryPolygons[name]!;

        final coloredPolygons = basePolygons
            .map((p) => Polygon(
                  points: p.points,
                  color: color,
                  borderColor: Colors.transparent,
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
    final allCountries = countryService.countryPolygons.keys.toList()..sort();
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
                    children: allCountries.map((name) {
                      final iso = countryService.nameToIsoMap[name]!;
                      final currentStatus = tempMap[iso];
                      final isSelected = currentStatus == selectedStatus;

                      return CheckboxListTile(
                        title: Text(name),
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
                    style: AppButtons(context).primary(),
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
              ),
              children: [
                TileLayer(
                  urlTemplate: UserSettingsManager.settings.mapUrlTemplate,
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: AppConstants.userAgentPackageName,
                  additionalOptions: {'scale': ''},
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
