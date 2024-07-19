import '../../generated/dart_bindings.dart' as sdk;

extension GeoPointMethods on sdk.GeoPoint {
  /// Вычисляет направление (путевой угол, т.е. угол между направлением на географический север и направлением
  /// движения, отсчитываемый по часовой стрелке) для проекции точки на карту и заданной точкой.
  sdk.Bearing bearing(sdk.GeoPoint point) {
    return sdk.calculateBearing(this, point);
  }

  /// Вычисляет минимальное (по ортодромии) расстояние между двумя точками.
  sdk.Meter distance(sdk.GeoPoint point) {
    final meters = sdk.calculateDistance(this, point);
    return sdk.Meter(meters);
  }

  /// Вычисляет точку, полученную перемещением исходной точки в указанном направлении на указанное расстояние.
  sdk.GeoPoint move(sdk.Bearing bearing, sdk.Meter meter) {
    return sdk.move(this, bearing, meter.value);
  }
}
