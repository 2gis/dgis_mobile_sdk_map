import 'dart:async';

import 'package:dgis_mobile_sdk_map/dgis.dart' as sdk;
import 'package:flutter/material.dart';

import 'common.dart';

class MapObjectsIdentificationPage extends StatefulWidget {
  const MapObjectsIdentificationPage({required this.title, super.key});

  final String title;

  @override
  State<MapObjectsIdentificationPage> createState() =>
      _MapObjectsIdentificationState();
}

class _MapObjectsIdentificationState
    extends State<MapObjectsIdentificationPage> {
  final sdkContext = AppContainer().initializeSdk();
  final mapWidgetController = sdk.MapWidgetController();
  final formKey = GlobalKey<FormState>();
  List<sdk.DgisObjectId> highlightedObjectIds = [];
  sdk.MapObjectManager? mapObjectManager;
  sdk.Marker? selectedObject;
  sdk.DgisSource? dgisSource;
  late sdk.SearchManager searchManager;
  late sdk.ImageLoader loader;

  @override
  void initState() {
    super.initState();
    initContext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: <Widget>[
          sdk.MapWidget(
            sdkContext: sdkContext,
            mapOptions: sdk.MapOptions(),
            controller: mapWidgetController,
          ),
        ],
      ),
    );
  }

  Future<void> initContext() async {
    searchManager = sdk.SearchManager.createOnlineManager(sdkContext);
    loader = sdk.ImageLoader(sdkContext);
    mapWidgetController
      ..getMapAsync(
        (map) {
          mapObjectManager = sdk.MapObjectManager(map);
        },
      )
      ..addObjectLongTouchCallback(_showObjectCard)
      ..addObjectTappedCallback(
        (objectInfo) async {
          final objectId = _getObjectId(objectInfo);
          if (objectId == null) {
            return;
          }

          await _setSelectedObject(objectInfo);
          dgisSource = objectInfo.item.source as sdk.DgisSource;
          await searchManager.searchByDirectoryObjectId(objectId).value.then(
                _showDirectoryObjectCard,
              );
        },
      );
  }

  void _showObjectCard(sdk.RenderedObjectInfo objectInfo) {
    final objectId = _getObjectId(objectInfo);
    if (objectId == null) {
      return;
    }

    _setSelectedObject(objectInfo);
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('RenderedObjectInfo'),
          content: Form(
            key: formKey,
            child: SizedBox(
              height: 250,
              width: 50,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    'ID: ${objectId.objectId}',
                  ),
                  Text(
                    'ClosestViewportPoint: (${objectInfo.closestViewportPoint.x}, ${objectInfo.closestViewportPoint.y})',
                  ),
                  Text(
                    'ClosestMapPoint: (${objectInfo.closestMapPoint.latitude.value}, ${objectInfo.closestMapPoint.longitude.value})',
                  ),
                  Text(
                    'LevelId: ${objectInfo.item.levelId?.value}',
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showDirectoryObjectCard(sdk.DirectoryObject? objectInfo) {
    if (objectInfo == null) {
      return;
    }

    _setHighlighted(objectInfo);
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(objectInfo.title),
          content: Form(
            key: formKey,
            child: SizedBox(
              height: 250,
              width: 50,
              child: ListView(
                shrinkWrap: true,
                children: _buildObjectInfoWidget(objectInfo),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildObjectInfoWidget(sdk.DirectoryObject objectInfo) {
    /// Main info.
    final infoWidgets = <Widget>[
      Text(objectInfo.subtitle),
      Text('ID: ${objectInfo.id?.objectId}'),
    ];
    if (objectInfo.description.isNotEmpty) {
      infoWidgets.add(Text(objectInfo.description));
    }
    infoWidgets.add(() {
      String rating;
      final ratingValue = objectInfo.reviews?.rating;
      if (ratingValue != null) {
        rating = 'Rating: ${ratingValue.toStringAsFixed(2)}';
      } else {
        rating = 'There is no rating for this organization';
      }
      return Text(rating);
    }());
    final fiasCode = objectInfo.address?.fiasCode;
    if (fiasCode != null) {
      infoWidgets.add(Text(fiasCode));
    }

    /// Address
    infoWidgets.addAll([const SizedBox(height: 10), const Text('Location:')]);
    final formattedAddress =
        objectInfo.formattedAddress(sdk.FormattingType.full);
    if (formattedAddress != null) {
      infoWidgets.add(
        Text(
          '${formattedAddress.drilldownAddress}, ${formattedAddress.streetAddress}, ${formattedAddress.addressComment}, ${formattedAddress.postCode}',
        ),
      );
    }
    final position = objectInfo.markerPosition?.point;
    if (position != null) {
      infoWidgets.add(
        Text(
          'Latitude: ${position.latitude.value.toStringAsFixed(6)}, Longitude: ${position.longitude.value.toStringAsFixed(6)}',
        ),
      );
    }

    return infoWidgets;
  }

  sdk.DgisObjectId? _getObjectId(sdk.RenderedObjectInfo objectInfo) {
    if (objectInfo.item.item is! sdk.DgisMapObject) {
      return null;
    }
    return (objectInfo.item.item as sdk.DgisMapObject).id;
  }

  Future<void> _setSelectedObject(sdk.RenderedObjectInfo objectInfo) async {
    if (selectedObject == null) {
      final iconImage =
          await loader.loadPngFromAsset('assets/icons/pin.png', 160, 160);
      final options = sdk.MarkerOptions(
        icon: iconImage,
        position: objectInfo.closestMapPoint,
        anchor: const sdk.Anchor(y: 1),
        iconWidth: const sdk.LogicalPixel(5),
      );
      selectedObject = sdk.Marker(options);
      mapObjectManager?.addObject(selectedObject!);
    } else {
      selectedObject?.position = objectInfo.closestMapPoint;
    }
  }

  void _setHighlighted(sdk.DirectoryObject objectInfo) {
    if (objectInfo.id == null) {
      return;
    }
    dgisSource?.setHighlighted(highlightedObjectIds, false);
    highlightedObjectIds = <sdk.DgisObjectId>[objectInfo.id!];
    for (final entrance in objectInfo.entrances) {
      highlightedObjectIds.add(entrance.id);
    }
    dgisSource?.setHighlighted(highlightedObjectIds, true);
  }
}
