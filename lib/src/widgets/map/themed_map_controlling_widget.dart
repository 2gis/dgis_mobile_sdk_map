import 'package:flutter/widgets.dart';

import 'map_widget_color_scheme.dart';

/// Базовый класс для реализации виджетов карты, способных изменять цветовую схему
/// в зависимости от признака colorMode темы карты MapTheme.
/// Должен использоваться совместно с ThemedMapControllingWidgetState.
abstract class ThemedMapControllingWidget<T extends MapWidgetColorScheme>
    extends StatefulWidget {
  final T light;
  final T dark;

  const ThemedMapControllingWidget({
    required this.light,
    required this.dark,
    super.key,
  });
}
