import 'dart:convert';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:yourworld/core/constants/app_buttons.dart';
import 'package:yourworld/core/constants/app_colors.dart';
import 'package:yourworld/core/constants/app_dropdown.dart';
import 'package:yourworld/core/hive/app_hive.dart';
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

  final Map<String, List<Polygon>> countryPolygons = {};
  final Map<CountryStatus, List<Polygon>> polygonsByStatus = {
    CountryStatus.visited: [],
    CountryStatus.lived: [],
    CountryStatus.want: [],
  };

  List<Country> visitedCountries = [];
  bool isLoaded = false;
  Map<String, String> nameToIsoMap = {};
  Map<String, String> isoToNameMap = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadGeoJson();
    await _initializeCountriesWithNone();
    _loadUserCountriesData();
  }

  String? _convertIsoA3ToA2(String? isoA3) {
    if (isoA3 == null) return null;

    const isoA3toA2 = {
      'FRA': 'FR',
      'NOR': 'NO',
      'SOM': 'SO',
      'XKX': 'XK', // Kosovo
      'PSE': 'PS',
      'SSD': 'SS',
      'VAT': 'VA',
      'NAM': 'NA',
      'KOR': 'KR',
      'PRK': 'KP',
      'TWN': 'TW',
    };

    return isoA3toA2[isoA3];
  }

  String? _sanitizeIsoFromName(String? name) {
    if (name == null) return null;

    const nameToIso = {
      'France': 'FR',
      'Norway': 'NO',
      'Somalia': 'SO',
      'Kosovo': 'XK',
      'Palestine': 'PS',
      'South Sudan': 'SS',
      'Vatican': 'VA',
      'Namibia': 'NA',
      'North Korea': 'KP',
      'South Korea': 'KR',
      'Taiwan': 'TW',
    };

    return nameToIso[name];
  }

  Future<void> _loadGeoJson() async {
    final jsonString =
        await rootBundle.loadString('assets/geo/countries.geo.json');
    final geoJson = jsonDecode(jsonString);
    final features = geoJson['features'] as List;

    for (var feature in features) {
      final props = feature['properties'] ?? {};
      final countryName = props['admin'];
      String? iso = props['iso_a2'];

      // Taiwan fallback
      if (countryName != null &&
          (countryName == 'Taiwan' || countryName.contains('Taiwan'))) {
        iso = 'TW';
      }

      if (iso == '-99' || iso == null) {
        // Fallback on iso_a3
        final isoA3 = props['iso_a3'];
        iso = _convertIsoA3ToA2(isoA3) ?? _sanitizeIsoFromName(countryName);
      }

      if (countryName == null || iso == null) continue;

      nameToIsoMap[countryName] = iso;
      isoToNameMap[iso] = countryName;

      final geometry = feature['geometry'];
      final type = geometry['type'];
      final coordinates = geometry['coordinates'];

      final polygons = <Polygon>[];

      if (type == 'Polygon') {
        polygons.add(_createPolygonFromCoords(coordinates));
      } else if (type == 'MultiPolygon') {
        for (var poly in coordinates) {
          polygons.add(_createPolygonFromCoords(poly));
        }
      }

      countryPolygons[countryName] = polygons;
    }

    setState(() {
      isLoaded = true;
      _selectCountries();
    });
  }

  Future<void> _initializeCountriesWithNone() async {
    final box = AppHive.countriesBox;
    if (box.isEmpty) {
      for (var countryName in countryPolygons.keys) {
        final iso = nameToIsoMap[countryName];
        if (iso != null) {
          box.add(Country(isoA2: iso, status: CountryStatus.none));
        }
      }
    }
  }

  void _loadUserCountriesData() {
    final box = AppHive.countriesBox;
    visitedCountries = box.values.cast<Country>().toList();
  }

  void _saveUserCountriesData(Map<String, CountryStatus> isoStatusMap) {
    final box = AppHive.countriesBox;

    for (var country in box.values) {
      country.status = CountryStatus.none;
      country.save();
    }

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
      final name = isoToNameMap[country.isoA2];
      if (name != null && countryPolygons.containsKey(name)) {
        final color = _getColorForStatus(country.status);
        final basePolygons = countryPolygons[name]!;

        final coloredPolygons = basePolygons
            .map((p) => Polygon(
                  points: p.points,
                  color: color,
                  borderColor: Colors.black,
                  borderStrokeWidth: 1.0,
                ))
            .toList();

        polygonsByStatus[country.status]?.addAll(coloredPolygons);
      }
    }

    setState(() {});
  }

  Polygon _createPolygonFromCoords(List coords) {
    final outerRing = coords[0] as List;
    final points = outerRing
        .map<LatLng>(
            (coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
        .toList();

    return Polygon(
      points: points,
      color: Colors.blue.withOpacity(0.5),
      borderColor: Colors.black,
      borderStrokeWidth: 1.0,
    );
  }

  Color _getColorForStatus(CountryStatus status) {
    switch (status) {
      case CountryStatus.visited:
        return Colors.blue.withOpacity(0.5);
      case CountryStatus.lived:
        return Colors.green.withOpacity(0.5);
      case CountryStatus.want:
        return Colors.orange.withOpacity(0.5);
      default:
        return Colors.transparent;
    }
  }

  void _showCountrySelector() {
    final allCountries = countryPolygons.keys.toList()..sort();
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
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    "Countries",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        child: Text(Utils.capitalize(status.name)),
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
                      final iso = nameToIsoMap[name]!;
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
                  userAgentPackageName: 'it.yourvibes.yourworld',
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
        backgroundColor: AppColors.darkBackground,
        onPressed: isLoaded ? _showCountrySelector : null,
        child: const Icon(
          FluentIcons.add_20_filled,
          color: AppColors.darkTextPrimary,
        ),
      ),
    );
  }
}
