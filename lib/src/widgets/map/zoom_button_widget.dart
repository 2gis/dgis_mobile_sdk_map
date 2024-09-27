import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widget_shadows.dart';

class ZoomButton extends StatefulWidget {
  final Color backgroundColor;
  final Color pressedBackgroundColor;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final bool isEnabled;
  final VoidCallback onClick;
  final VoidCallback onRelease;
  final String iconResource;

  const ZoomButton({
    required this.backgroundColor,
    required this.pressedBackgroundColor,
    required this.activeIconColor,
    required this.inactiveIconColor,
    required this.onClick,
    required this.onRelease,
    required this.iconResource,
    this.isEnabled = true,
    super.key,
  });

  @override
  State<ZoomButton> createState() => _ZoomButtonState();
}

class _ZoomButtonState extends State<ZoomButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        if (widget.isEnabled) {
          setState(() {
            isPressed = true;
            widget.onClick();
          });
        }
      },
      onTapUp: (details) {
        setState(() {
          widget.onRelease();
          isPressed = false;
        });
      },
      onLongPressUp: () {
        setState(() {
          widget.onRelease();
          isPressed = false;
        });
      },
      onLongPressCancel: () {
        setState(() {
          widget.onRelease();
          isPressed = false;
        });
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isPressed
              ? widget.pressedBackgroundColor
              : widget.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: const [
            WidgetShadows.mapWidgetBoxShadow,
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            widget.iconResource,
            fit: BoxFit.none,
            colorFilter: ColorFilter.mode(
              widget.isEnabled
                  ? widget.activeIconColor
                  : widget.inactiveIconColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
