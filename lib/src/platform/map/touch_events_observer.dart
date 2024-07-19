import '../../generated/dart_bindings.dart' as sdk;

/// Класс для обработки жестов карты.
abstract class TouchEventsObserver {
  void onTap(sdk.ScreenPoint point) {}
  void onLongTouch(sdk.ScreenPoint point) {}
  void onDragBegin(sdk.DragBeginData data) {}
  void onDragMove(sdk.ScreenPoint point) {}
  void onDragEnd() {}
}
