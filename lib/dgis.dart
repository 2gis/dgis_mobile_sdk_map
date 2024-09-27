// TODO: написать док коммент для библиотеки
// ignore: unnecessary_library_directive
library dgis_mobile_sdk;

export 'src/generated/dart_bindings.dart'
    hide
        ApplicationState,
        BaseCameraInternalMethods,
        ImageLoader,
        LocaleChangeNotifier,
        MapBuilder,
        MapGestureRecognizer,
        MapInternalMethods,
        MapRenderer,
        MapSurfaceProvider,
        PlatformLocaleManager,
        ProductType,
        calculateBearing,
        calculateDistance,
        createImage,
        downloadData,
        makeSystemContext,
        move,
        toLocaleManager;
export 'src/generated/native_exception.dart';
export 'src/platform/coordinates/geo_point.dart';
export 'src/platform/coordinates/geo_point_with_elevation.dart';
export 'src/platform/dgis.dart';
export 'src/platform/map/image_loader.dart';
export 'src/platform/map/map_appearance.dart';
export 'src/platform/map/map_options.dart';
export 'src/platform/map/map_theme.dart';
export 'src/platform/map/touch_events_observer.dart';
export 'src/widgets/directory/search.dart'
    show DgisSearchWidget, SearchResultBuilder;
export 'src/widgets/either.dart';
export 'src/widgets/map/base_map_state.dart' show BaseMapWidgetState;
export 'src/widgets/map/compass_widget.dart';
export 'src/widgets/map/indoor_widget.dart';
export 'src/widgets/map/map_widget.dart' show MapWidget, MapWidgetController;
export 'src/widgets/map/map_widget_color_scheme.dart';
export 'src/widgets/map/my_location_widget.dart';
export 'src/widgets/map/themed_map_controlling_widget.dart';
export 'src/widgets/map/themed_map_controlling_widget_state.dart';
export 'src/widgets/map/traffic_widget.dart';
export 'src/widgets/map/zoom_widget.dart'
    show ZoomWidget, ZoomWidgetColorScheme;
