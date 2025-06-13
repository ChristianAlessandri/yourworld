import 'dart:convert';

import 'package:flutter/services.dart' show Color, rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:yourworld/core/constants/app_paths.dart';
import 'package:yourworld/models/country.dart';
import 'package:yourworld/models/country_status.dart';

class CountryService {
  final Box<Country> countriesBox;

  final Map<String, List<Polygon>> countryPolygons = {};
  final Map<String, String> nameToIsoMap = {};
  final Map<String, String> isoToNameMap = {};

  CountryService({required this.countriesBox});

  Future<void> loadCountriesFromGeoJson() async {
    final jsonString = await rootBundle.loadString(AppPaths.countriesGeoJson);
    final geoJson = jsonDecode(jsonString);
    final features = geoJson['features'] as List;

    countryPolygons.clear();
    nameToIsoMap.clear();
    isoToNameMap.clear();

    for (var feature in features) {
      final props = feature['properties'] ?? {};
      final countryName = props['admin'];
      String? iso = props['iso_a2'];

      if (countryName != null &&
          (countryName == 'Taiwan' || countryName.contains('Taiwan'))) {
        iso = 'TW';
      }

      if (iso == '-99' || iso == null) {
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

    await _initializeCountriesWithNone();
  }

  Future<void> _initializeCountriesWithNone() async {
    if (countriesBox.isEmpty) {
      for (var countryName in countryPolygons.keys) {
        final iso = nameToIsoMap[countryName];
        if (iso != null) {
          await countriesBox
              .add(Country(isoA2: iso, status: CountryStatus.none));
        }
      }
    }
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

  Polygon _createPolygonFromCoords(List coords) {
    final outerRing = coords[0] as List;
    final points = outerRing
        .map<LatLng>(
            (coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
        .toList();

    return Polygon(
      points: points,
      color: const Color(0xFF000000),
      borderColor: const Color(0xFF000000),
      borderStrokeWidth: 1.0,
    );
  }
}
