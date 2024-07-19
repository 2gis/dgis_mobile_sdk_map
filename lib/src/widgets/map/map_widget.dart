import 'dart:async';
import 'dart:ui' as ui;

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../generated/dart_bindings.dart' as sdk;
import '../../generated/native_exception.dart';
import '../../generated/stateful_channel.dart';
import '../../platform/map/map.dart';
import '../../platform/map/map_appearance.dart';
import '../../platform/map/map_options.dart';
import '../../platform/map/map_theme.dart';
import '../../platform/map/touch_events_observer.dart';
import 'copyright_widget.dart';

typedef OnMapReadyCallback = void Function(sdk.Map map);
typedef OnMapThemeChangedCallback = void Function(MapTheme theme);
typedef MapObjectTappedCallback = void Function(
  sdk.RenderedObjectInfo objectInfo,
);

/// Контроллер для работы с картой.
class MapWidgetController {
  final List<OnMapReadyCallback> _readyMapCallbacks = [];
  final List<OnMapThemeChangedCallback> _mapThemeChangedCallbacks = [];
  final List<MapObjectTappedCallback> _objectTappedCallbacks = [];
  final List<MapObjectTappedCallback> _objectLongTouchCallbacks = [];
  final List<StreamSubscription<dynamic>?> _connections = [];
  final CopyrightWidgetController _copyrightWidgetController =
      CopyrightWidgetController();
  sdk.Map? _map;
  sdk.MapSurfaceProvider? _provider;
  sdk.MapRenderer? _renderer;
  MapAppearance _appearance = const AutomaticAppearance(
    MapTheme.defaultDayTheme(),
    MapTheme.defaultNightTheme(),
  );
  sdk.Fps? _maxFps;
  sdk.Fps? _powerSavingMaxFps;
  sdk.MapGestureRecognizer? _mapGestureRecognizer;
  TouchEventsObserver? _touchEventsObserver;

  /// Внешний вид карты в зависимости от окружения.
  MapAppearance get appearance => _appearance;
  set appearance(MapAppearance value) {
    if (_appearance != value) {
      _appearance = value;
      _updateMapTheme();
    }
  }

  /// Частота обновления карты.
  /// Для получения корректного значения необходимо держать подписку на канал.
  /// Перед вызовом метода карта должна быть проинициализирована (завершен getMapAsync).
  StatefulChannel<sdk.Fps> get fpsChannel {
    if (_renderer == null) {
      throw NativeException(
        'Map must be initialized (getMapAsync completed) before getting MapView.fpsChannel',
      );
    }
    return _renderer!.fpsChannel;
  }

  /// Максимальный FPS карты.
  sdk.Fps? get maxFps => _maxFps;
  set maxFps(sdk.Fps? value) {
    if (_maxFps != value) {
      _maxFps = value;
      _updateRendererFps();
    }
  }

  /// Максимальный FPS карты в режиме энергосбережения.
  sdk.Fps? get powerSavingMaxFps => _powerSavingMaxFps;
  set powerSavingMaxFps(sdk.Fps? value) {
    if (_powerSavingMaxFps != value) {
      _powerSavingMaxFps = value;
      _updateRendererFps();
    }
  }

  /// Отступы для позиционирования копирайта.
  EdgeInsets get copyrightEdgeInsets =>
      _copyrightWidgetController.copyrightAlignment.value.edgeInsets;
  set copyrightEdgeInsets(EdgeInsets insets) {
    _copyrightWidgetController.copyrightAlignment.value =
        _copyrightWidgetController.copyrightAlignment.value
            .copyWith(edgeInsets: insets);
  }

  /// Позиция копирайта на экране.
  Alignment get copyrightAlignment =>
      _copyrightWidgetController.copyrightAlignment.value.alignment;
  set copyrightAlignment(Alignment value) {
    _copyrightWidgetController.copyrightAlignment.value =
        _copyrightWidgetController.copyrightAlignment.value
            .copyWith(alignment: value);
  }

  /// Класс для управления обработкой жестов.
  sdk.GestureManager? get gestureManager {
    if (_mapGestureRecognizer == null) {
      throw NativeException(
        'Map must be initialized (getMapAsync completed) before MapView.gestureManager',
      );
    }

    return _mapGestureRecognizer?.gestureManager;
  }

  /// Метод для установки функции обратного вызова при тапе в копирайт.
  void setUriOpener(UriOpener uriOpener) {
    _copyrightWidgetController.uriOpener = uriOpener;
  }

  /// Метод для добавления подписки на инициализацию Map.
  void getMapAsync(OnMapReadyCallback callback) {
    if (_map != null) {
      callback(_map!);
      return;
    }
    _readyMapCallbacks.add(callback);
  }

  void setTouchEventsObserver(TouchEventsObserver? observer) {
    if (_touchEventsObserver == observer) {
      return;
    }
    _touchEventsObserver = observer;
    _updateTouchEventObserver();
  }

  /// Метод для добавления подписки на тап в объект карты.
  void addObjectTappedCallback(MapObjectTappedCallback callback) {
    _objectTappedCallbacks.add(callback);
    _updateTouchEventObserver();
  }

  void removeObjectTappedCallback(MapObjectTappedCallback callback) {
    _objectTappedCallbacks.remove(callback);
    _updateTouchEventObserver();
  }

  /// Метод для добавления подписки на долгое нажатие на объект карты.
  void addObjectLongTouchCallback(MapObjectTappedCallback callback) {
    _objectLongTouchCallbacks.add(callback);
    _updateTouchEventObserver();
  }

  void removeLongTouchCallback(MapObjectTappedCallback callback) {
    _objectLongTouchCallbacks.remove(callback);
    _updateTouchEventObserver();
  }

  /// Метод для получения снэпшота карты.
  CancelableOperation<ByteData?> takeSnapshot({
    sdk.Alignment copyrightPosition = sdk.Alignment.bottomRight,
  }) {
    if (_renderer == null) {
      throw NativeException(
        'Map must be initialized (getMapAsync completed) before takeSnapshot',
      );
    }

    final completer = Completer<ByteData>();
    _renderer!.takeSnapshot(copyrightPosition).value.then(
      (imageData) {
        final buffer = imageData.data.buffer;
        final imageDataList = buffer.asUint8List(
          imageData.data.offsetInBytes,
          imageData.data.lengthInBytes,
        );
        final imageWidth = imageData.size.width;
        final imageHeight = imageData.size.height;
        ui.decodeImageFromPixels(
          imageDataList,
          imageWidth,
          imageHeight,
          ui.PixelFormat.rgba8888,
          (image) =>
              image.toByteData(format: ui.ImageByteFormat.png).then((value) {
            final buffer = value?.buffer;
            completer.complete(buffer == null ? null : ByteData.view(buffer));
          }),
        );
      },
    );
    return CancelableOperation.fromFuture(completer.future);
  }

  void _dispose() {
    _cancelConnections();
    _renderer = null;
    _provider = null;
    _map = null;
  }

  void _updateMapTheme() {
    final theme = _appearance.mapTheme;
    _map?.setTheme(theme);
    for (final cb in _mapThemeChangedCallbacks) {
      cb(theme);
    }
  }

  void _updateRendererFps() {
    _renderer?.setMaxFps(_maxFps, _powerSavingMaxFps);
  }

  void _addMapThemeChangedCallback(OnMapThemeChangedCallback callback) {
    _mapThemeChangedCallbacks.add(callback);
  }

  void _removeMapThemeChangedCallback(OnMapThemeChangedCallback callback) {
    _mapThemeChangedCallbacks.remove(callback);
  }

  void _updateTouchEventObserver() {
    if (_mapGestureRecognizer == null) {
      return;
    }

    if (_touchEventsObserver == null &&
        _objectTappedCallbacks.isEmpty &&
        _objectLongTouchCallbacks.isEmpty) {
      _cancelConnections();
      return;
    }

    if (_connections.isNotEmpty) {
      return;
    }

    _connections
      ..add(
        _mapGestureRecognizer?.tap.listen(
          (point) {
            _touchEventsObserver?.onTap(point);
            _callMapObjectCallbacks(point, _objectTappedCallbacks);
          },
        ),
      )
      ..add(
        _mapGestureRecognizer?.longTouch.listen(
          (point) {
            _touchEventsObserver?.onLongTouch(point);
            _callMapObjectCallbacks(point, _objectLongTouchCallbacks);
          },
        ),
      )
      ..add(
        _mapGestureRecognizer?.dragBegin.listen(
          (dragBeginData) {
            _touchEventsObserver?.onDragBegin(dragBeginData);
          },
        ),
      )
      ..add(
        _mapGestureRecognizer?.dragMove.listen(
          (point) {
            _touchEventsObserver?.onDragMove(point);
          },
        ),
      )
      ..add(
        _mapGestureRecognizer?.dragEnd.listen(
          (result) {
            _touchEventsObserver?.onDragEnd();
          },
        ),
      );
  }

  Future<void> _cancelConnections() async {
    for (final connection in _connections) {
      await connection?.cancel();
    }
    _connections.clear();
  }

  Future<void> _callMapObjectCallbacks(
    sdk.ScreenPoint point,
    List<MapObjectTappedCallback> callbacks,
  ) async {
    if (callbacks.isEmpty) {
      return;
    }
    await _map
        ?.getMapObject(point, const sdk.ScreenDistance(1))
        .value
        .then((objectInfo) {
      if (objectInfo != null) {
        for (final callback in callbacks) {
          callback(objectInfo);
        }
      }
    });
  }
}

/// Widget для работы с картой.
class MapWidget extends StatefulWidget {
  final sdk.Context _sdkContext;
  final MapOptions _mapOptions;
  final MapWidgetController? _controller;
  final Widget? child;

  // Не можем использовать const конструктор тут, т.к.
  // некоторые из параметров – обертки над нативными объектами,
  // и для них это неприменимо
  // ignore: prefer_const_constructors_in_immutables
  MapWidget({
    required sdk.Context sdkContext,
    required MapOptions mapOptions,
    MapWidgetController? controller,
    this.child,
    super.key,
  })  : _sdkContext = sdkContext,
        _mapOptions = mapOptions,
        _controller = controller;

  MapOptions get mapOptions => _mapOptions;

  @override
  MapWidgetState createState() => MapWidgetState();
}

class _TextureController {
  static const MethodChannel _channel =
      MethodChannel('flutter_map_surface_plugin');

  Future<int?> initialize(int mapSurfaceId) async {
    return _channel.invokeMethod('setSurface', {'mapSurfaceId': mapSurfaceId});
  }

  void update(int textureId, int width, int height) {
    _channel.invokeMethod('updateSurface', {
      'textureId': textureId,
      'width': width,
      'height': height,
    });
  }

  void dispose(int textureId) {
    _channel.invokeMethod('dispose', {'textureId': textureId});
  }
}

typedef OnWidgetSizeChange = void Function(Size size);

class _MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  OnWidgetSizeChange onChange;

  _MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    final newSize = child?.size;
    if (newSize == null || oldSize == newSize) {
      return;
    }

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class _MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const _MeasureSize({
    required this.onChange,
    required Widget super.child,
    // ignore: unused_element
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _MeasureSizeRenderObject renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class _TouchPoint {
  final int _id;
  sdk.ScreenPoint _position;
  sdk.TouchPointState _state;

  _TouchPoint(this._id, this._position, this._state);
}

class _MapGestureController {
  final sdk.MapGestureRecognizer _mapGestureRecognizer;
  final double _deviceDensity;
  final _touchPoints = <_TouchPoint>[];

  _MapGestureController(this._mapGestureRecognizer, this._deviceDensity);

  void onPointerDownCallback(PointerDownEvent event) {
    _addTouchPoint(event, sdk.TouchPointState.pressed);
    _processPoints(event.timeStamp);
  }

  void onPointerMoveCallback(PointerMoveEvent event) {
    _addTouchPoint(event, sdk.TouchPointState.moved);
    _processPoints(event.timeStamp);
  }

  void onPointerUpCallback(PointerUpEvent event) {
    _addTouchPoint(event, sdk.TouchPointState.released);
    _processPoints(event.timeStamp);
  }

  void onPointerCancelCallback(PointerCancelEvent event) {
    _touchPoints.clear();
    _mapGestureRecognizer.cancel();
  }

  void _addTouchPoint(PointerEvent event, sdk.TouchPointState state) {
    final poisition = _getScreenPoint(event);
    final touchPoint =
        _touchPoints.where((element) => element._id == event.pointer);
    if (touchPoint.isEmpty) {
      _touchPoints.add(_TouchPoint(event.pointer, poisition, state));
    } else {
      touchPoint.first._position = poisition;
      touchPoint.first._state = state;
    }
  }

  void _processPoints(Duration timeStamp) {
    for (final point in _touchPoints) {
      _mapGestureRecognizer.addTouchPoint(
        point._position,
        point._state,
        point._id,
      );
      if (point._state == sdk.TouchPointState.pressed) {
        point._state = sdk.TouchPointState.moved;
      }
    }
    _mapGestureRecognizer.processTouchEvent(timeStamp);
    _touchPoints.removeWhere(
      (element) => element._state == sdk.TouchPointState.released,
    );
  }

  sdk.ScreenPoint _getScreenPoint(PointerEvent event) {
    return sdk.ScreenPoint(
      x: event.localPosition.dx * _deviceDensity,
      y: event.localPosition.dy * _deviceDensity,
    );
  }
}

class MapWidgetState extends State<MapWidget> with WidgetsBindingObserver {
  final _controller = _TextureController();
  late final MapWidgetController mapWidgetController;
  int? _textureId;
  AppLifecycleState? _appState;
  _MapGestureController? _mapGestureController;
  StreamSubscription<sdk.DevicePpi>? _devicePpiSubscription;
  double _deviceDensity = 1;
  late final ValueNotifier<MapTheme> _mapTheme;

  @override
  void initState() {
    super.initState();
    mapWidgetController = widget._controller ?? MapWidgetController();
    mapWidgetController
      .._appearance = widget.mapOptions.appearance
      .._maxFps = widget.mapOptions.maxFps ?? const sdk.Fps(60)
      .._powerSavingMaxFps = widget.mapOptions.powerSavingMaxFps;
    WidgetsBinding.instance.addObserver(this);
    _appState = WidgetsBinding.instance.lifecycleState;
    _mapTheme = ValueNotifier(mapWidgetController._appearance.mapTheme);
    if (widget.child != null) {
      mapWidgetController._addMapThemeChangedCallback(_onMapThemeChanged);
    }
    _initialize();
  }

  @override
  void dispose() {
    mapWidgetController._dispose();
    if (_textureId != null) {
      _controller.dispose(_textureId!);
    }
    mapWidgetController._removeMapThemeChangedCallback(_onMapThemeChanged);
    WidgetsBinding.instance.removeObserver(this);
    _devicePpiSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_textureId == null) {
      return Container(
        color: mapWidgetController._appearance.mapTheme.loadingBackground,
      );
    }

    return Stack(
      children: [
        Center(
          child: _MeasureSize(
            onChange: _updateMapSize,
            child: Listener(
              onPointerDown: (event) {
                _mapGestureController?.onPointerDownCallback(event);
              },
              onPointerMove: (event) {
                _mapGestureController?.onPointerMoveCallback(event);
              },
              onPointerUp: (event) {
                _mapGestureController?.onPointerUpCallback(event);
              },
              onPointerCancel: (event) {
                _mapGestureController?.onPointerCancelCallback(event);
              },
              child: Texture(textureId: _textureId!),
            ),
          ),
        ),
        _MapProvider(
          map: mapWidgetController._map!,
          mapTheme: _mapTheme.value,
          child: ValueListenableBuilder(
            valueListenable: mapWidgetController
                ._copyrightWidgetController.copyrightAlignment,
            builder: (_, copyrightAlignment, __) => Padding(
              padding: copyrightAlignment.edgeInsets,
              child: Align(
                alignment: copyrightAlignment.alignment,
                child: CopyrightWidget(
                  controller: mapWidgetController._copyrightWidgetController,
                ),
              ),
            ),
          ),
        ),
        if (widget.child != null)
          ValueListenableBuilder(
            valueListenable: _mapTheme,
            builder: (_, theme, __) => _MapProvider(
              map: mapWidgetController._map!,
              mapTheme: theme,
              child: widget.child!,
            ),
          ),
      ],
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_appState != state) {
      _appState = state;
      _updateMapVisibility();
    }
  }

  @override
  void didChangePlatformBrightness() {
    mapWidgetController._updateMapTheme();
  }

  Future<void> _initialize() async {
    final builder =
        await sdk.MapBuilder().apply(widget._mapOptions, widget._sdkContext);
    final map = await builder.createMap(widget._sdkContext).value;
    mapWidgetController
      .._map = map
      .._updateMapTheme();

    final provider = sdk.MapSurfaceProvider.create(map);
    mapWidgetController._provider = provider;
    final id = await _controller.initialize(provider.id);

    final renderer = sdk.MapRenderer.create(map);
    mapWidgetController
      .._renderer = renderer
      .._updateRendererFps();

    _updateMapVisibility();

    final mapGestureRecognizer = sdk.MapGestureRecognizer.create(map);
    mapWidgetController._mapGestureRecognizer = mapGestureRecognizer;
    _deviceDensity = map.camera.deviceDensity.value;
    _mapGestureController = _MapGestureController(
      mapGestureRecognizer,
      _deviceDensity,
    );
    _devicePpiSubscription = map.camera.devicePpiChannel.listen((devicePpi) {
      _mapGestureController?._mapGestureRecognizer
          .onDevicePpiChanged(devicePpi);
    });

    mapWidgetController._updateTouchEventObserver();
    for (final callback in mapWidgetController._readyMapCallbacks) {
      callback(map);
    }

    renderer.waitForRendering().then((isRendered) {
      if (isRendered) {
        setState(() {
          _textureId = id;
        });
      }
    });
  }

  void _updateMapSize(Size newSize) {
    if (newSize.width == 0.0 || newSize.height == 0.0) {
      return;
    }
    final width = (newSize.width * _deviceDensity).toInt();
    final height = (newSize.height * _deviceDensity).toInt();
    _controller.update(_textureId!, width, height);
    final screenSize = sdk.ScreenSize(width: width, height: height);
    mapWidgetController._provider?.resizeSurface(screenSize);
    mapWidgetController._map?.camera.size = screenSize;
  }

  void _updateMapVisibility() {
    if (_appState == null) {
      return;
    }
    late sdk.MapVisibilityState mapVisibilityState;
    switch (_appState!) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        mapVisibilityState = sdk.MapVisibilityState.hidden;
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        mapVisibilityState = sdk.MapVisibilityState.visible;
    }

    mapWidgetController._map?.mapVisibilityState = mapVisibilityState;
  }

  void _onMapThemeChanged(MapTheme theme) {
    _mapTheme.value = theme;
  }
}

extension _MapOptionsBackgroundColor on MapOptions {
  Color get defaultBackgroundColor {
    if (backgroundColor != null) {
      return backgroundColor!;
    }
    return appearance.mapTheme.loadingBackground;
  }
}

extension _MapBuilderApplyMapOptions on sdk.MapBuilder {
  Future<sdk.MapBuilder> apply(
    MapOptions options,
    sdk.Context sdkContext,
  ) async {
    final builder = sdk.MapBuilder()
        .setPosition(options.position)
        .setPositionPoint(options.positionPoint)
        .setZoomRestrictions(options.zoomRestrictions);

    if (options.devicePPI != null && options.deviceDensity != null) {
      builder.setDevicePpi(options.devicePPI!, options.deviceDensity!);
    } else {
      final dispatcher = WidgetsBinding.instance.platformDispatcher;
      final display = dispatcher.displays.first;
      final deviceDensity = display.devicePixelRatio;
      final deviceDpi = deviceDensity * 160.0;
      builder.setDevicePpi(
        sdk.DevicePpi(deviceDpi),
        sdk.DeviceDensity(deviceDensity),
      );
    }

    if (options.sources != null) {
      options.sources!.forEach(builder.addSource);
    } else {
      /// TODO. Для Full сборки нужно учесть, что нужно добавлять гибридный источник.
      builder.addSource(sdk.DgisSource.createDgisSource(sdkContext));
    }

    if (options.style != null) {
      builder.setStyle(options.style!);
    } else if (options.styleFuture != null) {
      final style = await options.styleFuture!.value;
      builder.setStyle(style);
    }

    builder
      ..setBackgroundColor(sdk.Color(options.defaultBackgroundColor.value))
      ..setAttribute(
        'theme',
        sdk.AttributeValue.string(options.appearance.mapTheme.name),
      );

    return builder;
  }
}

class _MapProvider extends InheritedWidget {
  final sdk.Map map;
  final MapTheme mapTheme;

  const _MapProvider({
    required this.map,
    required this.mapTheme,
    required super.child,
    // ignore: unused_element
    super.key,
  });

  @override
  bool updateShouldNotify(_MapProvider oldWidget) {
    return map.id != oldWidget.map.id || mapTheme != oldWidget.mapTheme;
  }
}

/// Метод, позволяющий получить [sdk.Map] из виджета, находящегося
/// выше по дереву.
sdk.Map? mapOf(BuildContext context) {
  return context.dependOnInheritedWidgetOfExactType<_MapProvider>()?.map;
}

/// Метод, позволяющий получить [MapTheme] из виджета, находящегося
/// выше по дереву.
MapTheme? mapThemeOf(BuildContext context) {
  return context.dependOnInheritedWidgetOfExactType<_MapProvider>()?.mapTheme;
}
