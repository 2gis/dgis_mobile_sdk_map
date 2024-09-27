import 'dart:async';
import 'dart:isolate';

import 'package:async/async.dart';
import 'package:dgis_mobile_sdk_map/dgis.dart' as sdk;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common.dart';
import 'fps_graph_painter.dart';
import 'camera_paths.dart';

class BenchmarkPage extends StatefulWidget {
  const BenchmarkPage({required this.title, super.key});

  final String title;

  @override
  State<BenchmarkPage> createState() => _BenchmarkPageState();
}

class _BenchmarkPageState extends State<BenchmarkPage> {
  final sdkContext = AppContainer().initializeSdk();
  final mapWidgetController = sdk.MapWidgetController();
  sdk.Map? sdkMap;
  CancelableOperation<sdk.CameraAnimatedMoveResult>? moveCameraCancellable;
  StreamSubscription<sdk.Location?>? locationSubscription;

  final List<double> fpsValues = [];
  double lastFps = 0;
  final ReceivePort receivePort = ReceivePort();
  Isolate? fpsIsolate;

  @override
  void initState() {
    super.initState();
    initContext();
    _startFpsTracking();
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    fpsIsolate?.kill(priority: Isolate.immediate);
    receivePort.close();
    super.dispose();
  }

  Future<void> _startFpsTracking() async {
    fpsValues.clear();

    fpsIsolate = await Isolate.spawn(_fpsTrackingIsolate, receivePort.sendPort);

    mapWidgetController.fpsChannel.listen((fps) {
      receivePort.sendPort.send(fps.value.toDouble());
    });

    receivePort.listen((message) {
      setState(() {
        lastFps = message as double;
        fpsValues.add(lastFps);

        if (fpsValues.length > 100) {
          fpsValues.removeAt(0);
        }
      });
    });
  }

  static void _fpsTrackingIsolate(SendPort sendPort) {
    final localFpsValues = <double>[];

    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      final fps = message as double;
      localFpsValues.add(fps);

      if (localFpsValues.length > 100) {
        localFpsValues.removeAt(0);
      }

      final averageFps =
          localFpsValues.reduce((a, b) => a + b) / localFpsValues.length;
      sendPort.send(averageFps);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _showActionSheet,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          sdk.MapWidget(
            sdkContext: sdkContext,
            mapOptions: sdk.MapOptions(),
            controller: mapWidgetController,
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: FPSGraph(
              fpsValues: fpsValues,
              lastFps: lastFps,
              averageFps: _averageFps,
              onePercentLow: _calculatePercentile(0.01),
              zeroPointOnePercentLow: _calculatePercentile(0.001),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initContext() async {
    mapWidgetController
      ..getMapAsync((map) {
        sdkMap = map;
      })
      ..copyrightAlignment = Alignment.bottomLeft;
  }

  void _showActionSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Map scenarios'),
        actions: CameraPathType.values.map((pathType) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, pathType.toString());
              _testCamera(pathType);
            },
            child: Text(
              pathType.toString().split('.').last,
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _testCamera(CameraPathType pathType) {
    _startFpsTracking();
    locationSubscription?.cancel();
    locationSubscription = null;
    if (sdkMap == null) {
      return;
    }

    final selectedPath = cameraPaths[pathType];
    if (selectedPath != null) {
      sdkMap?.camera.position = sdk.CameraPosition(
        point: selectedPath.first.$1.point,
        zoom: const sdk.Zoom(13),
      );
      _move(0, selectedPath);
    }
  }

  Future<void> _move(int index, CameraPath path) async {
    if (index >= path.length) {
      return;
    }
    final tuple = path[index];
    moveCameraCancellable =
        sdkMap?.camera.moveToCameraPosition(tuple.$1, tuple.$2, tuple.$3);
    await moveCameraCancellable?.value.then((value) {
      _move(index + 1, path);
    });
  }

  double get _averageFps {
    if (fpsValues.isEmpty) return 0;
    return fpsValues.reduce((a, b) => a + b) / fpsValues.length;
  }

  double _calculatePercentile(double percentile) {
    if (fpsValues.isEmpty) return 0;
    final sortedValues = List<double>.from(fpsValues)..sort();
    final index = (percentile * sortedValues.length).ceil() - 1;
    return sortedValues[index];
  }
}

class FPSGraph extends StatelessWidget {
  final List<double> fpsValues;
  final double lastFps;
  final double averageFps;
  final double onePercentLow;
  final double zeroPointOnePercentLow;
  final double maxFps;

  const FPSGraph({
    required this.fpsValues,
    required this.lastFps,
    required this.averageFps,
    required this.onePercentLow,
    required this.zeroPointOnePercentLow,
    this.maxFps = 60,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.black.withOpacity(0.5),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomPaint(
              painter: FPSGraphPainter(fpsValues: fpsValues, maxFps: maxFps),
              child: Container(),
            ),
          ),
          Text(
            'FPS: ${lastFps.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            'Avg: ${averageFps.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            '1%: ${onePercentLow.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            '0.1%: ${zeroPointOnePercentLow.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
