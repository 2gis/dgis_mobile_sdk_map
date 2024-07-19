import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;

import '../../generated/dart_bindings.dart' as sdk;

/// Класс для загрузки изображений.
class ImageLoader {
  final sdk.Context _sdkContext;

  ImageLoader(this._sdkContext);

  /// Загрузить PNG изображение из assets.
  Future<sdk.Image> loadPngFromAsset(String name, int height, int width) async {
    final data = await rootBundle.load(name);
    return _makeImage(data, sdk.ImageFormat.pNG, height, width);
  }

  /// Загрузить PNG изображение из файла.
  Future<sdk.Image> loadPngFromFile(String path, int height, int width) async {
    final data = await _loadFromFile(path);
    return _makeImage(data, sdk.ImageFormat.pNG, height, width);
  }

  /// Загрузить SVG изображение из assets.
  Future<sdk.Image> loadSVGFromAsset(String name) async {
    final data = await rootBundle.load(name);
    return _makeImage(data, sdk.ImageFormat.sVG);
  }

  /// Загрузить SVG изображение из файла.
  Future<sdk.Image> loadSVGFromFile(String path) async {
    final data = await _loadFromFile(path);
    return _makeImage(data, sdk.ImageFormat.sVG);
  }

  /// Загрузить Lottie JSON из assets.
  Future<sdk.Image> loadLottieFromAsset(String name) async {
    final data = await rootBundle.load(name);
    return _makeImage(data, sdk.ImageFormat.lOTTIE_JSON);
  }

  /// Загрузить Lottie JSON из файла.
  Future<sdk.Image> loadLottieFromFile(String path) async {
    final data = await _loadFromFile(path);
    return _makeImage(data, sdk.ImageFormat.lOTTIE_JSON);
  }

  Future<ByteData> _loadFromFile(String path) async {
    final fileUri = Uri.parse(path);
    final file = File.fromUri(fileUri);
    final bytes = await file.readAsBytes();
    return ByteData.view(bytes.buffer);
  }

  sdk.Image _makeImage(
    ByteData data,
    sdk.ImageFormat format, [
    int height = 0,
    int width = 0,
  ]) {
    final loader = _DataImageLoader(data, format, height, width);
    return sdk.createImage(_sdkContext, loader);
  }
}

class _DataImageLoader extends sdk.ImageLoader {
  final sdk.ImageData _image;

  _DataImageLoader(ByteData data, sdk.ImageFormat format, int height, int width)
      : _image = sdk.ImageData(
          data: data,
          format: format,
          size: sdk.ScreenSize(height: height, width: width),
        );

  @override
  sdk.ImageData load() => _image;
}
