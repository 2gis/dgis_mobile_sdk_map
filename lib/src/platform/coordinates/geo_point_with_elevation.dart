import '../../generated/dart_bindings.dart' as sdk;

extension GeoPointWithElevationMethods on sdk.GeoPointWithElevation {
  sdk.GeoPoint get point {
    return sdk.GeoPoint(latitude: latitude, longitude: longitude);
  }

  /// Вычисляет направление (путевой угол, т.е. угол между направлением на географический север и направлением
  /// движения, отсчитываемый по часовой стрелке) для проекции точки на карту и заданной точкой.
  sdk.Bearing bearing(sdk.GeoPoint point) {
    return sdk.calculateBearing(this.point, point);
  }

  /// Вычисляет минимальное (по ортодромии) расстояние между двумя точками.
  sdk.Meter distance(sdk.GeoPoint point) {
    final meters = sdk.calculateDistance(this.point, point);
    return sdk.Meter(meters);
  }

  /// Вычисляет точку, полученную перемещением исходной точки в указанном направлении на указанное расстояние.
  sdk.GeoPointWithElevation move(sdk.Bearing bearing, sdk.Meter meter) {
    final pointTo = sdk.move(point, bearing, meter.value);
    return sdk.GeoPointWithElevation(
      latitude: pointTo.latitude,
      longitude: pointTo.longitude,
      elevation: elevation,
    );
  }
}
