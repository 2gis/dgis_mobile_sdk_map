import 'package:dgis_mobile_sdk_map/dgis.dart' as sdk;

typedef CameraPath = List<
    (sdk.CameraPosition position, Duration time, sdk.CameraAnimationType type)>;

enum CameraPathType { moscowDefault, dubaiImmersiveFlight, dubaiMallFlight }

final Map<CameraPathType, CameraPath> cameraPaths = {
  CameraPathType.moscowDefault: <(
    sdk.CameraPosition position,
    Duration time,
    sdk.CameraAnimationType type
  )>[
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(55.759909),
          longitude: sdk.Longitude(37.618806),
        ),
        zoom: sdk.Zoom(15),
        tilt: sdk.Tilt(15),
        bearing: sdk.Bearing(115),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(55.746962),
          longitude: sdk.Longitude(37.643073),
        ),
        zoom: sdk.Zoom(16),
        tilt: sdk.Tilt(55),
      ),
      const Duration(seconds: 9),
      sdk.CameraAnimationType.showBothPositions,
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(55.746962),
          longitude: sdk.Longitude(37.643073),
        ),
        zoom: sdk.Zoom(16.5),
        tilt: sdk.Tilt(45),
        bearing: sdk.Bearing(40),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear,
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(55.752425),
          longitude: sdk.Longitude(37.613983),
        ),
        zoom: sdk.Zoom(16),
        tilt: sdk.Tilt(25),
        bearing: sdk.Bearing(85),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
  ],
  CameraPathType.dubaiImmersiveFlight: <(
    sdk.CameraPosition position,
    Duration time,
    sdk.CameraAnimationType type
  )>[
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.236213145260663),
          longitude: sdk.Longitude(55.29931968078017),
        ),
        zoom: sdk.Zoom(17.9),
        tilt: sdk.Tilt(59),
        bearing: sdk.Bearing(130),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.23503475822966),
          longitude: sdk.Longitude(55.30102791264653),
        ),
        zoom: sdk.Zoom(18.396454),
        tilt: sdk.Tilt(60),
        bearing: sdk.Bearing(138.67406837919924),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.235042188578717),
          longitude: sdk.Longitude(55.29939528554678),
        ),
        zoom: sdk.Zoom(18.240969),
        tilt: sdk.Tilt(60),
        bearing: sdk.Bearing(252.85139373504663),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.234766810440377),
          longitude: sdk.Longitude(55.29980390332639),
        ),
        zoom: sdk.Zoom(17.9),
        tilt: sdk.Tilt(57),
        bearing: sdk.Bearing(330),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.234641403999944),
          longitude: sdk.Longitude(55.299516236409545),
        ),
        zoom: sdk.Zoom(17.5),
        tilt: sdk.Tilt(55),
        bearing: sdk.Bearing(15),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.228974399135552),
          longitude: sdk.Longitude(55.293875467032194),
        ),
        zoom: sdk.Zoom(18.048622),
        tilt: sdk.Tilt(55.110836),
        bearing: sdk.Bearing(32.35952383455281),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.228686041376136),
          longitude: sdk.Longitude(55.29333248734474),
        ),
        zoom: sdk.Zoom(17.202654),
        tilt: sdk.Tilt(52.78325),
        bearing: sdk.Bearing(32.35952383455281),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.227277832681466),
          longitude: sdk.Longitude(55.29350431635976),
        ),
        zoom: sdk.Zoom(17.03534),
        tilt: sdk.Tilt(50.82511),
        bearing: sdk.Bearing(99.4318722010513),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.227277832681466),
          longitude: sdk.Longitude(55.29350431635976),
        ),
        zoom: sdk.Zoom(17.03534),
        tilt: sdk.Tilt(50.82511),
        bearing: sdk.Bearing(99.4318722010513),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.225995553946248),
          longitude: sdk.Longitude(55.292065143585205),
        ),
        zoom: sdk.Zoom(17.157991),
        tilt: sdk.Tilt(51.933483),
        bearing: sdk.Bearing(173.8907969473518),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.216675784626034),
          longitude: sdk.Longitude(55.28231372125447),
        ),
        zoom: sdk.Zoom(16.991346),
        tilt: sdk.Tilt(58.743847),
        bearing: sdk.Bearing(214.2997023612303),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.21855828300758),
          longitude: sdk.Longitude(55.28217307291925),
        ),
        zoom: sdk.Zoom(16.948515),
        tilt: sdk.Tilt(58.26355),
        bearing: sdk.Bearing(326.7346701380984),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.217604411637197),
          longitude: sdk.Longitude(55.28364091180265),
        ),
        zoom: sdk.Zoom(17.065231),
        tilt: sdk.Tilt(56.600986),
        bearing: sdk.Bearing(88.85091196908273),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.217908871751177),
          longitude: sdk.Longitude(55.28248144313693),
        ),
        zoom: sdk.Zoom(17.963282),
        tilt: sdk.Tilt(57.660046),
        bearing: sdk.Bearing(153.648165304185),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.218712900613397),
          longitude: sdk.Longitude(55.28143144212663),
        ),
        zoom: sdk.Zoom(18.30254),
        tilt: sdk.Tilt(59.10093),
        bearing: sdk.Bearing(221.5413694476013),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.218712900613397),
          longitude: sdk.Longitude(55.28143144212663),
        ),
        zoom: sdk.Zoom(18.30254),
        tilt: sdk.Tilt(59.10093),
        bearing: sdk.Bearing(221.5413694476013),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.219328639203),
          longitude: sdk.Longitude(55.281034307554364),
        ),
        zoom: sdk.Zoom(17.978739),
        tilt: sdk.Tilt(60),
        bearing: sdk.Bearing(291.26680917454286),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.19552087049614),
          longitude: sdk.Longitude(55.27348338626325),
        ),
        zoom: sdk.Zoom(17.297209),
        tilt: sdk.Tilt(47.36454),
        bearing: sdk.Bearing(199.04663318978456),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.19777692060545),
          longitude: sdk.Longitude(55.27235861867666),
        ),
        zoom: sdk.Zoom(17.009499),
        tilt: sdk.Tilt(48.620678),
        bearing: sdk.Bearing(288.28687960193633),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.198761815275702),
          longitude: sdk.Longitude(55.27509866282344),
        ),
        zoom: sdk.Zoom(17.04467),
        tilt: sdk.Tilt(52.019707),
        bearing: sdk.Bearing(29.089324882599087),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
  ],
  CameraPathType.dubaiMallFlight: <(
    sdk.CameraPosition position,
    Duration time,
    sdk.CameraAnimationType type
  )>[
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.194082319043517),
          longitude: sdk.Longitude(55.280991056934),
        ),
        zoom: sdk.Zoom(19.093323),
        tilt: sdk.Tilt(57.192116),
        bearing: sdk.Bearing(342.34027269336525),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.196880830939435),
          longitude: sdk.Longitude(55.27838478796184),
        ),
        zoom: sdk.Zoom(19.09329),
        tilt: sdk.Tilt(57.192116),
        bearing: sdk.Bearing(342.34027269336525),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.198081961220097),
          longitude: sdk.Longitude(55.278184125199914),
        ),
        zoom: sdk.Zoom(19.81237),
        tilt: sdk.Tilt(58.706905),
        bearing: sdk.Bearing(109.13508482278154),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.19779565385268),
          longitude: sdk.Longitude(55.28052309527993),
        ),
        zoom: sdk.Zoom(19.812374),
        tilt: sdk.Tilt(58.706905),
        bearing: sdk.Bearing(109.13508482278154),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.197723678729133),
          longitude: sdk.Longitude(55.28058998286724),
        ),
        zoom: sdk.Zoom(20.000002),
        tilt: sdk.Tilt(60),
        bearing: sdk.Bearing(245.8197139845185),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
    (
      const sdk.CameraPosition(
        point: sdk.GeoPoint(
          latitude: sdk.Latitude(25.197278782026558),
          longitude: sdk.Longitude(55.279244016855955),
        ),
        zoom: sdk.Zoom(19.993673),
        tilt: sdk.Tilt(59.667492),
        bearing: sdk.Bearing(267.18760563306654),
      ),
      const Duration(seconds: 4),
      sdk.CameraAnimationType.linear
    ),
  ],
};
