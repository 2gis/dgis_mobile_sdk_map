import 'package:flutter/widgets.dart';

class NoOverscrollBehavior extends ScrollBehavior {
  const NoOverscrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
