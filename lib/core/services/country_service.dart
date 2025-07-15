import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:yourworld/core/constants/app_paths.dart';
import 'package:yourworld/models/country.dart';
import 'package:yourworld/models/country_status.dart';

class CountryService {
  final Box<Country> countriesBox;

  final Map<String, List<Polygon>> countryPolygons = {};
  final Map<String, Country> countriesByIso = {};

  CountryService({required this.countriesBox});

  Future<void> loadCountriesFromGeoJson() async {
    final jsonString = await rootBundle.loadString(AppPaths.countriesGeoJson);
    final geoJson = jsonDecode(jsonString);
    final features = geoJson['features'] as List;

    countryPolygons.clear();
    countriesByIso.clear();

    for (var feature in features) {
      final props = feature['properties'] ?? {};
      final countryName = props['admin'] as String?;
      String? iso = props['iso_a2'] as String?;
      final continent = props['continent'] as String? ?? '';
      final subregion = props['subregion'] as String? ?? '';

      if (countryName != null &&
          (countryName == 'Taiwan' || countryName.contains('Taiwan'))) {
        iso = 'TW';
      }

      if (iso == '-99' || iso == null) {
        final isoA3 = props['iso_a3'] as String?;
        iso = _convertIsoA3ToA2(isoA3) ?? _sanitizeIsoFromName(countryName);
      }

      if (countryName == null || iso == null) continue;

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

      countryPolygons[iso] = polygons;

      countriesByIso[iso] = Country(
        isoA2: iso,
        name: countryName,
        continent: continent,
        subregion: subregion,
      );
    }

    await _initializeCountriesWithNone();
  }

  Future<void> _initializeCountriesWithNone() async {
    if (countriesBox.isEmpty) {
      for (var country in countriesByIso.values) {
        await countriesBox.add(Country(
          isoA2: country.isoA2,
          name: country.name,
          continent: country.continent,
          subregion: country.subregion,
          status: CountryStatus.none,
        ));
      }
    } else {
      // If is not empty, update existing countries
      for (var country in countriesBox.values) {
        final data = countriesByIso[country.isoA2];
        if (data != null) {
          country.name = data.name;
          country.continent = data.continent;
          country.subregion = data.subregion;
          await country.save();
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
      color: Colors.transparent,
      borderColor: Colors.transparent,
      borderStrokeWidth: 1.0,
    );
  }

  Future<Map<String, dynamic>?> fetchCountryDetails(String isoA2) async {
    final url = Uri.parse('https://restcountries.com/v3.1/alpha/$isoA2');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.isNotEmpty ? data[0] : null;
    } else {
      return null;
    }
  }
}
