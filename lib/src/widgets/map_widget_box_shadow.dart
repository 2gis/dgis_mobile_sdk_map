// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';

// Испльзуется как BoxShadow в круглых виджетах карты.
class MapWidgetBoxShadow extends BoxShadow {
  @override
  final Color color = Colors.black.withOpacity(0.2);
  @override
  final BlurStyle blurStyle = BlurStyle.normal;
  @override
  final double spreadRadius = 0;
  @override
  final double blurRadius = 3;
  @override
  final Offset offset = const Offset(0, 2);
}
