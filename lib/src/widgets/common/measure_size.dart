import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  Function(Size size) onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    final newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final Function(Size size) onChange;

  const MeasureSize({
    required this.onChange,
    required Widget super.child,
    super.key,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant MeasureSizeRenderObject renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}
