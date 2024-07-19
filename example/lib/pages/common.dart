import 'dart:async';

import 'package:dgis_mobile_sdk_map/dgis.dart' as sdk;
import 'package:permission_handler/permission_handler.dart';

Future<void> checkLocationPermissions(
  sdk.LocationService locationService,
) async {
  final permission = await Permission.location.request();
  if (permission.isGranted) {
    locationService.onPermissionGranted();
  }
}
