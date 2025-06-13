class MapUrlTemplates {
  static const openStreetMap =
      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const cartoLight =
      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{scale}.png';
  static const cartoLightNoLabels =
      'https://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}{scale}.png';
  static const cartoDark =
      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{scale}.png';
  static const cartoDarkNoLabels =
      'https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{scale}.png';
  static const cartoVoyager =
      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{scale}.png';

  static const all = [
    openStreetMap,
    cartoLight,
    cartoLightNoLabels,
    cartoDark,
    cartoDarkNoLabels,
    cartoVoyager
  ];

  static const names = [
    'OpenStreetMap',
    'Carto Light',
    'Carto Light No Labels',
    'Carto Dark',
    'Carto Dark No Labels',
    'Carto Voyager',
  ];
}
